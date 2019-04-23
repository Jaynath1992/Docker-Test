from selenium import webdriver
from time import sleep as wait
from selenium.webdriver.chrome.options import Options

#import os
#os.environ["LANG"] = "en_US.UTF-8"


class TestSelenium(object):

    def test_launch_browser(self):
        options = Options()
        options.add_argument("--disable-infobars")
        options.add_argument("test-type")  # solve the chrome security warning
        options.add_argument("--acceptInsecureCerts=true")
        options.add_argument('headless')
        options.add_argument("--window-size=1325x744")
        options.add_argument('disable-gpu')
        options.add_argument('no-sandbox')
        browser = webdriver.Chrome(chrome_options=options)
        browser.get('https://www.amazon.in/')
        browser.maximize_window()
        browser.implicitly_wait(10)
        print browser.title
        browser.find_element_by_id('twotabsearchtextbox').send_keys('Selenium Automation')
        browser.find_element_by_xpath("//input[@value='Go']").click()
        wait(5)
        #assert browser.find_element_by_link_text("Selenium - Web Browser Automation").is_displayed() == True
        print browser.title
        search_results = browser.find_elements_by_tag_name('h2')
        for res in search_results:
                print res.text
