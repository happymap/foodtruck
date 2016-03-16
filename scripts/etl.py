#!/usr/bin/env python

import csv
import copy
import re

DAYS_COUNTER = {"mo":0, "tu":0, "we":0, "th":0, "fr":0, "sa":0, "su":0}
DAYS_LIST = ["mo", "tu", "we", "th", "fr", "sa", "su"]

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
		return num + 12
	elif 'AM' in hour_str:
		return num
	else:
		return -1


with open('Mobile_Food_Facility_Permit.csv') as csvfile:
	reader = csv.reader(csvfile, delimiter=',',  quotechar='"')
	for row in reader:
		application = {}
		status = row[10]
		if status != "APPROVED":
			continue
		dayshours = row[17]

		groups = dayshours.split(';')
		for group in groups:
			if len(group.strip()) == 0:
				continue
			parts = group.split(':')
			if len(parts) != 2:
				continue
			dates = parts[0]
			hours = parts[1]

			print dates_parser(dates)
			print hours_parser(hours)


