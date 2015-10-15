# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class SchedulesItem(scrapy.Item):
    start_time = scrapy.Field()
    end_time = scrapy.Field()
    address = scrapy.Field()
    city = scrapy.Field()
    state = scrapy.Field()
    zip =  scrapy.Field()
    display_address = scrapy.Field()
    longitude = scrapy.Field()
    latitude = scrapy.Field()


