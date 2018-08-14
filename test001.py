#encoding: utf-8
import os
import unittest
import time
from selenium import webdriver
class test_login_test(unittest.TestCase):
    def setUp(self):
        abspath = os.path.abspath('/usr/local/bin/chromedriver')
        self.driver = webdriver.Chrome(abspath)
    def test_login(self):
        driver = self.driver
        driver.maximize_window()
        driver.implicitly_wait(30)
        driver.get("https://i.huatu.com/login")
        # elem_phone=driver.find_element_by_class_name("form-validate mb-lg ng-invalid ng-dirty ng-touched")
        # elem_phone.send_keys("18514593386")
        # elem_pw = driver.find_element_by_id("exampleInputPassword1")
        # elem_pw.send_keys("180125")
        # elem_login =driver.find_element_by_class_name("btn btn-block btn-primary mt-lg btn-lg mt")
        # elem_login.click()
        elem_pw = driver.find_element_by_class_name('has-feedback')
        elem_pw.send_keys('password','aaaa')
        print (elem_pw.text)
        time.sleep(30)
        self.assertEqual("https://i.huatu.com/home",self.driver.current_url,"登录跳转成功")
       #self.assertEqual(driver.find_element_by_xpath("//a[@title='教务中心']").get_attribute("text"),'教务中心','squccess')
    def tearDown(self):
        self.driver.close()
if __name__ == "__main__":
    unittest.main()