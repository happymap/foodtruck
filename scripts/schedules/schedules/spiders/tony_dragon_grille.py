import scrapy
import pytz
import utility

from schedules.items import SchedulesItem
from DBUtil import *

class TonyDragonGrilleSpider(scrapy.Spider):
    name = "tonydragongrille"
    start_urls = ["https://www.tonydragonsgrille.com"]

    def parse(self, response):

        # transaction begins
        get_db().begin()
        try:
            Schedule.delete().where(Schedule.truck_id == 9).execute()

            address = "Madison Ave & E 62nd St, New York, NY 10065"
            city = "New York"
            state = "NY"
            zipCode = "10065"
            latitude = 40.765467
            longitude = -73.970040

            for content in response.xpath('//div[@class="sqs-block-content"]'):
                if not (len(content.xpath('.//h3[@class="text-align-center"]/text()').extract()) > 0 and 
                    content.xpath('.//h3[@class="text-align-center"]/text()').extract()[0].strip().lower() == 'hours'):
                    continue

                for schedule in content.xpath('.//h1[@class="text-align-center"]/text()').extract():
                    scheduleStr = schedule.strip().lower().replace("-", "")
                    parts = scheduleStr.split()

                    if len(parts) == 4:
                        startDay = utility.FULL_DAYS_MAP[parts[0]]
                        endDay = utility.FULL_DAYS_MAP[parts[1]]
                        startTime = utility.parse_times_string(parts[2])
                        endTime = utility.parse_times_string(parts[3])

                        for i in range(startDay, endDay + 1):
                            item = SchedulesItem()
                            item['day'] = i
                            item['start_time'] = startTime
                            item['end_time'] = endTime
                            item['truck_id'] = 9
                            item['city'] = city
                            item['zip'] = zipCode
                            item['latitude'] = latitude
                            item['longitude'] = longitude
                            item['address'] = address
                            item['state'] = state

                            print item
                            schedule = utility.convert_to_pojo(item)
                            schedule.save()
                    else:
                        item = SchedulesItem()
                        item['day'] = utility.FULL_DAYS_PLURAL_MAP[parts[0]]
                        item['start_time'] = utility.parse_times_string(parts[1])
                        item['end_time'] = utility.parse_times_string(parts[2])
                        item['truck_id'] = 9
                        item['city'] = city
                        item['zip'] = zipCode
                        item['latitude'] = latitude
                        item['longitude'] = longitude
                        item['address'] = address
                        item['state'] = state
                        schedule = utility.convert_to_pojo(item)
                        schedule.save()

        except:
            get_db().rollback()
        get_db().commit()
