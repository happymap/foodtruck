import scrapy

class JapaCurrySpider(scrapy.Spider):
	name = "japacurry"
	start_urls = ['http://japacurry.com/']