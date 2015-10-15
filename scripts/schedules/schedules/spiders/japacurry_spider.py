import scrapy

class JapaCurrySpider(scrapy.Spider):
	name = "japacurry"
	start_urls = ["http://japacurry.com/"];

	def parse(self, response):
		for schedule in response.xpath('//dl[@class="schedule-grid"]'):
			print schedule.xpath('dt[@class="date"]/text()').extract()[0]