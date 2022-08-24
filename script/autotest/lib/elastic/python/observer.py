from threading import local
import time
import os
import sys
import datetime
import json
import psutil
import requests
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class MyHandler(FileSystemEventHandler):
	def on_created(self, event):
		print("Sending Update...")
		print(f'event type: {event.event_type} path: {event.src_path}')
		with open(event.src_path) as f:
			data = json.load(f)
			f.close()

		json_convert = json.dumps(data)

		if log_base == "user":
			localhost = "http://10.10.11.160:9200/userlogs/_doc"
			print("Sending data to USER index...")
		elif log_base == "nightly":
			logstring = "nightly{week_of_year}{month_of_year}{year}".format(
				week_of_year = datetime.date.today().isocalendar()[1], 
				month_of_year = datetime.datetime.now().month, 
				year = datetime.datetime.now().year
			)
			localhost = "http://10.10.11.160:9200/"+logstring+"/_doc"
			print("Sending data to NIGHTLY index...")
		my_headers = {'Content-Type': 'application/json'}
		request = requests.post(localhost, data=json_convert, headers=my_headers)
		print(str(request.status_code) +" - "+ str(request.reason))
		print(f'Deleting data file: {event.src_path}\n')
		os.remove(event.src_path)

log_base = sys.argv[1] if len(sys.argv) > 1 else "user"

if __name__ == "__main__":
	event_handler = MyHandler()
	observer = Observer()
	elastic_data_path = os.path.expanduser(r'~\AppData\Roaming\CA_Autotest\WH3\elastic_data')
	Path(elastic_data_path).mkdir(exist_ok=True)
	observer.schedule(event_handler, path=elastic_data_path, recursive=False)
	observer.start()
	print("Observer started!")

	try:
		while True:
			active = False
			for i in psutil.process_iter():
				if "warhammer3" in i.name():
					active = True
			if active == False:
				for filename in os.listdir(elastic_data_path):
					file_path = os.path.join(elastic_data_path, filename)
					if os.path.isfile(file_path) or os.path.islink(file_path):
						os.remove(file_path)
				exit()
			time.sleep(1)
	except KeyboardInterrupt:
		observer.stop()
	observer.join()