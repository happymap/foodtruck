import scrapy
import pytz

from schedules.items import SchedulesItem
from datetime import datetime, timedelta

class JapaCurrySpider(scrapy.Spider):
	name = "japacurry"
	start_urls = ["http://japacurry.com/"];

	def parse(self, response):
		time_delimiter = "-"

		for schedule in response.xpath('//dl[@class="schedule-grid"]'):
			date = schedule.xpath('dt[@class="date"]/text()').extract()[0]
			times = schedule.xpath('dd[@class="time"]/text()').extract()[0]
			times = times.split(time_delimiter)
			address = schedule.xpath('dd[@class="place"]/text()').extract()[0]
			city = "San Francisco"
			state = "CA"

			item = SchedulesItem()

			if (date and times and len(times) == 2):
				date = date.strip()
				start_time = datetime.strptime("2015/" + date + " " + times[0].strip(), "%Y/%m/%d %H:%M")
				end_time = datetime.strptime("2015/" + date + " " + times[1].strip(), "%Y/%m/%d %H:%M")

				# if start_time is after the end_time, means time is in 12-hour format
				if (start_time > end_time):
					end_time += timedelta(hours=12)

				item['start_time'] = start_time
				item['end_time'] = end_time
				item['address'] = address
				item['city'] = city
				item['state'] = state

				yield item