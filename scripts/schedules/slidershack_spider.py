import scrapy
import pytz
import requests
import datetime
import utility

from datetime import timedelta
from DBUtil import *

DAYS_MAP = {
    "monday": 0,
    "tuesday": 1,
    "wednesday": 2,
    "thursday": 3,
    "friday": 4,
    "saturday": 5,
    "sunday": 6
}


def get_time(dateObj):
    hour = dateObj.hour
    minute = dateObj.minute
    second = dateObj.second

    return hour * 3600 + minute * 60 + second

name = "slidershack"
urlTemplate = ['https://www.googleapis.com/calendar/v3/calendars/pjj76fohn87o671h08f5s3aj1s%40group.calendar.google.com/events?orderBy=startTime&key=AIzaSyC-KzxSLmmZitsCVv2DeueeUxoVwP0raVk&timeMin=', 'T00%3A00%3A00%2B00%3A00&timeMax=', 'T00%3A00%3A00%2B00%3A00&timeZone=America%2FLos_Angeles&singleEvents=true']
now = datetime.datetime.now()
end = now + timedelta(days=7)
nowStr = "%s-%s-%s" % (now.year, now.month, now.day)
endStr = "%s-%s-%s" % (end.year, end.month, end.day)
url = urlTemplate[0] + nowStr + urlTemplate[1] + endStr + urlTemplate[2]
r = requests.get(url)
response = r.json()

get_db().begin()
try:
    Schedule.delete().where(Schedule.truck_id == 5).execute()

    for item in response['items']:
        print item
        startTime = item['start']['dateTime']
        startTimeArr = startTime.split('-')[0 : len(startTime.split('-')) - 1]
        startTime = '-'.join(startTimeArr)

        endTime = item['end']['dateTime']
        endTimeArr = endTime.split('-')[0 : len(endTime.split('-')) - 1]
        endTime = '-'.join(endTimeArr)

        starttimeObj = datetime.datetime.strptime(startTime, '%Y-%m-%dT%H:%M:%S')
        endtimeObj = datetime.datetime.strptime(endTime, '%Y-%m-%dT%H:%M:%S')

        location = item['summary'] + " , San Francisco, CA"

        if 'location' in item:
            location = item['summary']

        address = utility.formalize_address(location)
        coordinates = utility.get_coordinate_by_address(address)
        city = address.split(',')[len(address.split(',')) - 2]

        schedule = Schedule(
            day = starttimeObj.weekday(),
            truck_id = 5,
            address = address.strip(),
            latitude = coordinates['latitude'],
            longitude = coordinates['longitude'],
            city = city.strip(),
            state = "CA",
            zip = coordinates['zip'],
            start_time = get_time(starttimeObj),
            end_time = get_time(endtimeObj))

        schedule.save()

except:
    get_db().rollback()
get_db().commit()




