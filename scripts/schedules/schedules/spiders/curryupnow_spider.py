import scrapy
import pytz
import utility
import urllib

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

class CurryUpNowSpider(scrapy.Spider):
    name = "curryupnow"
    start_urls = ["http://www.curryupnow.com/schedule/"]

    def parse(self, response):

        # transaction begins
        get_db().begin()
        try:
            Schedule.delete().where(Schedule.truck_id == 3).execute()

            for schedule in response.xpath('//div[@class="row sqs-row"]'):
                dayStr = schedule.xpath('.//div[@class="col sqs-col-3 span-3"]/div[@class="sqs-block html-block sqs-block-html"]/div[@class="sqs-block-content"]/h1/text()').extract()

                if len(dayStr) == 0:
                    continue

                day = DAYS_MAP[dayStr[0].split(",")[0].strip().lower()]
                content = schedule.xpath('.//div[@class="col sqs-col-4 span-4"]/div[@class="sqs-block html-block sqs-block-html"]/div[@class="sqs-block-content"]')
                daySchedules = content.xpath('.//p')

                for daySchedule in daySchedules:
                    rawStrs = daySchedule.xpath("text()").extract()[0]
                    googleMapUrl = daySchedule.xpath('.//@href').extract()[0]
                    urls = googleMapUrl.split("/")
                    addrUrl = urls[5]
                    addrParts = addrUrl.split("+")
                    coordStrs = urls[6]
                    coordParts = coordStrs.split(",")

                    item = SchedulesItem()
                    item['truck_id'] = 3
                    item['zip'] = addrParts[len(addrParts) - 1]
                    item['state'] = addrParts[len(addrParts) - 2]
                    item['address'] = self.get_address(addrParts)
                    newAddrParts = item['address'].split(",")
                    item['city'] = newAddrParts[len(newAddrParts) - 2].strip()
                    item['day'] = day
                    item['latitude'] = float(coordParts[0][1:])
                    item['longitude'] = float(coordParts[1])

                    rawStrIIs = rawStrs.split("|")
                    scheduleStr = rawStrIIs[1]
                    item['start_time'] = self.time_in_seconds(scheduleStr.split("-")[0].strip())
                    item['end_time'] = self.time_in_seconds(scheduleStr.split("-")[1].strip())

                    schedule = utility.convert_to_pojo(item)
                    schedule.save()

        except:
            get_db().rollback()
        get_db().commit()


    def get_address(self, addrParts):
        return ' '.join(str(x) for x in addrParts)

    def time_in_seconds(self, timeStr):
        amOrPm = timeStr[len(timeStr) - 2:]
        hour = int(timeStr[:len(timeStr) - 2])
        if amOrPm == "pm":
            hour += 12
        return hour * 3600

