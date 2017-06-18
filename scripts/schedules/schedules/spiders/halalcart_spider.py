import scrapy
import pytz
import utility
import urllib

from schedules.items import SchedulesItem
from DBUtil import *


class CurryUpNowSpider(scrapy.Spider):
    name = "halalcart_spider"
    start_urls = ["http://thehalalcart.com/#locations"]

    def parse(self, response):

        # transaction begins
        get_db().begin()
        try:
            Schedule.delete().where(Schedule.truck_id == 7).execute()
            for schedule in response.xpath('//div[@class="rounded-corners clearfix grpelem"]'):
                locationAndTime = schedule.xpath('.//div[@class="content-brown clearfix colelem"]')
                if len(locationAndTime) < 2:
                    continue

                locations = locationAndTime[0].xpath('.//span/text()')
                
                address = ""
                for loc in locations:
                    address += loc.extract() + " "
                address = address.strip()

                dateTime = locationAndTime[1].xpath('.//span/text()')
                dayStr = dateTime[0].extract()
                timeStr = dateTime[1].extract()

                timestamps = utility.parse_times_pair_string(timeStr)

                startDay = utility.DAYS_MAP[dayStr.split('-')[0].lower().strip()]
                endDay = utility.DAYS_MAP[dayStr.split('-')[1].lower().strip()]
                for i in range(startDay, endDay + 1):


                    item = SchedulesItem()
                    item['day'] = i
                    item['address'] = address
                    item['start_time'] = timestamps[0]
                    item['end_time'] = timestamps[1]

                    item['city'] = 'San Francisco'
                    item['state'] = "CA"
                    item['zip'] = address.split(' ')[len(address.split(' ')) - 1].strip()

                    coordinates = utility.get_coordinate_by_address(address)
                    item['latitude'] = coordinates['latitude']
                    item['longitude'] = coordinates['longitude']
                    item['truck_id'] = 7

                    print item

                    schedule = utility.convert_to_pojo(item)
                    schedule.save()

        except:
            get_db().rollback()
        get_db().commit()
