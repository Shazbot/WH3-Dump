import subprocess
import sys
import importlib.util

# Upon execution we check to see if the packages in "required_packages" are in fact installed on the test machine.
# if they aren't we install them.
if __name__ == "__main__":
	required_packages = {"luadata", "colorama", "fileLock"}
	for package in required_packages:
		spec = importlib.util.find_spec(package)
		if spec is None:
			python = sys.executable
			subprocess.check_call([python, '-m', 'pip', 'install', package])