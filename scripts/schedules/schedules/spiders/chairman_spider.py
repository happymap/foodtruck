import scrapy
import pytz
import utility

from schedules.items import SchedulesItem
from DBUtil import *

DAYS_MAP = {
    "mon": 0,
    "tue": 1,
    "wed": 2,
    "thu": 3,
    "fri": 4,
    "sat": 5,
    "sun": 6
}

class ChairmanSpider(scrapy.Spider):
    name = "chairman"
    start_urls = ["http://sharp-fire-2992.herokuapp.com/"]

    def parse(self, response):

        # transaction begins
        get_db().begin()
        try:
            Schedule.delete().where(Schedule.truck_id == 4).execute()

            for schedule in response.xpath('//tr[@name="schedule_day"]'):
                dayStr = schedule.xpath('.//div[@id="day"]/text()').extract()[0].strip().lower()


                for lunch in schedule.xpath('.//div[@id="lunch_booking"]'):
                    self.process_schedule(lunch, dayStr)

                for dinner in schedule.xpath('.//div[@id="dinner_booking"]'):
                    self.process_schedule(dinner, dayStr)

        except:
            get_db().rollback()

        get_db().commit()

    def process_schedule(self, meal, dayStr):
        if len(meal.xpath('.//address/text()').extract()) == 0:
            return

        address = meal.xpath('.//address/text()').extract()[0].strip()
        hoursStr = meal.xpath('.//div[@id="hours"]/text()').extract()[0].strip()
        
        startTimeStr = hoursStr.split("-")[0].lower().strip()
        endTimeStr = hoursStr.split("-")[1].lower().strip()
        if "am" not in startTimeStr and "pm" not in startTimeStr:
            startTimeStr += endTimeStr[len(endTimeStr) - 2:]
        startTime = self.time_in_seconds(startTimeStr)
        endTime = self.time_in_seconds(endTimeStr)    

        item = SchedulesItem()
        item['day'] = DAYS_MAP[dayStr]
        item['address'] = utility.formalize_address(address)
        item['start_time'] = startTime
        item['end_time'] = endTime

        addressParts = item['address'].split(",")
        item['city'] = addressParts[len(addressParts) - 2].strip()
        item['state'] = "CA"
        item['zip'] = addressParts[len(addressParts) - 1].strip().split()[1]

        coordinates = utility.get_coordinate_by_address(item['address'])
        item['latitude'] = coordinates['latitude']
        item['longitude'] = coordinates['longitude']
        item['truck_id'] = 4

        schedule = utility.convert_to_pojo(item)
        schedule.save()

        print item

    def time_in_seconds(self, timeStr):
        amOrPm = timeStr[len(timeStr) - 2:]
        time = timeStr[:len(timeStr) - 2]
        minute = 0
        hour = 0

        if ':' in time:
            minute = int(time.split(":")[1])
            hour = int(time.split(":")[0])
        else:
            hour = int(time)

        if amOrPm == "pm":
            hour += 12
        return hour * 3600 + minute * 60


