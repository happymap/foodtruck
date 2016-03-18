#!/usr/bin/env python

import csv
import copy
import re
import MySQLdb

DAYS_COUNTER = {"mo":0, "tu":0, "we":0, "th":0, "fr":0, "sa":0, "su":0}
DAYS_LIST = ["mo", "tu", "we", "th", "fr", "sa", "su"]
DAYS_VALUE = {"mo":1, "tu":2, "we":3, "th":4, "fr":5, "sa":6, "su":7}

# examples:
# 1. Mo-Su:10AM-6PM
# 2. Tu/Th/Fr:9AM-3PM
# 3. Sa/Sa/Sa/Sa/Sa:12AM-1AM;Mo/Mo/Mo/Mo/Mo:6AM-7AM/8AM-9AM;Su/Su/Su/Su/Su:9AM-10AM;Mo/Mo/Mo/Mo/Mo:9AM-1
# 4. Tu:11AM-2PM
# 5. Th:11AM-1PM;We:12PM-2PM;Mo/Fr:12PM-4PM;Tu:1PM-4PM

def dates_parser(dates):
	result = []
	if '-' in dates:
		days = dates.split('-')
		start = False
		end = False
		for day in DAYS_LIST:
			if end == True:
				break
			if start == True and end == False:
				result.append(day)
			if start == False and day.lower() == days[0].lower():
				result.append(day)
				start = True
			elif start == True and day.lower() == days[1].lower():
				end = True
	elif '/' in dates:
		days = dates.split('/')
		days_counter_copy = copy.deepcopy(DAYS_COUNTER)
		for day in days:
			if day.lower() in days_counter_copy:
				days_counter_copy[day.lower()] += 1
		for key,count in days_counter_copy.iteritems():
			if count > 0:
				result.append(key)
	elif dates.lower() in DAYS_LIST:
		result.append(dates.lower())

	return result

def hours_parser(hours):
	result = []
	events = hours.split('/')
	for event in events:
		pair = []
		start_and_end = event.split('-')
		if len(start_and_end) != 2:
			continue
		start = get_actual_hour(start_and_end[0].strip())
		end = get_actual_hour(start_and_end[1].strip())
		pair.append(start)
		pair.append(end)
		result.append(pair)
	return result
		
def get_actual_hour(hour_str):
	num = int(re.findall(r'\d+', hour_str)[0])
	if 'PM' in hour_str:
		if num == 12:
			return num
		else:
			return num + 12
	elif 'AM' in hour_str:
		if num == 12:
			return 0
		else:
			return num
	else:
		return -1

# DB conncetion
db = MySQLdb.connect(host="localhost", user="foodtruck", passwd="please", db="food_truck")
cur = db.cursor()

with open('Mobile_Food_Facility_Permit.csv') as csvfile:
	reader = csv.reader(csvfile, delimiter=',',  quotechar='"')
	for row in reader:
		application = {}
		status = row[10]
		if status != "APPROVED":
			continue
		dayshours = row[17]
		address = row[5]
		lat =  row[14]
		lon = row[15]
		name = row[1]
		application_id = row[0]

		if len(lat.strip()) == 0 or len(lon.strip()) == 0:
			continue

		truck_insert_script = 'insert into truck(name, application_id, latitude, longitude, address) values("' + name + '",' + application_id + ',' + lat + ',' + lon + ',"' + address + '"' + ')'
		cur.execute(truck_insert_script)

		db.commit()

		truck_id = cur.lastrowid

		groups = dayshours.split(';')
		for group in groups:
			if len(group.strip()) == 0:
				continue
			parts = group.split(':')
			if len(parts) != 2:
				continue
			dates = parts[0]
			hours = parts[1]

			parsed_days = dates_parser(dates)
			parsed_hours = hours_parser(hours)

			for day in parsed_days:
				for hour in parsed_hours:
					start_hour = hour[0]
					end_hour = hour[1]

					schedule_insert_script = 'insert into schedule(day, start_hour, end_hour, truck_id) values(' + str(DAYS_VALUE[day]) + ',' + str(start_hour) + ',' + str(end_hour) + ',' + str(truck_id) + ')'
					cur.execute(schedule_insert_script)
					db.commit()