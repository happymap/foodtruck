import scrapy
import pytz
import utility
import re

from schedules.items import SchedulesItem
from DBUtil import *

TRUCK_ID = 10

class DelPopoloSpider(scrapy.Spider):
    name = "delpopolospider"
    start_urls = ["http://www.delpopolosf.com/truck"]

    def parse(self, response):
        # transaction begins
        get_db().begin()
        try:
            Schedule.delete().where(Schedule.truck_id == TRUCK_ID).execute()

            for schedule in response.xpath('//div[@id="locations"]/p'):
                timeDateStr = schedule.xpath('.//strong/text()')[0].extract()
                
                dayStrSearch = re.search('(.*),.*', timeDateStr, re.IGNORECASE)
                dayStr = dayStrSearch.group(1).strip().lower()
                day = utility.FULL_DAYS_MAP[dayStr]

                timeStrSearch = re.search('.*@(.*)', timeDateStr, re.IGNORECASE)
                timeStr = timeStrSearch.group(1).strip().lower()
                startTime = utility.parse_times_string(timeStr)

                # the website doesn't specify an end time, so put 1pm as a placeholder
                endTime = 13 * 3600

                addrString = schedule.xpath('.//a/text()')[0].extract()
                addrString = addrString.replace('near', 'and')
                addrString += ", San Francisco"

                print addrString

                coords = utility.get_coordinate_by_address(addrString)

                item = SchedulesItem()
                item['day'] = day
                item['latitude'] = coords['latitude']
                item['longitude'] = coords['longitude']
                item['zip'] = coords['zip']
                item['address'] = coords['address']
                item['city'] = 'San Francisco'
                item['state'] = 'CA'
                item['truck_id'] = TRUCK_ID
                item['start_time'] = startTime
                item['end_time'] = endTime

                schedule = utility.convert_to_pojo(item)
                schedule.save()

        except Exception as e:
            print "ERROR: " + e
            get_db().rollback()
        get_db().commit()