import luadata

def create_faction_load_test_lua_table(path, data):
	'''Converts a given python dict into a lua table format and generates a lua file at a given path.'''	
	luadata.write(path, data, encoding="utf-8", indent=" ", prefix="g_faction_load_context_table = ")