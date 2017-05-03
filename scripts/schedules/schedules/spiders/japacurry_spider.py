import scrapy
import pytz
import utility

from schedules.items import SchedulesItem

DAYS_MAP = {
	"monday": 0,
	"tuesday": 1,
	"wednesday": 2,
	"thursday": 3,
	"friday": 4,
	"saturday": 5,
	"sunday": 6
}

class JapaCurrySpider(scrapy.Spider):
	name = "japacurry"
	start_urls = ["http://japacurry.com/"];

	def parse(self, response):
		time_delimiter = "-"

		for schedule in response.xpath('//dl[@class="schedule-grid"]'):
			day = schedule.xpath('dt[@class="date"]/span[@class="day"]/text()').extract()[0]
			times = schedule.xpath('dd[@class="time"]/text()').extract()[0]
			times = times.split(time_delimiter)
			address = schedule.xpath('dd[@class="place"]/text()').extract()[0]
			city = "San Francisco"
			state = "CA"

			item = SchedulesItem()

			if (times and len(times) == 2):
				day_num = DAYS_MAP[day.lower()]
				start_time_str = times[0].strip()
				end_time_str = times[1].strip()

				# if start_time is after the end_time, means time is in 12-hour format
				times_pair = self.time_in_seconds(start_time_str, end_time_str)

				item['start_time'] = times_pair[0]
				item['end_time'] = times_pair[1]
				item['address'] = address
				item['city'] = city
				item['state'] = state
				item['day'] = day_num

				coordinates = utility.get_coordinate_by_address(address)
				item['latitude'] = coordinates[0]
				item['longitude'] = coordinates[1]

				yield item


	def time_in_seconds(self, start_time_str, end_time_str):
		start_times = start_time_str.split(":")
		start_hour = int(start_times[0])
		start_minute = int(start_times[1])

		end_times = end_time_str.split(":")
		end_hour = int(end_times[0])
		end_minute = int(end_times[1])

		if (start_hour > end_hour):
			end_hour += 12

		return [start_hour * 3600 + start_minute * 60, end_hour * 3600 + end_minute * 60]