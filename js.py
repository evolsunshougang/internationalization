# -*- coding:utf-8 -*-

import sys
import re

reload(sys)
# 截取js里的中文
# 正则匹配结果  例如:（“删除”）
sys.setdefaultencoding('utf-8')


def check_js(check_str):
    target = ""
    temp = check_str.decode("utf8")

    pattern = re.compile(u'\(\".*\"')

    results = pattern.findall(temp)
    for result in results:
        target += result
    return target



s = """<a class="time" target="_blank" href="">昨天 00:26</a>
<a class="time" target="_blank" href="">今天 00:26</a>"""


def getTime(html):
    reg = r'<a class="time".*>(.*)</a>'
    timere = re.compile(reg)
    timelist = re.findall(timere, html)
    for t in timelist:
        print t


getTime(s)