

--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend


--- @related_topic lua Lua Language
--- @dont_prepend_class
--- @desc Lua is an interpreted language that is used for scripting in Total War. It's lightweight, fast, and easy to use.
--- @desc Lua instructions are written in a text file, which is generally given a <code>.lua</code> file extension. The game looks to load certain script files when loading, and may be configured to load specific scripts when loading a particular campaign or battle.
--- @desc Version 5.1 of lua is used in Total War scripting - the latest at time of writing is version 5.3.5.
--- @desc Whitespace in lua is ignored, so scripts can be spaced out according to the scripters preference. Lua statements may optionally be terminated with a semicolon. Individual lines may be commented with <code>--</code> - this causes the rest of the line to be ignored. Blocks of script of any size may be commented with <code>--[[ script ]]</code>. These blocks may not be nested, however.
--- @desc Lua is case-sensitive, so variables named <code>value</code>, <code>Value</code> and <code>VALUE</code> are all different. This is a common source of bugs.
--- @example -- this line is commented
--- @example --[[
--- @example this line is also commented
--- @example ]]
--- @example value = 6
--- @example print(value);		-- semicolon optional
--- @example print(Value)
--- @result 6
--- @result nil



--- @section More Information
--- @desc More information about lua can be found on the following sites:
--- @desc <table class="simple"><tr><td><a href="https://www.lua.org">https://www.lua.org</a></td><td>Lua homepage.</td></tr>
--- @desc <tr><td><a href="https://www.lua.org/demo.html">https://www.lua.org/demo.html</a></td><td>Lua demo site - allows snippets of script to be tested outside of the game (very useful).</td></tr>
--- @desc <tr><td><a href="https://www.lua.org/manual/5.1/">https://www.lua.org/manual/5.1/</a></td><td>The lua manual.</td></tr>
--- @desc <tr><td><a href="http://lua-users.org/wiki/">http://lua-users.org/wiki/</a></td><td>Lua wiki - contains useful information about supplied libraries.</td></tr>
--- @desc <tr><td><a href="https://www.tutorialspoint.com/lua/">https://www.tutorialspoint.com/lua/</a></td><td>Lua tutorial - others are available.</td></tr></table>


--- @section Lua Data Types
--- @desc Lua supports only eight data types, six of which are documented further down this page:
--- @desc <table class="simple"><tr><th>Data Type</th><th>Description</th></tr>
--- @desc <tr><td>@nil</td><td>The absence of a value.</td></tr>
--- @desc <tr><td>@boolean</td><td><code>true</code>/<code>false</code> values.</td></tr>
--- @desc <tr><td>@number</td><td>Floating-point numeric values.</td></tr>
--- @desc <tr><td>@string</td><td>Text values.</td></tr>
--- @desc <tr><td>@function</td><td>Executable chunks of script.</td></tr>
--- @desc <tr><td>@table</td><td>Dynamically-sized key/value lists, may be used to build complex data structures.</td></tr>
--- @desc <tr><td>@userdata</td><td>Objects provided by the host program to lua, with an interface on which script may make function calls.</td></tr>
--- @desc <tr><td><code>thread</code></td><td>Represents independent threads of execution - not supported in Total War scripting.</td></tr></table>


--- @section Local and Global Variables
--- @desc Variables created in lua are global by default, which means they are accessible across the entire scope of the script. Variables can optionally be declared with local scope, whereby they only persist for the lifetime of the block in which they are declared. It is strongly encouraged to declare variables with local scope unless there is a compelling reason to do otherwise, as it lessens the risk of them being accessed or overwritten by accident.
--- @example -- global and local variable declarations
--- @example g_var_one = 10
--- @example local l_var_one = 20
--- @example 
--- @example -- declarations within a block
--- @example if g_var_one then
--- @example 	g_var_two = 20
--- @example 	local l_var_two = 30	-- will fall out of scope as the block ends
--- @example end
--- @example 
--- @example print("g_var_one: " .. tostring(g_var_one))
--- @example print("l_var_one: " .. tostring(l_var_one))
--- @example print("g_var_two: " .. tostring(g_var_two))
--- @example print("l_var_two: " .. tostring(l_var_two))
--- @result g_var_one: 10
--- @result l_var_one: 20
--- @result g_var_two: 20
--- @result l_var_two: nil


--- @section if statements
--- @desc An <code>if</code> statement may be used to perform a logical test and, based on the boolean result of that test, execute different blocks of instruction. An <code>if</code> statement will execute a block of script specified by a mandatory <code>then</code> operator if the logical test evaluates to <code>true</code>, or a second optional block specified by an <code>else</code> operator if it doesn't. Each <code>if</code> statement must be terminated by the keyword <code>end</code>.
--- @desc An <code>else</code> operator following another <code>if</code> statement may be combined into an <code>elseif</code> operator. Converting nested <code>if</code> statements to <code>elseif</code> operators in this way saves on having to terminate each <code>if</code> statement with <code>end</code> - see the example below.
--- @example t = true
--- @example f = false
--- @example 
--- @example if t == true then
--- @example 	print("t is true")
--- @example end
--- @example 
--- @example if f == true then
--- @example 	print("f is true")
--- @example else
--- @example 	print("f is false")
--- @example end
--- @example 
--- @example n = 28
--- @example 
--- @example if n < 5 then
--- @example 	print("n is less than 5")
--- @example elseif n < 10 then
--- @example 	print("n is less than 10")
--- @example elseif n < 15 then
--- @example 	print("n is less than 15")
--- @example elseif n < 20 then
--- @example 	print("n is less than 20")
--- @example else
--- @example 	print("n is greater than or equal to 20")
--- @example end
--- @result t is true
--- @result f is false
--- @result n is greater than or equal to 20


--- @section Conditional Operators
--- @desc Conditional tests may be performed by structures such as <code>if</code> statements, <code>while</code> loops and <code>repeat</code> loops to make decisions about what scripts to execute. Any values can be evaluated in a conditional test - non-boolean values may be evaluated in a boolean manner as follows:<ul>
--- @desc <li><code>false</code> boolean values, and <code>nil</code> values, evaluate to <code>false</code>.</li>
--- @desc <li>Any other value evaluates to <code>true</code> (including the number 0, which evaluates to <code>false</code> in C).</li></ul>
--- @desc The logical operator <code>not</code> may be used to negate the result of a boolean - if passed a <code>true</code> value it returns <code>false</code>, and if passed a <code>false</code> value it returns <code>true</code>. The value returned by the <code>not</code> operator is always boolean, even if the value supplied was not. The statement <code>x = not not x</code> converts x to a boolean value, therefore.
--- @desc The logical operators <code>and</code> and <code>or</code> may be used to assess multiple boolean conditions together. The <code>and</code> operator returns <code>true</code> if both of the expressions passed to it evaluate to <code>true</code> themselves. The <code>or</code> operator returns the second value passed to it if the first evaluates to <code>false</code>, otherwise the first value is returned. Unlike <code>and</code>, <code>not</code> and other comparison operators, therefore, <code>or</code> can return something other than a boolean value. This can be useful for setting default values for a variable - see the example below.
--- @desc The lua interpreter reads forward when performing conditional tests, and will not evaluate expressions that it doesn't need to. For example, if the first expression passed to an <code>and</code> operator evaluates to <code>false</code> then the second is never evaluated. Likewise, if the first expression passed to an <code>or</code> operator evaluates to <code>true</code> then the second expression is never evaluated (and the first is returned). These constructs can both be useful in different ways - see the examples below.
--- @desc The <code>not</code> operator has precedence (meaning it gets evaluated first), followed by the <code>and</code> operator and finally the <code>or</code> operator. Parenthesis <code>()</code> can be used to override the natural order of precedence.
--- @new_example Relying on conversion to boolean to test existence of value
--- @example num_value = 10
--- @example 
--- @example -- A number of any value evaluates to true.
--- @example -- This is akin to saying "if num_value has been set.."
--- @example if num_value then
--- @example 	print("num_value evaluates to true")
--- @example end
--- @result num_value evaluates to true
--- @new_example Using 'not' to convert to boolean
--- @example num_value = 10
--- @example 
--- @example print("not num_value: " .. not num_value)
--- @example print("not not num_value: " .. not not num_value)
--- @result not num_value: false
--- @result not not num_value: true
--- @new_example and/or operator examples
--- @example t = true
--- @example f = false
--- @example 
--- @example if t and f then
--- @example 	print("this should never get printed")
--- @example end
--- @example 
--- @example if t and not f then			-- "not f" evaluates to true
--- @example 	print("this should get printed")
--- @example end
--- @example 
--- @example if t or f then
--- @example 	print("either t or f is true")
--- @example end
--- @result this should get printed
--- @result either t or f is true
--- @new_example Compound logical test of greater length, with parenthesis
--- @example t = true
--- @example f = false
--- @example 
--- @example if not (t and (not f or not t)) then
--- @example 	print("???")
--- @example else
--- @example 	print("wha?")
--- @example end
--- @result wha?
--- @new_example Using 'or' to set a default value during an assignment operation
--- @example function returns_nothing()
--- @example 	-- do nothing
--- @example end
--- @example 
--- @example -- returns_nothing() evaluates to nil/false,
--- @example -- so 'or' will return the second value here
--- @example value = returns_nothing() or 1
--- @example print("value is " .. tostring(value))
--- @result value is 1
--- @new_example Using 'and' to test existence or type before value of variable, to prevent errors 
--- @desc This example shows how the 'and' operator can be used in a serial to guard operations on values that might otherwise fail and cause script errors. Performing a numeric comparison such as > on a non-numeric value is illegal and would cause a script failure. This is prevented by the first expression which tests whether <code>value</code> is a number. If <code>value</code> is not a number, and the @lua:type check returns <code>false</code>, lua will not proceed on to evaluate the second expression (containing the numeric comparison) as the interpreter is smart enough to realise that it can't affect the final result.
--- @example function test_value(value)
--- @example 	if type(value) == "number" and value > 10 then
--- @example 		print("value " .. tostring(value) .. " is a number > 10")
--- @example 	else
--- @example 		print("value " .. tostring(value) .. " is not a number or a number <= 10")
--- @example 	end
--- @example end
--- @example 
--- @example test_value(20)
--- @example test_value("hello")
--- @example test_value(false)
--- @result value 20 is a number > 10
--- @result value hello is not a number or a number <= 10
--- @result value false is not a number or a number <= 10






--- @section Standard Functions
--- @desc Lua provides a number of standard functions for various puposes, some of which are documented below.


--- @function print
--- @desc Prints one or more supplied values to the standard output. In Total War games, the standard output is the game console, and optionally also a text file. Non-string values passed to the function are cast to string before printing.
--- @p ... values to print
--- @example print("hello")		-- string
--- @example print(5, 3)		-- two numbers
--- @example print({})			-- a table
--- @result hello
--- @result 5	3
--- @result table: 0xb805do


--- @function type
--- @desc Returns the type of a specified value as a string.
--- @p variable variable
--- @r @string type
--- @example print(type(not_defined))
--- @example print(type("hello"))
--- @example print(type(5))
--- @example print(type({}))
--- @result nil
--- @result string
--- @result number
--- @result table


--- @function tostring
--- @desc Returns the specified value cast to a string. The specified value is unaffected.
--- @p variable variable
--- @r @string variable cast to string
--- @example value = 6
--- @example value_as_string = tostring(value)
--- @example print(value, type(value))
--- @example print(value_as_string, type(value_as_string))
--- @result 6	number
--- @result 6	string


--- @function tonumber
--- @desc Returns the specified string value cast to a number. This only works for string values that contain numeric characters (e.g. "65"). If the supplied value is a string that does not contain numeric characters, or is any other value other than a number then @nil is returned.
--- @p variable variable
--- @r @number variable cast to number
--- @example numeric_str_value = "26"
--- @example non_numeric_str_value = "hello"
--- @example number_value = 18
--- @example boolean_value = true
--- @example table_value = {}
--- @example print(tonumber(numeric_str_value), tonumber(non_numeric_str_value), tonumber(number_value), tonumber(boolean_value), tonumber(table_value))
--- @result 26	nil	18	nil	nil


--- @function loadstring
--- @desc Returns an executable function created from a string. This string may be constructed manually, or generated by another function such as @string:dump. When the returned function is executed the lua script contained within the specified string is run.
--- @desc Use this function sparingly. See external documentation for more information.
--- @p @string lua string
--- @r @function lua function
--- @example function test_func()
--- @example 	print("hello");
--- @example end;
--- @example 
--- @example local str_a = string.dump(test_func);
--- @example local str_b = "print(\"123\")";
--- @example 
--- @example func_a = loadstring(str_a);
--- @example func_b = loadstring(str_b);
--- @example 
--- @example func_a()
--- @example func_b()
--- @result hello
--- @result 123















--- @c nil Nil
--- @page lua
--- @desc The data type <code>nil</code> represents the absence of a value in lua. <code>nil</code> is both the name of the type and also the only value that a variable of that type can take. All variables contain the value <code>nil</code>, and are of type <code>nil</code>, before they are declared. Assigning <code>nil</code> to a variable is the same as deleting it.
--- @desc <code>nil</code> values resolve to <code>false</code> when considered in a logical expression.
--- @example print("no_value has a value of " .. tostring(no_value) .. " and is of type " .. type(no_value))
--- @example  
--- @example some_value = 6
--- @example some_value = nil 	-- deleting
--- @example if not some_value then
--- @example 	print("some_value is false or nil")
--- @example end
--- @result no_value has a value of nil and is of type nil
--- @result some_value is false or nil














--- @c boolean Booleans
--- @page lua
--- @desc Boolean values may be either <code>true</code> or <code>false</code>. Boolean values are of most use when evaluated by language structures such as <code>if</code> statements and <code>while</code> loops that perform logical tests and take action based on the result. The logical operators <code>and</code>, <code>or</code> and <code>not</code> can be used to evaluate booleans.
--- @desc See the section on @"lua:Conditional Operators" for more information.
--- @example t = true
--- @example 
--- @example -- must use tostring as the .. concatenation operator wont work with booleans
--- @example print("t is " .. tostring(t) .. " and of type " .. type(t))
--- @example 
--- @example f = 6 > 7		-- logical expression evaluates to false
--- @example 
--- @example print("f is " .. tostring(f))
--- @example print("not f is " .. tostring(not f))
--- @example print("f and t is " .. tostring(f or t))
--- @example if f or t then
--- @example 	print("f or t must be true!")
--- @example end
--- @result t is true and of type boolean
--- @result f is false
--- @result not f is true
--- @result f and t is true
--- @result f or t must be true!














--- @c number Numbers
--- @page lua
--- @desc Numeric values in lua are real, so they may contain decimal places. There is no integer numeric type. The default lua language specification sets numbers to be stored as double-precision floats. At time of writing, however, numbers in Total War's implementation of lua are stored as single-precision floats, which offer only about 7 digits of precision. Scripters should be aware of this limitation when planning scripts that may potentially have to deal with very large or precise numbers.
--- @desc Number values can be added, subtracted, multiplied and divided with the +, -, * and / operators respectively. Exponents may be expressed with the ^ operator.
--- @example a = 5
--- @example b = a + 10
--- @example c = b * 2
--- @example d = c / 10
--- @example e = a ^ d
--- @example print(a, b, c, d, e)
--- @result 5	15	30	3.0	125.0













--- @c string Strings
--- @function_separator .
--- @page lua
--- @desc Strings are variables containing representations of text. A string may be specified by enclosing a value in matching single or double quotes. A string can be zero, one or more characters long, with no upper limit beyond the amount of memory available.
--- @desc Strings may be joined together using the concatenation operator, <code>..</code>.
--- @example str_a = "hello"
--- @example str_b = "world"
--- @example print(str_a .. " " .. str_b)
--- @result hello world


--- @section String Patterns
--- @desc Some of the string functions described in the next section make use of string patterns, a method of matching sequences of characters akin to regular expressions. More information about lua string patterns may be found on <code>lua-users.org</code> <a href="http://lua-users.org/wiki/PatternsTutorial">here</a>.


--- @section String Library
--- @desc Lua provides a number of operations that can be performed on strings, listed below. More detailed information about these functions may be found on the dedicated page on <code>lua-users.org</code> <a href="http://lua-users.org/wiki/StringLibraryTutorial">here</a>.
--- @desc The functions may be called in the form <code>string.&lt;function&gt;(&lt;string&gt;, &lt;arguments&gt;)</code>, or <code>&lt;string&gt;:&lt;function&gt;(&lt;arguments&gt;)</code> where appropriate.


--- @function byte
--- @desc Returns the numerical code corresponding to the characters of a specified portion of the string. The portion of the string is specified by index positions of the start and end characters.
--- @p [opt=1] @number first char, Position of first character in the substring. If this is not a valid character index for this string then @nil is returned.
--- @p [opt=1] @number last char, Position of last character in the substring. If the first character position is specified and this is not, then this is set to the value of the first character position (so that only one character is returned).
--- @r ... @number character value(s)
--- @example print(string.byte("hello"))		-- prints first character by default
--- @example print(string.byte("hello", 4))		-- print single character
--- @example print(string.byte("hello", 1, 3))	-- prints range of characters
--- @result 104
--- @result 108
--- @result 104	101	108


--- @function char
--- @desc Returns a string constructed from the specified numeric character values. Number character values can be obtained with @string:byte.
--- @p ... character values, Vararg of @number character values.
--- @example print(string.char(104, 101, 108, 108, 111))
--- @result hello


--- @function dump
--- @desc Returns a string representation of a supplied function, which can later be passed to the @lua:loadstring function to be reconstituted as an executable function.
--- @p @function function
--- @r @string string representation


--- @function ends_with
--- @desc Returns <code>true</code> if the subject string ends with the supplied substring, or <code>false</code> othewise.
--- @p @string subject string
--- @p @string substring
function string.ends_with(subject_str, substr)
	return string.sub(subject_str, -string.len(substr)) == substr;
end;


--- @function find
--- @desc Returns the position of the first occurrence of a supplied substring in the subject string. If the supplied substring is found within the subject string then the start and end character positions of the substring are returned. @nil is returned if the substring is not found.
--- @desc This implementation of <code>len</code> is provided by our game code to support utf8 strings. It does not support pattern matching - see @string:find_lua for the original language implementation which does.
--- @p @string string, Subject string.
--- @p @string substring, String pattern to search for.
--- @p [opt=1] @number start index, Position of character at which to start the search. Supply a negative number to specify a character from the end of the string, counting back.
--- @r @number first character index
--- @r @number last character index
--- @example local str = "This is a test string"
--- @example print(string.find(str, "test"))
--- @result 11	14


--- @function find_lua
--- @desc Returns the position of the first occurrence of a supplied substring in the subject string. If the supplied substring is found within the subject string then the start and end character positions of the substring are returned. @nil is returned if the substring is not found.
--- @desc This is the original lua language implementation of <code>len</code>, which does not support utf8 strings but which does support pattern matching. See the lua wiki for more information about lua patterns.
--- @p @string string, Subject string.
--- @p @string substring, String pattern to search for.
--- @p [opt=1] @number start index, Position of character at which to start the search. Supply a negative number to specify a character from the end of the string, counting back.
--- @p [opt=false] @boolean disable pattern matching, Disables pattern matching if set to <code>true</code>.
--- @r @number first character index
--- @r @number last character index
--- @example local str = "this is a test string"
--- @example print(string.find_lua(str, "%s"));		-- find first space
--- @result	5	5


--- @function format
--- @desc Returns a formatted string from the formatting string and then arguments provided, in a similar style to the C function <code>printf</code>. The formatting string may contain the following special characters:
--- @desc <table class="simple"><tr><th>Character</th><th>Data Type</th><th>Description</th></tr>
--- @desc <tr><td><code>%c</code></td><td>@number (character code)</td><td>The supplied numerical character code (see @string:byte) will be converted into its string representation.</td></tr>
--- @desc <tr><td><code>%d</code></td><td>@number (integer)</td><td>The supplied integer, to be preceded by up to up to seven leading zeroes, the number of which may optionally be specified alongside the special character e.g. <code>%04d</code>. If no number is specified then the integer is included in the returned string as it was given.</td></tr>
--- @desc <tr><td><code>%e</code></td><td>@number</td><td>The supplied number will be formatted as an exponent, with the output in lower-case.</td></tr>
--- @desc <tr><td><code>%E</code></td><td>@number</td><td>The supplied number will be formatted as an exponent, with the output in upper-case.</td></tr>
--- @desc <tr><td><code>%f</code></td><td>@number</td><td>The specified number will be formated as a floating-point value. A specific format for the number may optionally be specified alongside the special character e.g. %4.1f would specify that the floating point number should be formatted with four digits preceding the decimal point and one digit following it.</td></tr>
--- @desc <tr><td><code>%g</code></td><td>@number</td><td>The specified number will be formated as a compact floating-point value, or as an exponent (if too many digits) in lower-case.</td></tr>
--- @desc <tr><td><code>%G</code></td><td>@number</td><td>The specified number will be formated as a compact floating-point value, or as an exponent (if too many digits) in upper-case.</td></tr>
--- @desc <tr><td><code>%i</code></td><td>@number (integer)</td><td>The supplied integer value will be formatted as a signed integer.</td></tr>
--- @desc <tr><td><code>%o</code></td><td>@number (integer)</td><td>The supplied integer value will be formatted as an octal value.</td></tr>
--- @desc <tr><td><code>%q</code></td><td>@string</td><td>The supplied string will be enclosed in strings (as a quotation) when returned.</td></tr>
--- @desc <tr><td><code>%s</code></td><td>@string</td><td>A string value.</td></tr>
--- @desc <tr><td><code>%u</code></td><td>@number (integer)</td><td>The supplied value will be formatted as an unsigned integer.</td></tr>
--- @desc <tr><td><code>%x</code></td><td>@number (integer)</td><td>The supplied value will be formatted as a hexadecimal integer in lower-case.</td></tr>
--- @desc <tr><td><code>%X</code></td><td>@number (integer)</td><td>The supplied value will be formatted as a hexadecimal integer in upper-case.</td></tr></table>
--- @desc The function will throw an error if it's unable to convert the number specified into an integer value (should one be expected).
--- @p @string container string, String containing special characters to insert values into.
--- @p ... values to insert, One or more values to insert into the container string, in the order that the special characters are found.
--- @r @string result
--- @new_example Inserting character codes with %c
--- @example local str = string.format("hello %c %c %c, pleased to meet you", 65, 66, 67)
--- @example print(str)
--- @result hello A B C, pleased to meet you
--- @new_example Specifying the string length of an integer with %d
--- @example local str = string.format("These integers will be displayed with at least 5 digits: %05d %05d %05d", 12, 1234, 123456)
--- @example print(str)
--- @result These integers will be displayed with at least 5 digits: 00012 01234 123456
--- @new_example Lower/Upper-case exponents with %e and %E
--- @example local str = string.format("Exponents: %e %E", 1234.56, 1234.56)
--- @example print(str)
--- @result Exponents: 1.234560e+03 1.234560E+03
--- @new_example Floating point values with %f
--- @example local str = string.format("Floating point values: %f %3.1f", 123456.78, 123456.78)
--- @example print(str)
--- @result Floating point values: 123456.780000 123456.8
--- @new_example Compact floating point values with %g and %G
--- @example local str = string.format("Compact floating point values: %g %g %G", 123456, 12345678, 12345678)
--- @example print(str)
--- @result Compact floating point values: 123456 1.23457e+07 1.23457E+07
--- @new_example Signed, Unsigned, Octal and Hexadecimal integers
--- @example local str = string.format("Signed: %i, Unsigned: %u, Octal: %o, Hex: %x", -100, -100, -100, -100)
--- @example print(str)
--- @result Signed: -100, Unsigned: 4294967196, Octal: 37777777634, Hex: ffffff9c
--- @new_example Strings
--- @example local str = string.format("Unquoted: %s, quoted: %q", "test", "test")
--- @example print(str)
--- @result Unquoted: test, quoted: "test"


--- @function gmatch
--- @desc Returns a pattern-finding iterator. More information about iterators and lua string patterns may be found externally - see @"string:String Patterns".
--- @p @string subject string
--- @p @string pattern
--- @r iterator
--- @example local str = "This is a test string"
--- @example local wordcount = 0
--- @example for word in string.gmatch(str, "%a+") do
--- @example   wordcount = wordcount + 1
--- @example end
--- @example print(string.format("%q contains %d words", str, wordcount))
--- @result "This is a test string" contains 5 words


--- @function gsub
--- @desc This function takes a subject string, a pattern string and a replacement string, and performs a search based on the pattern string within the subject string. Should any parts of the pattern match, those parts of the subject string are replaced with the replacement string. The resulting string is then returned. An optional count argument may also be specified to limit the number of pattern replacements that may be performed.
--- @p @string subject, Subject string.
--- @p @string pattern, Pattern string. More information about lua patterns may be found here: @"string:String Patterns"
--- @p @string replacement, Replacement string.
--- @p [opt=nil] @number count, Maximum number of times the replacement can be performed. If left unset, then no maximum is applied.
--- @r @string result
--- @example -- replace all spaces with underscores
--- @example result = string.gsub("this is a test string", " ", "_")
--- @example print(result)
--- @result this_is_a_test_string


--- @function len
--- @desc Returns the number of characters in the supplied string. This implementation of <code>len</code> is provided by our game code, see @string:len_lua for the original language implementation.
--- @p @string input
--- @r @number length
--- @example str = "hello"
--- @example print(str:len())
--- @result 5


--- @function len_lua
--- @desc Returns the number of characters in the supplied string. This is the original lua language implementation of <code>len</code>, which does not support utf8 strings.
--- @p @string input
--- @r @number length
--- @example str = "hello"
--- @example print(str:len_lua())
--- @result 5


--- @function lower
--- @desc Returns the supplied string, converted to lowercase.
--- @p @string input
--- @r @string converted string
--- @example str = "A Test String"
--- @example print(string.lower(str))
--- @result a test string


--- @function match
--- @desc Returns a substring of the supplied string, by a supplied pattern. An optional index may also be used to specify a character at which the search should be started.
--- @desc More information about patterns may be found here: @"string:String Patterns".
--- @p @string subject, Subject string to search.
--- @p @string pattern, Search pattern.
--- @p [opt=1] @number start character, Start character within the subject string.
--- @r @string matching string
--- @example str = "THIS WORD here IS LOWERCASE"
--- @example print(string.match(str, "%l+"))
--- @result here


--- @function rep
--- @desc Generates and returns a string which is a supplied number of copies of the supplied string, all concatenated together.
--- @p @string source
--- @p @number count
--- @r @string result
--- @example print(string.rep("test", 3))
--- @result testtesttest


--- @function reverse
--- @desc Returns the supplied string with the character order reversed.
--- @p @string input
--- @r @string reversed string
--- @example print(string.reverse("forward"))
--- @result drawrof


--- @function starts_with
--- @desc Returns <code>true</code> if the subject string starts with the supplied substring, or <code>false</code> othewise.
--- @p @string subject string
--- @p @string substring
function string.starts_with(subject_str, substr)
	return string.sub(subject_str, 1, string.len(substr)) == substr;
end;


--- @function sub
--- @desc Returns a section of the supplied string, specified by start and (optionally) end character positions. The substring will include the characters specified by the start and end positions.
--- @desc This implementation of <code>sub</code> is provided by our game code, see @string:sub_lua for the original language implementation.
--- @p @string input, Subject string.
--- @p @number start index, Position of the starting character of the substring. If a negative number is specified then the function counts back from the end of the string.
--- @p [opt=nil] @number end index, Position of the end character of the desired substring. If omitted, then the end of the supplied string is used as the end of the substring. If a negative number is specified then the function counts back from the end of the string to find this character.
--- @new_example From character 11 until the end
--- @example str = "this is a test string"
--- @example print(string.sub(str, 11))
--- @result test string
--- @new_example From characters 11 through to 14 
--- @example str = "this is a test string"
--- @example print(string.sub(str, 11, 14))
--- @result test
--- @new_example From 13 characters from the end, onwards
--- @example str = "this is a test string"
--- @example print(string.sub(str, -13))
--- @result a test string
--- @new_example From 13 characters from the end until 9 from the start
--- @example str = "this is a test string"
--- @example print(string.sub(str, -13, 9))
--- @result a
--- @new_example From 13 characters from the end until 8 from the end
--- @example str = "this is a test string"
--- @example print(string.sub(str, -13, -8))
--- @result a test


--- @function sub_lua
--- @desc Returns a section of the supplied string, specified by start and (optionally) end character positions. The substring will include the characters specified by the start and end positions.
--- @desc This is the original lua language implementation of <code>sub</code>, which does not support utf8 strings.
--- @p @string input, Subject string.
--- @p @number start index, Position of the starting character of the substring. If a negative number is specified then the function counts back from the end of the string.
--- @p [opt=nil] @number end index, Position of the end character of the desired substring. If omitted, then the end of the supplied string is used as the end of the substring. If a negative number is specified then the function counts back from the end of the string to find this character.
--- @new_example From character 11 until the end
--- @example str = "this is a test string"
--- @example print(string.sub_lua(str, 11))
--- @result test string
--- @new_example From characters 11 through to 14 
--- @example str = "this is a test string"
--- @example print(string.sub_lua(str, 11, 14))
--- @result test
--- @new_example From 13 characters from the end, onwards
--- @example str = "this is a test string"
--- @example print(string.sub_lua(str, -13))
--- @result a test string
--- @new_example From 13 characters from the end until 9 from the start
--- @example str = "this is a test string"
--- @example print(string.sub_lua(str, -13, 9))
--- @result a
--- @new_example From 13 characters from the end until 8 from the end
--- @example str = "this is a test string"
--- @example print(string.sub_lua(str, -13, -8))
--- @result a test


--- @function split
--- @desc Returns a list representing the specified subject_str split up by occurances of split_str, not including those occurances.
--- @desc An empty table is returned if no occurances of split_str are found.
--- @p @string subject_str, The string to be split.
--- @p @string split_str, The character or string to split the subject string at.
--- @new_example Splitting a string by spaces
--- @example string.split("The quick brown fox", ' ')
--- @result { "The", "quick", "brown", "fox" }
--- @new_example Splitting a string with another string (note that the pattern matches at its earliest possible location)
--- @example string.split("Bananas: Price ----- £1.50", '---')
--- @result { "Bananas: Price ", "-- £150" }
--- @new_example Trimming the start and end occurances of spaces
--- @example string.split("NoSpacesHere", ' ')
--- @result { "NoSpacesHere" }
function string.split(subject_str, split_str)
	local splits = {};
	local split_index;

	repeat
		split_index = string.find(subject_str, split_str);

		if split_index ~= nil then
			table.insert(splits, string.sub(subject_str, 1, split_index - 1));
			subject_str = string.sub(subject_str, split_index + #split_str, -1);
		elseif #subject_str > 0 then
			table.insert(splits, subject_str);
		end;
	until split_index == nil;

	return splits;
end;


--- @function upper
--- @desc Returns the supplied string, converted to uppercase.
--- @p @string input
--- @r @string converted string
--- @example str = "A Test String"
--- @example print(string.upper(str))
--- @result A TEST STRING















--- @c function Functions
--- @page lua
--- @desc Functions are chunks of script that, when executed, perform one or more operations and then return control to the script that called them. Function declarations begin with the <code>function</code> keyword, and end with a corresponding <code>end</code> keyword. They are useful for encapsulating tasks that need to be performed repeatedly.
--- @desc Functions can optionally take one or more argument values from the calling script. This allows a single function to produce different results when run repeatedly, based on its input values. Functions may also optionally return one or more values to the script that called them.
--- @desc Functions in lua are <code>first-class values</code>, which means that they may be assigned and re-assigned to variables in exactly the same manner as @number values, @string values and so on. As with other variables types in lua it's possible for functions to be anonymous, where they are created without a name.
--- @desc Once declared, a function can be called and executed in script by appending open and close parenthesis characters to its name in the form <code>&lt;function_name&gt;(arg1, arg2)</code>. See the examples below.

--- @new_example Simple function declaration and execution
--- @example -- declare a function variable called test_function that takes no arguments
--- @example function test_function()
--- @example 	print("test_function() called");
--- @example end
--- @example 
--- @example -- call test_function, after it has been declared
--- @example test_function()
--- @result test_function() called

--- @new_example Alternative form of function declaration
--- @desc This alternative form of function declaration is identical to the previous example. It better illustrates the nature of functions as just another type of variable, created by assignment like a string or number.
--- @example -- declare a function variable called test_function that takes no arguments
--- @example test_function = function()
--- @example 	print("test_function() called");
--- @example end
--- @example 
--- @example -- call test_function, after it has been declared
--- @example test_function()
--- @result test_function() called

--- @new_example Function taking two arguments
--- @desc Arguments can be specified in the function specification as follows. The arguments will be accessible as local variables throughout the lifetime of the function.
--- @example -- declare a function that takes two arguments called 'first' and 'second'
--- @example f = function(first, second)
--- @example 	print("f() called");
--- @example 	print("\tfirst is " .. tostring(first));
--- @example 	print("\tsecond is " .. tostring(second));
--- @example end
--- @example 
--- @example -- call f
--- @example f("hello", "goodbye")
--- @example f("lonely")			-- deliberately not supplying a second arg
--- @example f(nil, "lonely")		-- deliberately not supplying a first arg
--- @result f() called
--- @result 	first is hello
--- @result 	second is goodbye
--- @result f() called
--- @result 	first is lonely
--- @result 	second is nil		-- value of unsupplied arguments is nil
--- @result f() called
--- @result 	first is nil
--- @result 	second is lonely

--- @new_example Function returning two values
--- @example function get_1080p_screen_resolution()
--- @example 	return 1920, 1080;
--- @example end
--- @example 
--- @example local x, y = get_1080p_screen_resolution()
--- @example print("1080p screen resolution is [" .. x .. ", " .. y .. "]") 
--- @result 1080p screen resolution is [1920, 1080]

--- @new_example Example of passing functions as arguments to another function
--- @desc This includes an example of an anonymous function.
--- @example -- this function takes an argument and prints whether it's a function or not
--- @example function is_function(name, obj)
--- @example 	if type(obj) == "function" then
--- @example 		print(name .. " is a function");
--- @example 	else
--- @example 		print(name .. " is not a function");
--- @example 	end
--- @example end
--- @example
--- @example a_number = 5
--- @example a_function = function() print("hello!") end
--- @example 
--- @example -- make calls to is_function. First arg is string name, second arg is value to test
--- @example is_function("a_number", a_number)
--- @example is_function("a_function", a_function)
--- @example 
--- @example -- pass through an anonymous function
--- @example is_function("anonymous_function", function() print("this is an anonymous function!") end)
--- @example 
--- @example -- pass is_function itself into is_function...
--- @example is_function("is_function", is_function)
--- @result a_number is not a function
--- @result a_function is a function
--- @result anonymous_function is a function
--- @result is_function is a function


--- @section Varargs
--- @desc A function can also take a variable number of arguments in a <code>vararg</code> structure. Using varargs, an unlimited number of arguments can be supplied to a function, which accesses them as elements in a @table created within the function block called <code>arg</code>. The number of arguments can be accessed at the special element <code>n</code> within the <code>arg</code> table. See the examples below.
--- @example -- the ... argument in the function declaration specifies that the function takes a vararg
--- @example function print_all(...)
--- @example 	for i = 1, arg.n do
--- @example 		print("arg " .. i .. " is " .. tostring(arg[i]))
--- @example 	end
--- @example end
--- @example 
--- @example -- call print_all() with as many arguments as we like
--- @example print_all("hello", "goodbye", 1, 2, 3)
--- @result arg 1 is hello
--- @result arg 2 is goodbye
--- @result arg 3 is 1
--- @result arg 4 is 2
--- @result arg 5 is 3













--- @c table Tables
--- @page lua
--- @desc Tables are the sole container type in lua, and as such are the mechanism available for building complex data structures. They are associative arrays, which means they store sets of key/value pairs. A <code>value</code> in a table is stored in a record corresponding to a <code>key</code>, and that value may later accessed or modified using that same key. Keys are most commonly @number or @string values, but may be of any type other than @nil. Values stored against keys can be of any type, including @function or @table (allowing tables to be nested), although a value of @nil is the same as the value/record not existing.
--- @desc Elements in a table may be accessed using <code>[]</code> square brackets, or by using the <code>.</code> accessor if the key is a string, as shown in the examples below:
--- @example -- assign a string value to table t at a numeric key
--- @example t[5] = "hello"
--- @example 
--- @example -- assign a number value at a string key
--- @example t["age"] = 25
--- @example
--- @example -- assign a value to a key, but where we evaluate the key from another variable
--- @example key_name = "hair_colour"
--- @example t[key_name] = "brown"
--- @example 
--- @example -- alternative method for assigning to a string key within a table
--- @example t.name = "Peter"
--- @example 
--- @example -- access elements in the table (using a variety of methods)
--- @example print(t[name] .. " is " .. t[age] .. " years old, his hair colour is " .. t.hair_colour)
--- @result Peter is 25 years old, his hair colour is brown


--- @section Creation
--- @desc Before a table can be used it must be created with a table constructor, which is a pair of <code>{}</code> braces. Values, or key/value pairs, can be included within the constructor so that they are stored in the table from creation. See the examples below:
--- @new_example Create an empty table
--- @example t = {}
--- @new_example Create a table containing a list of values
--- @desc Each new value is inserted into the table at the first available integer key, starting at 1.
--- @example -- The value "first" is stored with a key of 1 
--- @example -- The value "second" is stored with a key of 2 
--- @example -- .. and so on 
--- @example t = { "first", "second", "third", "fourth" }
--- @new_example Create a table with key/values
--- @example t = { [10] = "ten", [20] = "twenty", [30] = "thirty" }
--- @new_example Create a table with key/values, but where the key is evaluated
--- @example key_name = "title"
--- @example t = { [key_name] = "doctor" }
--- @example print(t.title)
--- @result doctor


--- @section Standard Traversal
--- @desc Tables can be traversed by numeric sequence if their keys are arranged accordingly. The size of a table where values are assigned at ascending numeric integer keys can be accessed with the <code>#</code> operator. This reports the first integer key <code>n</code> for which no value is stored at key <code>n + 1</code>.

--- @new_example Examples of #t
--- @example t1 = { "yes", "no", "maybe", "sometimes", "rarely" } 								-- values are stored at ascending keys
--- @example t2 = { [1] = "hello", [2] = "bonjour", [3] = "gutentag", [5] = "salut" } 			-- missing value stored at key 4
--- @example print("size of t1: " .. #t1)
--- @example print("size of t2: " .. #t2)
--- @result size of t1: 5
--- @result size of t2: 3

--- @new_example Traversal by numeric sequence
--- @example t = { "my", "enormous", "green", "boots", "dont", "fit" }
--- @example for i = 1, #t do
--- @example 	print("\tkey: " .. i .. ", value: " .. t[i])
--- @example end
--- @result key: 1, value: my
--- @result key: 2, value: enormous
--- @result key: 3, value: green
--- @result key: 4, value: boots
--- @result key: 5, value: dont
--- @result key: 6, value: fit


--- @section Traversal Using Iterators
--- @desc The iterator functions <code>ipairs</code> and <code>pairs</code> are available for iterating over tables where standard traversal may not be possible or desirable.
--- @desc The <code>ipairs</code> iterator behaves much the same as traversing over a table in numeric sequence. The main difference is that local variables for the key and optionally the value are automatically created. The <code>ipairs</code> iterator stops at the first integer key to which a value is not assigned.
--- @desc Unlike <code>ipairs</code> and numeric traversal, the <code>pairs</code> iterator allows traversal over all elements in a table, regardless of key type or any "gaps" in the data. The main caveat to usage is that the order of traversal is not defined, and can change between iteration instances. As such, the <code>pairs</code> iterator is unsafe to use in multiplayer scripts as two different machines will traverse the same table in different orders.
--- @new_example ipairs example
--- @example t = { [1] = "first", [2] = "second", [3] = "third", [5] = "fifth" } 		-- gap at 4
--- @example for key, value in ipairs(t) do
--- @example 	-- local variables called 'key' and 'value' are automatically created each loop cycle
--- @example 	print("key: " .. key .. ", value: " .. value);
--- @example end
--- @result key: 1, value: first
--- @result key: 2, value: second
--- @result key: 3, value: third

--- @new_example pairs example
--- @desc Note how the order of the output is arbitrary.
--- @example -- table with keys of lots of different types - impossible to traverse with #t or ipairs
--- @example t = {
--- @example 	[1] = "first",
--- @example	["greeting"] = "hello", 
--- @example	[5] = "fifth", 
--- @example	[10] = "tenth", 
--- @example	[true] = "this has a boolean key", 
--- @example 	[function() print("hello") end] = "This has a function key! Weird but possible"
--- @example }
--- @example for key, value in pairs(t) do
--- @example 	print("key: " .. tostring(key) .. ", value: " .. tostring(value));
--- @example end
--- @result key: 1, value: first
--- @result key: greeting, value: hello
--- @result key: function: 0x2194d10, value: This has a function key! Weird but possible
--- @result key: 5, value: fifth
--- @result key: true, value: this has a boolean key
--- @result key: 10, value: tenth


--- @section Table Library
--- @desc Lua provides a library of operations that can be performed on tables, listed below. More detailed information about these functions may be found on the dedicated page on <code>lua-users.org</code> <a href="http://lua-users.org/wiki/TablesTutorial">here</a>.
--- @desc The functions may be called in the form <code>table.&lt;function&gt;(&lt;t&gt;, &lt;arguments&gt;)</code>.


--- @function concat
--- @desc Concatenates the values in the supplied table into a @string, with optional separator characters, and returns that string. This can be a memory-efficient way of concatenating large amounts of strings together.
--- @p @table table, Table to concatenate.
--- @p [opt=""] @string separator, Separator string to insert between elements from the table.
--- @p [opt=1] @number start element, Table element at which to start concatenating.
--- @p [opt=&lt;table_size&gt;] @number end element, Table element at which to finish concatenating.
--- @example t = {"first", "second", "third", "fourth", "fifth"}
--- @example print(table.concat(t))
--- @example print(table.concat(t, " ", 2, 4))
--- @result firstsecondthirdfourthfifth
--- @result second third fourth


--- @function insert
--- @desc Inserts a value into the supplied table. The index at which to insert the value may optionally be specified - note that this can change the sequence of arguments.
--- @desc If no position argument is specified then the first available integer key in ascending order is chosen, starting from <code>1</code>.
--- @p @table table, Table to insert element in to.
--- @p [opt=&lt;table_size&gt;] @number position, Position at which to insert value. Note that this may be omitted, in which case the value to insert should be specified as the second argument. In this case the first available integer key is chosen, ascending from <code>1</code>.
--- @p obj value, Value to insert. If a third argument is omitted, the second is taken as the value to insert.
--- @example t = {1, 2, 3}
--- @example table.insert(t, "hello")			-- insert "hello" as the last element in the table
--- @example table.insert(t, 3, "goodbye")		-- insert "goodbye" as the third element in the table
--- @example print(table.concat(t, " "))
--- @result 1 2 goodbye 3 hello


--- @function maxn
--- @desc Returns the largest positive numeric index within the supplied table at which a value is assigned. Unlike the <code>#</code> operator, this will not stop counting if a gap in the integer sequence is found.
--- @p @table table
--- @r @number highest index
--- @example t = {}
--- @example t[1] = "goodbye"
--- @example t[2] = "adios"
--- @example t[4] = "auf"
--- @example -- no t[5]
--- @example t[6] = "la revedere"
--- @example t["8"] = "au revoir"		-- not counted as the key is a string
--- @example print("table.maxn(t) is " .. table.maxn(t))
--- @example print("#t is " .. #t)
--- @result table.maxn(t) is 6
--- @result #t is 4


--- @function remove
--- @desc Removes the element from the supplied table at the supplied numeric index.
--- @p @table table, Table.
--- @p [opt=&lt;table_size&gt;] @number position, Position within table of element to remove.
--- @example t = {1, 2, 3, 4, 5}
--- @example table.remove(t)		-- remove element at the end of the table
--- @example table.remove(t, 2)		-- remove second element from the table
--- @example print(table.concat(t))
--- @result 134


--- @function sort
--- @desc Sorts the elements in the supplied table into a new order. A comparison function may be supplied, which should take two table elements as arguments and return <code>true</code> if the first of these elements should appear in the final sorted order before the second, or <code>false</code> if the opposite is desired. The table is sorted into ascending numerical order by default, which is the equivalent of supplying the sort function <code>function(a, b) return a < b end</code>.
--- @p @table table, Table to sort.
--- @p [opt=&lt;ascending_sort_order&gt;] @function comparison, Comparison function.

--- @new_example Default ascending sort order
--- @example t = {4, 5, 3, 1, 8, 10}
--- @example table.sort(t)
--- @example print(table.concat(t, " "))
--- @result 1 3 4 5 8 10

--- @new_example Reverse sort order
--- @example t = {4, 5, 3, 1, 8, 10}
--- @example table.sort(t, function(a, b) return a > b end)
--- @example print(table.concat(t, " "))
--- @result 10 8 5 4 3 1

--- @new_example Sorting a table of strings into length order
--- @example t = {"very_long", "short", "longer", "really_really_long"}
--- @example table.sort(t, function(a, b) return string.len(a) < string.len(b) end)
--- @example print(table.concat(t, "..."))
--- @result short...longer...very_long...really_really_long


--- @function tostring
--- @desc Converts a table into a @string representation of that table for debug output. Note that this function is not provided with lua but is provided by Total War's script libraries.
--- @p @table table, Subject table.
--- @p @boolean for campaign savegame, Set to <code>true</code if the string is intended for saving into a campaign savegame. This discards values that are not boolean, number, strings or tables.
--- @p [opt=3] @number max depth, Maximum depth. This is the maximum depth of tables-within-tables to which the function will descend. Supply <code>-1</code> to set no maximum depth, which makes an infinite loop a possibility.
--- @p [opt=0] @number tab level, Starting tab level. This number of tabs will be prepended to the start of each new line in the output.
-- fifth/sixth args are hidden
--- @r @string table to string
function table.tostring(t, for_campaign_savegame, max_level, tab_level, prepend_tabs, add_line_break)
	if not is_table(t) then
		script_error("ERROR: table.tostring() called but supplied table [" .. tostring(t) .. "] is not a valid table");
		return false;
	end;

	local str_table = {};
	max_level = max_level or 3;

	if is_function(prepend_tabs) then
		-- check current level against max level if max_level is not set to -1
		if max_level ~= -1 and not for_campaign_savegame and tab_level >= max_level then
			return "{max_level_exceeded}";
		end;

	else
		tab_level = tab_level or 0;
		max_level = max_level + tab_level;		-- add tab_level to max_level initially, so if a value > 0 is passed in as tab level this is accounted for by max_level

		-- if for_campaign_savegame is set then these formatting functions should do nothing
		if for_campaign_savegame then
			prepend_tabs = function() end;
			add_line_break = prepend_tabs;
		else
			-- these are parameters so are already local
			prepend_tabs = function(str_table, tab_level)
				table.insert(str_table, string.rep("\t", tab_level));
			end;

			add_line_break = function(str_table)
				table.insert(str_table, "\n");
			end;
		end;
	end;

	table.insert(str_table, "{");

	tab_level = tab_level + 1;

	local is_first_value = true;

	for key, value in pairs(t) do
		if not for_campaign_savegame or is_table(value) or is_string(value) or is_number(value) or is_boolean(value) then
			
			-- If this is for a campaign savegame and this field is a string, then replace all " chars with &quot; all ' chars with &apos; and all \n chars with &nl; as these characters can break the loadstring behaviour - they will be explicitly swapped back when loaded
			if for_campaign_savegame and is_string(value) then
				value = string_special_chars_pre_save_fixup(value);
			end;
			
			if is_first_value then
				is_first_value = false;
				add_line_break(str_table);
			else
				table.insert(str_table, ",");
				add_line_break(str_table);
			end;
			
			prepend_tabs(str_table, tab_level);
			
			if is_string(key) then
				table.insert(str_table, "[\"");
				table.insert(str_table, key);
				table.insert(str_table, "\"]");
			else
				table.insert(str_table, "[");
				table.insert(str_table, tostring(key));
				table.insert(str_table, "]");
			end
			
			if for_campaign_savegame then
				table.insert(str_table, "=");
			else
				table.insert(str_table, " = ");
			end;
			
			if is_table(value) then
				table.insert(str_table, table.tostring(value, for_campaign_savegame, max_level, tab_level, prepend_tabs, add_line_break));
			elseif is_string(value) then
				table.insert(str_table, "\"");
				table.insert(str_table, value);
				table.insert(str_table, "\"");
			else
				table.insert(str_table, tostring(value));
			end;
		end;
	end;
	
	add_line_break(str_table);

	tab_level = tab_level - 1;
	prepend_tabs(str_table, tab_level);

	table.insert(str_table, "}");

	return table.concat(str_table);
end;


--- @function contains
--- @desc Reports if the supplied table contains the supplied value. If the table does contain the supplied value, the corresponding key at which it may be found is returned, otherwise <code>false</code> is returned.
--- @p @table table
--- @p value value
--- @r value key corresponding to value
function table.contains(t, obj)
	if not validate.is_table(t) then
		return false;
	end;

	for key, value in pairs(t) do
		if value == obj then
			return key;
		end;
	end;
	return false;
end;


--- @function is_empty
--- @desc Returns whether the supplied table is empty.
--- @p @table table, Subject table.
--- @r @boolean is empty
function table.is_empty(t)
	if not validate.is_table(t) then
		return false;
	end;
	
	return next(t) == nil;
end;


--- @function copy
--- @desc Returns a deep copy of the supplied table. All subtables are copied. Metatables are not copied. Cyclical references are preserved.
--- @p @table table, Subject table
--- @new_example Loading faction script
--- @desc This script snippet requires the path to the campaign faction folder, then loads the "faction_script_loader" script file, when the game is created.
--- @r @table copy
--- @example my_table = { fruit = "apple", topping = { flavour = "cinnamon" } }
--- @example copied_table = table.copy(my_table)
--- @example copied_table.fruit = "banana"
--- @example copied_table.topping.flavour = "chocolate"
--- @example print(my_table.fruit .. " topped with " .. my_table.topping.flavour)
--- @example print(copied_table.fruit .. " topped with " .. copied_table.topping.flavour)
--- @result apple topped with cinnamon
--- @result banana topped with chocolate
function table.copy(t, previously_copied_tables)

	if not validate.is_table(t) then
		return false;
	end;

	if not previously_copied_tables then
		previously_copied_tables = {};
	end;

	local copy = {};

	previously_copied_tables[t] = copy;

	for key, value in pairs(t) do
		if is_table(value) then
			if previously_copied_tables[value] then
				copy[key] = previously_copied_tables[value];
			else
				copy[key] = table.copy(value, previously_copied_tables);
			end;
		else
			copy[key] = value;
		end
	end
	
	setmetatable(copy, getmetatable(t));

	return copy;
end;


--- @function mem_address
--- @desc Returns the memory address portion of the result of calling tostring() with a table argument. The function will fail if the supplied table has a metatable that's write-protected.
--- @desc If the leave punctuation flag is set then the memory address is supplied back still with its leading colon and space characters.
--- @p @table object
--- @p [opt=false] @boolean leave punctuation
--- @r @string address string
function table.mem_address(t, leave_punctuation)
	local mem_address;

	-- If this table has a metatable with a __tostring value defined we'll need to undefine that
	-- and redefine it afterwards (this won't work if the mt is protected)
	local mt = getmetatable(t);
	local old_tostring;
	if mt and mt.__tostring then
		old_tostring = mt.__tostring;
		mt.__tostring = nil;
	end;

	-- current_tostring should be in the form "table: <addr>"
	local current_tostring = tostring(t);
	local start_index = string.find(current_tostring, ":");

	if start_index then
		if not leave_punctuation then
			-- omit the ": " at the start of the mem address
			start_index = start_index + 2;
		end;

		mem_address = string.sub(current_tostring, start_index);
	else
		mem_address = "";
	end;

	if old_tostring then
		mt.__tostring = old_tostring;
	end;

	return mem_address;
end;


--- @function indexed_to_lookup
--- @desc Returns another table containing all records in the supplied indexed table, except with the values set to keys. The values in the returned table will be <code>true</code> for all records.
--- @p @table indexed table
--- @return @table lookup table
--- @example indexed_t = {"oranges", "apples", "strawberries"}
--- @example lookup_t = table.indexed_to_lookup(indexed_t)
--- @example for key, value in pairs(lookup_t) do
--- @example   print(key, value)
--- @example end
--- @result strawberries	true
--- @result oranges			true
--- @result apples			true
function table.indexed_to_lookup(t)
	if not validate.is_table(t) then
		return false;
	end;

	local retval = {};
	for i = 1, #t do
		retval[t[i]] = true;
	end;
	return retval;
end;


-- Comparison method used to sort tables during merging in a way that supports mod-compatibility.
-- Two tables, containing a 'key' and 'value' element are compared. The key ought to be the data table's filename. The value is the table itself.
-- The value - that is, the data table - can contain an element named 'load_order'. If specified, tables are sorted in this order. If not, the table will come last.
-- If two tables have an equal load_order, or the absence of a load_order, the keys are compared alplabetically instead. For this reason. table keys must be unique.
local function merge_tables_comparison(kvp_1, kvp_2)
	if kvp_1 == kvp_2 then
		return false;
	end;

	-- All items argued to this comparison function must be a table containing { key = "string", value = { table }}
	-- The value is the table itself, which may contain a numeric load_order. The key is the unique string key of the table, which is
	-- used as a backup comparison if the load_orders are equal or unspecified.
	local t1_key = kvp_1.key;
	local t1 = kvp_1.value;
	local t2_key = kvp_2.key;
	local t2 = kvp_2.value;

	-- If a numeric sort-order has not been specified, the table should be sorted last.
	t1_has_load_order = is_number(t1.load_order);
	t2_has_load_order = is_number(t2.load_order);

	if (not t1_has_load_order and not t2_has_load_order) or (t1.load_order == t2.load_order) then
		-- If both sort orders are the same (nil or numeric) compare the table's keys as a backup.
		if t1_key == t2_key then
			script_error(string.format("ERROR: Unable to uniquely sort tables of keys '%s' and '%s': Tables being merged must all have unique keys as a backup for identical sort-orders.",
				t1_key, t2_key));
			return false;
		else
			return t1_key < t2_key;
		end;
	elseif t1_has_load_order and t2_has_load_order then
		return t1.load_order < t2.load_order;
	else
		-- We've ruled out both tables having a sort order, and we've ruled out both of them missing a sort order.
		-- So since one must have a sort order, it's either T1 (in which case sort it before T2) or it's T2 (in which case don't).
		return t1_has_load_order;
	end;
end


--- @function compile_tables
--- @desc Given a list of tables, sorts all tables by an optional <code>load_order</code> and then merges each one onto the previous successively. Can be used to merge and override data tables for mod compatibility.
--- @p @table table_list, The list of tables to be merged, indexed numerically.
--- @p [opt=default rules (fully recursive, allow overrides)] @table merge_rules, A table describing the rules for merging, including <code>recursion_levels</code> and <code>allow_overrides</code>.
--- @r @table Returns the fully compiled table (a new table reference).
function table.compile_tables(table_list, merge_rules)
	-- Provide default merge rules if none were provided.
	if merge_rules == nil then
		merge_rules = {
			recursion_levels = -1;
			allow_overrides = true;
		};
	end;

	local key_value_table_list = {}
	for key, value in pairs(table_list) do
		table.insert(key_value_table_list, { key = key, value = value });
	end;
	table.sort(key_value_table_list, merge_tables_comparison);

	local merged_table = {};
	for _, kv in pairs(key_value_table_list) do
		table.merge_tables(merged_table, kv.value, merge_rules);
	end;

	return merged_table;
end;


--- @function merge_tables
--- @desc Merge two tables given a set of merge rules, implanting the data from <code>merge_from</code> into <code>merge_to</code>.
--- @p @table merge_to, The table to which data will be merged. The return value is this table, following the merge.
--- @p @table merge_from, The table from which data will be merged.
--- @p @table merge_rules, A table describing the rules for merging, including <code>recursion_levels</code> and <code>allow_overrides</code>.
--- @p [opt=1] @number recursion_level, The number of recursions this function call is at, i.e. the number of table layers into the original table that the merge has reached. If unspecified, this begins at 1.
--- @r @table Returns the original merge_to table, but with the contents of merge_from incoorporated into it.
function table.merge_tables(merge_to, merge_from, merge_rules, recursion_level)
	-- If this is the first call to merge_tables, the level is 1.
	recursion_level = recursion_level or 1;

	local next_recursion_level = -1;
	local can_use_recursion = false;
	-- Allowing a recursion level of -1 allows infinite recursion, merging a table and all tables within that table.
	if merge_rules.recursion_levels ~= -1 then
		next_recursion_level = recursion_level + 1; 
		can_use_recursion = merge_rules.recursion_levels >= recursion_level;
	else
		can_use_recursion = true;
	end;

	for key, value in pairs(merge_from) do
		if merge_to[key] ~= nil then
			local merge_to_value = merge_to[key]
			if is_table(value) and is_table(merge_to_value) and can_use_recursion then
				table.merge_tables(merge_to_value, value, merge_rules, next_recursion_level)
			elseif merge_rules.allow_overrides then
				merge_to[key] = merge_to_value;
			end;
		else
			merge_to[key] = value;
		end;
	end;

	return merge_to;
end;










--- @c userdata Userdata
--- @page lua
--- @desc Userdata is an area of memory accessible to lua but created by the host program. In our case, the host program is the game executable. It allows the host program to package up code functionality in a black box that can be used in fixed ways script.
--- @desc The interface objects supplied to script by the game in campaign and battle are typically <code>userdata</code>. It's not possible for script to meaningfully modify or query userdata objects in ways that weren't specifically set up by the creating code.
















--- @c math Math
--- @page lua
--- @function_separator .
--- @desc The <code>math</code> library provides mathematical functions and values in a @table that be called from within lua.


--- @section Values
--- @desc The math libraries provides the following constants that can be looked up:
--- @variable pi number Value of Pi.
--- @variable huge number The value HUGE_VAL, a value equal to or larger than any other numerical value.



--- @section Functions


--- @function abs
--- @desc Returns the absolute of the supplied value, converting it to a positive value if negative.
--- @p @number value
--- @r @number absolute value
--- @example print(math.abs(-4))
--- @result 4


--- @function acos
--- @desc Returns the arc cosine of the supplied value, in radians. The supplied value should be between -1 and 1.
--- @p @number value
--- @r @number acos value in radians
--- @example print(math.acos(0.5))
--- @result 1.0471975511966


--- @function asin
--- @desc Returns the arc sine of the supplied value, in radians. The supplied value should be between -1 and 1.
--- @p @number value
--- @r @number asin value in radians
--- @example print(math.asin(0.5))
--- @result 0.5235987755983


--- @function atan
--- @desc Returns the arc tangent of the supplied value, in radians.
--- @p @number value
--- @r @number atan value in radians
--- @example print(math.atan2(1))
--- @result 0.64350110879328


--- @function atan2
--- @desc Returns the arc tangent of the supplied opposite value divided by the supplied adjacent value, in radians. The sign of both arguments is used to find the quadrant of the result.
--- @p @number opposite
--- @p @number adjacent
--- @r @number atan value in radians
--- @example print(math.atan2(5, 5))
--- @example print(math.atan2(-5, 5))
--- @result 0.78539816339745
--- @result -0.78539816339745


--- @function ceil
--- @desc Returns the smallest integer that is larger than or equal to the supplied value.
--- @p @number value
--- @r @number ceil value
--- @example print(math.ceil(2.2))
--- @result 3


--- @function cos
--- @desc Returns the cosine of the supplied radian value.
--- @p @number value
--- @r @number cosine value
--- @example print(math.cos(1.0471975511966))
--- @result 0.5


--- @function cosh
--- @desc Returns the hyperbolic cosine of the supplied value.
--- @p @number value
--- @r @number hyperbolic cosine value
--- @example print(math.cosh(1))
--- @result 1.5430806348152


--- @function deg
--- @desc Converts the supplied radian value into an angle in degrees. See also @math:rad.
--- @p @number radian value
--- @r @number value in degrees
--- @example print(math.deg(math.pi))
--- @result 180.0


--- @function exp
--- @desc Returns the numerical constant <code>e</code> to the power of the supplied value. Supply a value of <code>1</code> to just return <code>e</code>.
--- @p @number exponent
--- @r @number e ^ exponent
--- @example print(math.exp(1))
--- @result 2.718281828459


--- @function floor
--- @desc Returns the largest integer that is smaller than or equal to the supplied value.
--- @p @number value
--- @r @number floor value
--- @example print(math.floor(2.2))
--- @result 2


--- @function fmod
--- @desc Returns remainder of the division of the first supplied value by the second supplied value.
--- @p @number dividend
--- @p @number divisor
--- @r @number floor value
--- @example -- 5 * 4 is 20, leaving a remainder of 3 to reach 23
--- @example print(math.fmod(23, 5))
--- @result 3


--- @function frexp
--- @desc Returns the values of <code>m</code> and <code>exp</code> in the expression <code>x = m * 2 ^ exp</code>, where <code>x</code> is the value supplied to the function. <code>exp</code> is an integer and the absolute value of the mantissa <code>m</code> is in the range 0.5 - 1 (or zero when <code>x</code> is zero).
--- @p @number x value
--- @r @number mantissa m value
--- @r @number exponent e value
--- @example print(math.frexp(10)))
--- @result 0.625	4


--- @function ldexp
--- @desc Returns <code>m * 2 ^ exp</code>, where the mantissa <code>m</code> and exponent <code>exp</code> are values supplied to the function. <code>exp</code> should be an integer value.
--- @p @number m
--- @p @number exp
--- @r @number m * 2 ^ exp
--- @example print(math.ldexp(2, 4))
--- @result 32.0


--- @function log
--- @desc Returns the natural logarithm of the supplied value.
--- @p @number value
--- @r @number log value
--- @example print(math.log(10))
--- @result 2.302585092994


--- @function log10
--- @desc Returns the base-10 logarithm of the supplied value.
--- @p @number value
--- @r @number log value
--- @example print(math.log(10))
--- @result 1.0


--- @function max
--- @desc Returns the maximum numeric value amongst the arguments given.
--- @p ... values, @function:Varargs of @number values
--- @r @number max value
--- @example print(math.max(12, 10, 14, 3, 8, 13))
--- @result 14


--- @function min
--- @desc Returns the minimum numeric value amongst the arguments given.
--- @p ... values, @function:Varargs of @number values
--- @r @number min value
--- @example print(math.min(12, 10, 14, 3, 8, 13))
--- @result 3


--- @function modf
--- @desc Returns the integral part of the supplied value and the fractional part of the supplied value.
--- @p @number input value
--- @r @number integral value
--- @r @number fractional value
--- @example print(math.modf(5))
--- @example print(math.modf(5.4))
--- @result 5	0.0
--- @result 5	0.4


--- @function normalize
--- @desc Scales a supplied value to between supplied minimum and maximum values.
--- @p @number value
--- @p [opt=0] @number minimum
--- @p [opt=1] @number maximum
--- @r @number normalized value
function math.normalize(value, vmin, vmax)
	vmin = vmin or 0;
	vmax = vmax or 1;
	return (value - vmin) / (vmax - vmin);
end


--- @function pow
--- @desc Returns the first supplied number value to the power of the second supplied number value.
--- @p @number x
--- @p @number y
--- @r @number x ^ y
--- @example print(math.pow(2, 4))
--- @result 16.0


--- @function rad
--- @desc Converts the supplied angle in degrees into an angle in radians. See also @math:deg.
--- @p @number degree value
--- @r @number value in radians
--- @example print(math.rad(180))
--- @result 3.1415926535898


--- @function random
--- @desc Provides an interface to the pseudo-random number generator provided by ANSI C. This function returns a random number between two optionally-supplied limits. If no arguments are supplied, those limits are <code>0</code> and <code>1</code>. If one argument <code>a</code> is supplied, those limits are <code>1</code> and <code>a</code>. If two arguments <code>a</code> and <code>b</code> are supplied then those limits are <code>a</code> and <code>b</code>.
--- @desc If no arguments are supplied the returned value is real, whereas if any arguments are supplied the returned value is an integer.
--- @desc Note that use of this function is discouraged, as it will generate different results on different clients in a multiplayer game. Acting upon the result of this function in multiplayer scripts will likely cause desyncs.
--- @p [opt=nil] @number first limit
--- @p [opt=nil] @number second limit
--- @r @number random number
--- @example print(math.random())		-- returned value will be 0..1
--- @example print(math.random(10))		-- returned value will be 1..10
--- @example print(math.random(5, 10))		-- returned value will be 5..10
--- @result 0.84018771676347
--- @result 4
--- @result 9


--- @function randomseed
--- @desc Sets the supplied value as the seed for the random number system.
--- @p @number seed
--- @example math.randomseed(os.clock()))		-- use os clock as random seed


--- @function sin
--- @desc Returns the sine of the supplied radian value.
--- @p @number value
--- @r @number sine value
--- @example print(math.sin(0.5235987755983))
--- @result 0.5


--- @function sinh
--- @desc Returns the hyperbolic sine of the supplied value.
--- @p @number value
--- @r @number hyperbolic sine value
--- @example print(math.sinh(0.5235987755983))
--- @result 0.54785347388804


--- @function sqrt
--- @desc Returns the square root of the supplied value.
--- @p @number value
--- @r @number square root value
--- @example print(math.sqrt(4))
--- @result 2.0


--- @function tan
--- @desc Returns the tangent of the supplied radian value.
--- @p @number value
--- @r @number tan value
--- @example print(math.tan(0.64350110879328))
--- @result 0.74999999999999


--- @function tanh
--- @desc Returns the hyperbolic tangent of the supplied value.
--- @p @number value
--- @r @number hyperbolic tan value
--- @example print(math.tanh(0.64350110879328))
--- @result 0.56727870240097