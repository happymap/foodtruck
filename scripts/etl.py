#!/usr/bin/env python

import csv
import copy

DAYS_LIST = {"mo":0, "tu":0, "we":0, "th":0, "fr":0, "sa":0, "su":0}

def dates_parser(dates):
	result = []
	if '-' in dates:
		days = dates.split('-')
		start = False
		end = False
		for day,index in DAYS_LIST.iteritems():
			if day.lower() == days[0].lower():
				if start == False and end == False:
					result.append(day)
					start = True
				elif start == True and end == False:
					result.append(day)
					end = True
			if start == True and end == False:
				result.append(day)
			elif end == True:
				break
			elif start == False and end == False:
				continue

	elif '/' in dates:
		days = dates.split('/')
		days_list_copy = copy.deepcopy(DAYS_LIST)
		for day in days:
			if day.lower() in days_list_copy:
				days_list_copy[day.lower()] += 1
		for key,count in days_list_copy.iteritems():
			if count > 0:
				result.append(key)
	elif dates.lower() in DAYS_LIST:
		result.append(dates.lower())

	print result


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
			times = parts[1]

			dates_parser(dates)

		# examples:
		# 1. Mo-Su:10AM-6PM
		# 2. Tu/Th/Fr:9AM-3PM
		# 3. Sa/Sa/Sa/Sa/Sa:12AM-1AM;Mo/Mo/Mo/Mo/Mo:6AM-7AM/8AM-9AM;Su/Su/Su/Su/Su:9AM-10AM;Mo/Mo/Mo/Mo/Mo:9AM-1
		# 4. Tu:11AM-2PM
		# 5. Th:11AM-1PM;We:12PM-2PM;Mo/Fr:12PM-4PM;Tu:1PM-4PM

