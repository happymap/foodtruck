import scrapy
import pytz
import utility

from schedules.items import SchedulesItem
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

class BowldAcaiSpider(scrapy.Spider):
    name = "bowldacai"
    start_urls = ["http://www.bowldacai.com/"]

    def parse(self, response):

        # transaction begins
        get_db().begin()
        try:
            Schedule.delete().where(Schedule.truck_id == 6).execute()

            for schedule in response.xpath('//div[@class="slide"]'):
                dates = schedule.xpath('.//h2/text()').extract()[0].strip()
                if len(dates) == 0:
                    continue

                day = DAYS_MAP[dates.split(" ")[1].lower().strip()]
                times = schedule.xpath('.//strong[@class="title"]/text()').extract()
                addresses = schedule.xpath('.//address/text()').extract()

                for i in range(0, len(times)):
                    if '-' not in times[i]:
                        continue

                    time = self.process_times(times[i])
                    startTime = time[0]
                    endTime = time[1]

                    originalAddress = addresses[i]
                    address = utility.formalize_address(originalAddress)
                    coordinates = utility.get_coordinate_by_address(address)
                    latitude = coordinates['latitude']
                    longitude = coordinates['longitude']

                    item = SchedulesItem()
                    item['truck_id'] = 6
                    item['day'] = day
                    item['address'] = address
                    item['start_time'] = startTime
                    item['end_time'] = endTime
                    item['latitude'] = latitude
                    item['longitude'] = longitude
                    item['zip'] = coordinates['zip']

                    addressParts = item['address'].split(",")
                    item['city'] = addressParts[len(addressParts) - 2].strip()
                    item['state'] = "CA"

                    # yield item

                    schedule = utility.convert_to_pojo(item)
                    schedule.save()
        except:
            get_db().rollback()
        get_db().commit()
                
    def process_times(self, timeStr):
        times = timeStr.split("-")
        startTime = times[0]
        endTime = times[1]

        startTimeParts = self.break_parts(startTime)
        endTimeParts = self.break_parts(endTime)

        startTimestamp = self.parse_time(startTimeParts[0], startTimeParts[1])
        endTimestamp = self.parse_time(endTimeParts[0], endTimeParts[1])
        return [startTimestamp, endTimestamp]

    def break_parts(self, timeStr):
        if timeStr.endswith('am') or timeStr.endswith('pm'):
            return [timeStr[0:len(timeStr) - 2], timeStr[len(timeStr) - 2:len(timeStr)]]
        if timeStr.endswith('a') or timeStr.endswith('p'):
            return [timeStr[0:len(timeStr) - 1], timeStr[len(timeStr) - 1:len(timeStr)]]
        return []

    def parse_time(self, timeStr, amOrPm):
        if ':' in timeStr:
            hour = int(timeStr.split(":")[0])
            minute = int(timeStr.split(":")[1])

            if amOrPm == 'p' or amOrPm == 'pm':
                hour += 12
            return hour * 3600 + minute * 60
        else:
            hour = int(timeStr)

            if amOrPm == 'p' or amOrPm == 'pm':
                hour += 12
            return hour * 3600
