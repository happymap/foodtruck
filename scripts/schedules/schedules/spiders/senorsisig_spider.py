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

class SenorSisigSpider(scrapy.Spider):
	name = "senorsisig"
	start_urls = ["http://www.senorsisig.com"];

	def parse(self, response):
		for schedule in response.xpath('//div[@id="loc-wrap"]/section[contains(@data-wcal-date, "2017")]'):
			day_str = schedule.xpath('div[@class="row map-row"]/div[@class="span2 date"]/text()').extract()[0].strip().lower()

			if not day_str:
				continue
			address = schedule.xpath('div[@class="row map-row"]/div[@class="span4 location"]/a/@data-ext-map-link').extract()[0]
			times = schedule.xpath('div[@class="row map-row"]/div[@class="span1 time"]/span/text()').extract()
			item = SchedulesItem()
			item['day'] = DAYS_MAP[day_str]
			item['address'] = address
			timeInSeconds = self.get_start_and_end_time(times[0], times[1])
			item['start_time'] = timeInSeconds[0]
			item['end_time'] = timeInSeconds[1]
			item['city'] = address.split(",")[1].strip()
			item['state'] = "CA"
			item['zip'] = address.split(",")[2].strip().split(" ")[1]

			coordinates = utility.get_coordinate_by_address(address)
			item['latitude'] = coordinates['latitude']
			item['longitude'] = coordinates['longitude']
			item['truck_id'] = 2

			schedule = utility.convert_to_pojo(item)
			schedule.save()

			yield item 

	def get_start_and_end_time(self, start_time_str, end_time_str):
		start_times = start_time_str.split(" ")
		end_times = end_time_str.split(" ")
		return [self.time_in_seconds(start_times[0], start_times[1]), self.time_in_seconds(end_times[0], end_times[1])]

	def time_in_seconds(self, time, amOrPm):
		hour = int(time.split(":")[0])
		minute = int(time.split(":")[1])
		if amOrPm == "pm":
			hour += 12
		return hour * 3600 + minute * 60


