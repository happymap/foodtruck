import scrapy
import pytz
import utility
import urllib

from schedules.items import SchedulesItem
from DBUtil import *

TRUCK_ID = 11

class PrimaveraSpider(scrapy.Spider):
    name = "primavera_spider"
    start_urls = ["https://www.yelp.com/biz/primavera-san-francisco"]

    def parse(self, response):

        # transaction begins
        get_db().begin()
        try:
            Schedule.delete().where(Schedule.truck_id == TRUCK_ID).execute()
            for schedule in response.xpath('//table[@class="table table-simple hours-table"]/tbody/tr'):
                timeStr = schedule.xpath('.//td/text()').extract()[0].lower().strip()

                if timeStr == 'closed':
                    continue

                times = schedule.xpath('.//td/span[@class="nowrap"]/text()').extract()

                startTime = utility.parse_times_string(times[0])
                endTime = utility.parse_times_string(times[1])

                dayStr = schedule.xpath('.//th[@scope="row"]/text()').extract()[0].lower().strip()

                print dayStr
                day = utility.DAYS_MAP[dayStr]

                item = SchedulesItem()
                item['day'] = day
                item['latitude'] = 37.7955307
                item['longitude'] = -122.3951161
                item['zip'] = "94111"
                item['address'] = "1 Ferry Plz Ferry Plaza Farmers Market, San Francisco, CA 94111"
                item['city'] = 'San Francisco'
                item['state'] = 'CA'
                item['truck_id'] = TRUCK_ID
                item['start_time'] = startTime
                item['end_time'] = endTime

                schedule = utility.convert_to_pojo(item)
                schedule.save()

        except Exception as e:
            print e
            get_db().rollback()
        get_db().commit()