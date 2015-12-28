#coding = utf-8

import urllib, urllib2
import re, json
import math, time, random
import types

def gen_url():
    all_url = {}
    all_url[1] = 'http://www.marinetraffic.com/map/getDataJson/sw_x:-181.0/sw_y:-58.7/ne_x:181.0/ne_y:72.8/zoom:2/station:0'
#    x = - 180
#    while x < 180:
#        sw_x = x
#        ne_x = x + 15
#        x = x + 15
#        y = -90
#        while y < 90:
#            sw_y = y
#            ne_y = y + 6
#            y = y + 6
#            url = 'http://www.marinetraffic.com/map/getDataJson/sw_x:' + \
#                  str(sw_x) + '/sw_y:' + str(sw_y) + '/ne_x:' + str(ne_x) + \
#                  '/ne_y:' + str(ne_y) + '/zoom:5/station:0'
#            name = str(sw_x) + str(sw_y)
#            print x, y
#            all_url[name] = url
    return all_url

def get_json_data(url, header):
    req = urllib2.Request(url)
    if header: 
        for k in header.keys():
            req.add_header(k, header[k])
    response = urllib2.urlopen(req)
    distri = response.read()
    return distri

def request_data(header):
    url = gen_url()
    for (k, v) in url.items():
        print k, v
        distri_json = get_json_data(v, header).encode('utf-8')
        print distri_json
        distri_data = json.loads(distri_json)
        
if __name__ == '__main__':
    header={
        #'Host': 'www.marinetraffic.com',
        #'Connection': 'keep-alive',
        #'Content-Type':'application/json',
        #'Accept': 'text/plain, */*; q=0.01',
        #'X-Requested-With': 'XMLHttpRequest',
        'User-Agent':' Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36',
        'Referer': 'http://www.marinetraffic.com/',
        #'Accept-Encoding': 'gzip, deflate, sdch',
        #'Accept-Language': 'zh-CN,zh;q=0.8',
        'Cookie':'__gads=ID=1ad61de675f29062:T=1418374516:S=ALNI_MaXPEmw9ktu2aSm9wu7XNEbIXVPtA; mt_user[App][lang]=cn; _ga=GA1.2.570878214.1418374650; SERVERID=www5; CAKEPHP=ihlsd901ht8e5rkq1bntoahqt1'
        }
    data = request_data(header)
    print "Done"
