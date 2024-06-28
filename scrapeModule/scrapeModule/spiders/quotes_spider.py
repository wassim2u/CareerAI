
from pathlib import Path

import scrapy
import requests
import w3lib.html
from enum import Enum

from scrapy.linkextractors import LinkExtractor

GOOGLE_JOB_URL = "https://careers.google.com/jobs"

class CSSJobConstantSelectors(str, Enum):
    JOBLINK = "a.VfPpkd-RLmnJb::attr(href)"
    TITLE =  "h2.p1N2lc::text"
    QUALIFICATIONS = ""
    ABOUT = ""
    RESPONSIBILITIES = ""

base_url = 'https://careers.google.com/jobs'
params = {
    't': 'sq',
    'li': '20',
    'st': '0',
    'jlo': 'all'
}

result = requests.get(url=base_url, params=params)
url = result.url.replace('?', '#')

class JobSpider(scrapy.Spider):
    name = "jobscraper"
    start_urls = [
        'https://www.google.com/about/careers/applications/jobs/results',
    ]
   

    def parse(self, response):

        # for job_num,job in enumerate(response.css("li.lLd3Je")):

        for link in (response.css(CSSJobConstantSelectors.JOBLINK)):
            print(link)
            job_link = response.urljoin(link)
            yield scrapy.Request(job_link, callback=self.parse)
        exit()
        for job_num, job_link in enumerate(response.css(CSSJobConstantSelectors.JOBLINK).extract()):
            print(job_num)
            print(response)
            print(job_link)
            # learn_more_request = scrapy.Request(response.urljoin(learn_more_url))
            # yield {
            #     'Job Title': job.css("h3.QJPWVe::text")[0].extract(),
            #     'Job Description': job.css("div.Xsxa1e")[0].extract(),
            #     'Location': job.css("span.r0wTof::text")[0].extract(),
            #     'Experience': job.css("span.wVSTAb::text")[0].extract(),    
            # }
            print(response.urljoin(job_link))
            current_job_response = scrapy.Request(response.urljoin(job_link)).response
            
            yield {
                'Job Title': current_job_response.css("h2.p1N2lc::text")[0].extract(),
                'Job Description' : current_job_response.css("div.KwJkGe")[0].extract()
            }
            


        # TODO: Get information from Learn more.
        # next_page_url = response.css("li.next > a::attr(href)").extract_first()
        # if next_page_url is not None:
        #     yield scrapy.Request(response.urljoin(next_page_url))
        
        
        


        # 'Job Description': w3lib.html.remove_tags(job.css("div.r0wTof::text")[0]).extract_first(),

    
        
        
        
        
        
        