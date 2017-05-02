import scrapy
import pytz

from schedules.items import SchedulesItem

class SenorSisigSpider(scrapy.Spider):
	name = "senorsisig"
	start_urls = ["http://www.senorsisig.com"];

	def parse(self, response):

		for schedule in response.xpath('//div[@id="loc-wrap"]/section[contains(@data-wcal-date, "2017")]'):
			address = schedule.xpath('div[@class="row map-row"]/div[@class="span4 location"]/a/@data-ext-map-link').extract()[0]
			day_str = schedule.xpath('div[@class="row map-row"]/div[@class="span2 date"]/text()').extract()[0].trim()
			print day_str

			# day = schedule.xpath('dt[@class="date"]/span[@class="day"]/text()').extract()[0]
			# times = schedule.xpath('dd[@class="time"]/text()').extract()[0]
			# times = times.split(time_delimiter)
			# address = schedule.xpath('dd[@class="place"]/text()').extract()[0]
			# city = "San Francisco"
			# state = "CA"

			# item = SchedulesItem()

			# if (times and len(times) == 2):
			# 	day_num = DAYS_MAP[day.lower()]
			# 	start_time_str = times[0].strip()
			# 	end_time_str = times[1].strip()

			# 	# if start_time is after the end_time, means time is in 12-hour format
			# 	times_pair = self.time_in_seconds(start_time_str, end_time_str)

			# 	item['start_time'] = times_pair[0]
			# 	item['end_time'] = times_pair[1]
			# 	item['address'] = address
			# 	item['city'] = city
			# 	item['state'] = state
			# 	item['day'] = day_num

			# 	yield item