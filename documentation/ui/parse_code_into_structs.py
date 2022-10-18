##### IMPORTS

import json # to write out our documentation to a json file
from json import JSONEncoder
import re # regular expressions for parsing documentation
from dataclasses import dataclass, field # create mutable structs with named components
from argparse import ArgumentParser # parse command line arguments
import os # Get relative filepaths
CURRENT_DIR = os.path.dirname(__file__)
import sys # Redirect output to a text file so it's searchable
sys.stdout = open(os.path.join(CURRENT_DIR, "python_debug_output.txt"), "w")
from callback_file_finder import get_all_callback_filepaths
import pickle # Load filepaths dict from pickle file

##### COMMAND LINE ARGUMENT PARSING

parser = ArgumentParser(description="This script attempts to unify the documentation style for callbacks.")
parser.add_argument('--load_filepaths', '-lf', action="store_true", help="Instead of re-searching for the filepaths each time the script is run, can use this argument to load them from a pickle file.")

args = parser.parse_args()
load_filepaths = args.load_filepaths

##### REGEX EXPRESSIONS WE WILL USE

# Finds a callback declaration/ending line in .h file - Looks for a callback declaration/ending macro followed by the callback name
CALLBACK_DECLARATION_LINE_H_REGEX = re.compile("[\s]*(BEGIN_COMPONENT_CALLBACK_CLASS|BEGIN_COMPONENT_CALLBACK_HEADER|BEGIN_DERIVED_COMPONENT_CALLBACK_CLASS|BEGIN_DERIVED_DECORATED_COMPONENT_CALLBACK_CLASS)\((?P<callback>[a-zA-Z]+)")
CALLBACK_ENDING_LINE_H_REGEX = re.compile("[\s]*(END_DERIVED_COMPONENT_CALLBACK_CLASS|END_COMPONENT_CALLBACK_CLASS)\((?P<callback>[a-zA-Z]+)")

# Finds a callback and its name from .cpp file - looks for CallbackName::RegType CallbackName::methods
CALLBACK_DECLARATION_LINE_CPP_REGEX = re.compile("[\s]*(?P<callback>[a-zA-Z]+)::RegType[\s]*(?P=callback)::methods\[\]")

# Looks for user property documentation in .h file
# User property saved as a member variable: look for m_[prop name] line followed by the comment // @user_prop: property_name: documentation
SAVED_PROPERTY_LINE_REGEX = re.compile("[\s]*([a-zA-Z_\:\*]+)[\s]*(?P<property_variable>m_[a-zA-Z_]+)([\s]*=[\s]*([0-9a-zA-Z_\.]+))?;[\s]*(// @user_prop: (?P<property_name>[a-zA-Z_]+):(?P<doc>.*))")
# User property not saved as a member variable (floating). Look for a comment line of the form // @ floating_user_prop: property_name: documentation
FLOATING_PROPERTY_LINE_REGEX = re.compile("[\s]*// @floating_user_prop: (?P<property_name>[a-zA-Z_]+):(?P<doc>.*)")

# Reads comment lines as documentation lines
DOCUMENTATION_LINE_REGEX = re.compile("[\s]*//[\s]*")
# These are the functions we want to find - functions declared as callback methods
CONTEXT_METHOD_DECLARATION_LINE_REGEX = re.compile("[\s]*DECLARE_CALLBACK_METHOD_FOR_CONTEXT\((?P<function_name>[a-zA-Z]+)\)")
# Finds arguments for these functions by looking for the argument name in args->NextArgument()
METHOD_ARGUMENT_READING_LINE_REGEX = re.compile("(args\->NextArgument<(?P<argument>[a-zA-Z]+)>\(\))")

##### DATA STRUCTURES

@dataclass
class Argument:
    """
    Represents an argument for a callback method. We save the name and whether it's optional
    """
    name: str
    optional: bool

@dataclass
class Function:
    """
    Represents a callback method. Currently the return type is always empty as no easy way to parse it with regex, until we implement a symbol system for callbacks.
    Also gathers a list of arguments (if any) and documentation for the method (if any).
    """
    name: str
    return_type: str = ""
    arguments: list = field(default_factory=list)
    doc: str = ""
    
    def __str__(self):
        return f"\t {self.return_type}\t{self.name}({self.arguments})\n\t\tDocumentation: {self.doc}\n"

    def __hash__(self):
        return hash(self.name)

@dataclass
class Property:
    """
    Represents a user property. Gets the name in UiEd, the name in code (variable name, doesn't always exist as some user properties used once and not saved), and the documentation if any.
    """
    name: str
    variable: str = "" # This is null for floating properties
    doc: str = "" # This is null unless documentation is available on confluence or in code
    
    def __str__(self):
        return f"Name: {self.name}\nVariable: {self.variable}"
  
    def __hash__(self):
        return hash(self.name)

@dataclass
class Callback:
    """
    Represents a callback. Has a name, area (Battle, Campaign, ...), documentation (if it exists in code), user_properties (if any), and methods (if any).
    """
    name: str
    area: str = ""
    doc: str = ""
    user_properties: set = field(default_factory=set)
    functions: set = field(default_factory=set)
    is_callback: bool = True # Putting in code so that it will be encoded in the json
    
    def __str__(self):
        functions_pretty = []
        for function in self.functions:
            functions_pretty.append(function)
        functions_pretty = "\n".join(str(func) for func in functions_pretty)
        return f"\n\n-----\n\nName: {self.name}\nDoc: {self.doc}\nUser Properties: {self.user_properties}\nFunctions:\n{functions_pretty}\n\n-----\n"

    def __hash__(self):
        return hash(self.name)

##### JSON SERIALIZATION HELPERS

def clean_nones(value):
    """
    Recursively removes all 'None' values from dictionaries lists and sets, and returns the result as a new dictionary/list/set.
    Used to not save empty lists, documentations, etc in json.
    """
    if isinstance(value, list):
        return [clean_nones(x) for x in value if x is not None]
    elif isinstance(value, dict):
        return {
            key: clean_nones(val)
            for key, val in value.items()
            # Filter None values, empty strings, strings of just whitespace, empty lists and empty sets
            if (val is not None and val != "" and val != [] and val != set() and not (isinstance(val, str) and val.isspace()))
        }
    else:
        return value

class CallbackEncoder(JSONEncoder):
    """
    Encodes our callback dataclass into json by first encoding all member variables as dictionaries.
    Also cleans out empty/None values before encoding.
    """
    def default(self, o):
        if isinstance(o, set):
            encodings = []
            for i in o:
                encodings.append(clean_nones(i.__dict__))
            return encodings
        else:
            return clean_nones(o.__dict__)

##### HELPER FUNCTIONS

def should_ignore_line_when_looking_for_documentation(line):
    """ 
    We look above function and class definitions to find documentations for them through comment lines.
    However these lines are not always immediately above the definitions.
    Here, we filter out lines that are acceptable to be between a function/class declaration and its documentation.
    We also filter out lines that are not of interest to the documentation, such as the class or author names.
    """
    line = line.strip().lower()
    if line == "":
        return True # empty line
    if line.startswith("class "):
        return True # class declaration line
    if line.startswith("public "):
        return True # class declaration line
    if line.startswith("// author:") or line.startswith("// class:") or line.startswith("// function:"):
        return True # comment line naming author or class name
    if line.startswith("/////") or line.startswith("//=====") or line.startswith("//---") or line == "//" or line.endswith("////"):
        return True # delineation line ////////////////
    return False        

def get_documentation_above_line(lines, index):
    """
    Search above a function or class declaration line to find relevant documentation for them.
    """
    doc = []
    for line in lines[index-1:0:-1]:
        if should_ignore_line_when_looking_for_documentation(line):
            continue
        parse = DOCUMENTATION_LINE_REGEX.match(line)
        if parse is not None:
            doc.append(line[parse.end():])
        else:
            doc.reverse()
            doc = "\n".join(doc)
            doc = doc.strip().removeprefix("Purpose:").removeprefix("@documentation:").strip()
            return doc

def find_new_macro_begin_and_end(callback, file_lines_h):
    """
    The new macro style does not have a declaration at the start and end of a callback, instead only a single one at the end.
    We find the indices by finding that declaration and then finding the associate class declaration.
    """
    start_index_h = 0
    end_index_h = 0
    for (index, line) in enumerate(file_lines_h):
        new_macro = "COMPONENT_CALLBACK_CLASS(" + callback.name + ")"
        new_macro_derived = "COMPONENT_CALLBACK_CLASS_DERIVED(" + callback.name + ","
        line = line.strip()
        if line.startswith(new_macro) or line.startswith(new_macro_derived):
            end_index_h = index
            break

    for (index, line) in enumerate(file_lines_h[end_index_h:0:-1]):
        line = line.strip()
        if line.startswith("class " + callback.name):
            start_index_h = end_index_h - index
            break
            
    return start_index_h, end_index_h

def get_args_for_function(lines):
    next_arg_optional = False
    args = []
    for line in lines:
        if "args->HasMoreArguments()" in line:
            next_arg_optional = True
        parse = METHOD_ARGUMENT_READING_LINE_REGEX.search(line)
        if parse is not None:
            args.append(Argument(parse.group("argument"), next_arg_optional))
    return args

##### CORE FUNCTIONS

def get_list_of_callbacks(group, filepath):
    """
    Traverse cpp file once to get all callbacks.
    """
    filepath_cpp = filepath[1]
    callbacks = set()
    
    with open(filepath_cpp, 'r') as cpp_file :
        file_lines = cpp_file.readlines()
    
    for (index, line) in enumerate(file_lines):
        declaration = CALLBACK_DECLARATION_LINE_CPP_REGEX.match(line)
        if declaration is not None:
            name = declaration.group("callback")
            callback = Callback(name)
            callback.doc = get_documentation_above_line(file_lines, index)
            callback.area = group
            callbacks.add(callback)
    
    return callbacks
  
def get_info_for_callback(callback, filepath):
    """
    Gets all the info related to a specific callback: list of functions and user properties with their documentations.
    Appends all info to the callback supplied as first argument, does not return anything.
    The second argument should be the filepath (.h and .cpp) to search for callbacks.
    """
    filepath_h, filepath_cpp = filepath[0], filepath[1]
    with open(filepath_h, 'r') as h_file :
        file_lines_h = h_file.readlines()
    
    with open(filepath_cpp, 'r') as cpp_file :
        file_lines_cpp = cpp_file.readlines()
    
    ## Callback + Documentation Finder
    
    start_index_h = 0
    end_index_h = 0
    for (index, line) in enumerate(file_lines_h):
        parse = CALLBACK_DECLARATION_LINE_H_REGEX.match(line)
        if parse is not None:
            if parse.group("callback") == callback.name:
                start_index_h = index
                break
    for (index, line) in enumerate(file_lines_h[start_index_h:]):
        parse = CALLBACK_ENDING_LINE_H_REGEX.match(line)
        if parse is not None:
            if parse.group("callback") == callback.name:
                end_index_h = start_index_h + index
                break

    if start_index_h == 0 or end_index_h == 0:
        # The new macro style has only one declaration at the end instead of two delineating the callback
        # For now, it is only a backup as only a handful of callbacks use the new macro style
        # Eventually, this check may be done first
        start_index_h, end_index_h = find_new_macro_begin_and_end(callback, file_lines_h)
        if start_index_h == 0 or end_index_h == 0:
            # Still could not find indices
            print(f"Why was the start index {start_index_h} and the end index {end_index_h} for the callback {callback.name}? This was in file {filepath_h}")
            return
    
    # Documentation for the callback itself could be found in either the .h file or the .cpp file
    h_file_documentation = get_documentation_above_line(file_lines_h, start_index_h)
    # Keep only the larger documentation (as the same documentation is often repeated in both, sometimes with minor variations)
    callback.doc = max(callback.doc, h_file_documentation, key=len)

    ## Function and User Property Acquisition

    callback_properties = set()
    callback_floating_properties = set()
    functions = set()
    for line in file_lines_h[start_index_h:end_index_h]:
        saved_property_search = SAVED_PROPERTY_LINE_REGEX.match(line)
        if saved_property_search is not None:
            name = saved_property_search.group("property_name")
            variable = saved_property_search.group("property_variable")
            doc = saved_property_search.group("doc")
            callback_properties.add(Property(name, variable, doc))
            continue
        floating_property_search = FLOATING_PROPERTY_LINE_REGEX.match(line)
        if floating_property_search is not None:
            name = floating_property_search.group("property_name")
            doc = floating_property_search.group("doc")
            callback_floating_properties.add(Property(name, "", doc))
            continue
        function_search = CONTEXT_METHOD_DECLARATION_LINE_REGEX.match(line)
        if function_search is not None:
            functions.add(Function(function_search.group("function_name")))

    callback.user_properties = callback_properties.union(callback_floating_properties)
    
    ## Function Documentation finding - done in .cpp file
    # First find where the callback body is
    start_index_cpp = 0
    end_index_cpp = len(file_lines_cpp) - 1
    
    for (index, line) in enumerate(file_lines_cpp):
        parse = CALLBACK_DECLARATION_LINE_CPP_REGEX.match(line)
        if parse is not None:
            if parse.group("callback") == callback.name:
                start_index_cpp = index
                break
    # In .cpp files, we do not have a macro declaring the end of the callback
    # Therefore we keep going until we find the next callback
    for (index, line) in enumerate(file_lines_cpp[start_index_cpp:]):
        parse = CALLBACK_DECLARATION_LINE_CPP_REGEX.match(line)
        if parse is not None:
            if parse.group("callback") != callback.name:
                end_index_cpp = start_index_cpp + index
                break
 
    # end index will be unchanged for last callback in file
    if start_index_cpp == 0:
        raise Exception(f"Why is start index {start_index_cpp} and end index {end_index_cpp} for callback {callback.name}?")
  
    for function in functions:
        text_to_search_for = "DEFINE_CALLBACK_METHOD_FOR_CONTEXT(" + callback.name + ", " + function.name
        function_start_index = 0
        function_end_index = 0
        open_braces = 0
        close_braces = 0
        matching_started = False
        for (index, line) in enumerate(file_lines_cpp[start_index_cpp:end_index_cpp]):
            if not matching_started and line.strip().startswith(text_to_search_for):
                function.doc = get_documentation_above_line(file_lines_cpp, index + start_index_cpp)
                function_start_index = index + start_index_cpp + 1
                matching_started = True
            if matching_started:
                open_braces += line.count("{")
                close_braces += line.count("}")
                if open_braces == close_braces and open_braces > 0:
                    function_end_index = index + start_index_cpp + 1
                    break
        function.args = get_args_for_function(file_lines_cpp[function_start_index:function_end_index])

    callback.functions = functions
    
def generate_metadata_from_filepath(group, filepath):
    """
    For a given filepath, this function gathers all documentation for all callbacks in that filepath
    And then appends that data at the end of the metada.json file
    """
    callbacks = get_list_of_callbacks(group, filepath)
    json_reps = []
    for callback in callbacks:
        get_info_for_callback(callback, filepath)
        print("INFO FOR CALLBACK: ", callback)
        json_reps.append("\t" + json.dumps({callback.name: callback}, indent=4, cls=CallbackEncoder).removeprefix("{").removesuffix("}").strip())
        
    with open(os.path.join(CURRENT_DIR, '../../UI/metadata.json'), 'r+') as file:
        lines = file.readlines()
        lines[-2] = lines[-2].replace("}", "},")
        lines[-1:-1] = ",\n".join(json_reps) + "\n"
        file.seek(0)
        for line in lines:
            file.write(line)

##### FUNCTION CALLING

if load_filepaths:
    with open(os.path.join(CURRENT_DIR, 'filepaths.pkl'), 'rb') as file:
        filepaths = pickle.load(file)
else:
    filepaths = get_all_callback_filepaths()

for group in filepaths.keys():
    print("\n", group, ":\n-----------------\n")
    for path in filepaths[group]:
        print(path)
        generate_metadata_from_filepath(group, path)