import scrapy
import pytz
import datetime

from schedules.items import SchedulesItem

class JapaCurrySpider(scrapy.Spider):
	name = "japacurry"
	start_urls = ["http://japacurry.com/"];

	tz = "America/Los_Angeles"
	time_delimiter = "-"

	def parse(self, response):


		for schedule in response.xpath('//dl[@class="schedule-grid"]'):
			date = schedule.xpath('dt[@class="date"]/text()').extract()[0]
			times = schedule.xpath('dd[@class="time"]/text()').extract()[0]
			address = schedule.xpath('dd[@class="place"]/text()').extract()[0]
			city = "San Francisco"
			state = "CA"

			start_time = 

			item = SchedulesItem()


			print date, time, address


	# date: 10/15
	# time: 11:00
	def convertDateToTimestamp(self, date, time):
		naive_date = datetime.datetime.strptime("2015/" + date + " " + time, "%Y/%m/%d %H:%M")
		localtz = pytz.timezone(tz)
		print(localtz.localize(naive_date))