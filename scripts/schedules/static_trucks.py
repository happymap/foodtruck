import csv
import os 

from schedules.items import SchedulesItem
from DBUtil import *

STATIC_TRUCKS_LIST = ['el_gallo_giro.csv']
truck_id = -1

for fileName in STATIC_TRUCKS_LIST:
    dir_path = os.path.dirname(os.path.realpath(__file__))
    with open(dir_path + '/static_trucks/' + fileName, 'rb') as csvfile:
        filereader = csv.reader(csvfile, delimiter=',', quotechar='"')
        get_db().begin()
        try:
            for row in filereader:
                if len(row) == 1:
                    truck_id = row[0]
                    Schedule.delete().where(Schedule.truck_id == truck_id).execute()
                    continue

                item = SchedulesItem()
                item['day'] = row[0]
                item['address'] = row[2]
                item['start_time'] = row[8]
                item['end_time'] = row[9]
                item['city'] = row[5]
                item['state'] = row[6]
                item['zip'] = row[7]
                item['latitude'] = row[3]
                item['longitude'] = row[4]
                item['truck_id'] = truck_id
                schedule = Schedule(
                    day = row[0],
                    truck_id = truck_id,
                    address = row[2],
                    latitude = row[3],
                    longitude = row[4],
                    city = row[5],
                    state = row[6],
                    zip = row[7],
                    start_time = row[8],
                    end_time = row[9])
                schedule.save()
        except:
            get_db().rollback()
        get_db().commit()
