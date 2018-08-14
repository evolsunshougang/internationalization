import os
import urllib

import mysqldbhelper

db = mysqldbhelper.DatabaseConnection('115.28.24.29',
									  user='lishougang',
									  passwd='lishougang',
									  db='car')

def save_img(img_url, file_name, file_path='book\img'):
	result = db.get_all('''SELECT  * from brand where brandId=9''')
	print  result
	try:
		if not os.path.exists(file_path):
			os.mkdir(file_path)
			os.makedirs(file_path)
		file_suffix = os.path.splitext(img_url)[1]
		filename = '{}{}{}{}'.format(file_path, os.sep, file_name, file_suffix)
		urllib.urlretrieve(img_url, filename=filename)
	except IOError as e:
		print e
	except Exception as e:
		print e


if __name__ == '__main__':
	file_path = '/Users/beifeitu/Downloads' + os.sep + 'myimg'
	img_url = 'http://image.jingzhengu.com/Vehicle/2017/11/02/437eecb9-b5cf-4889-a577-7d18137aa167_904.jpg'
	save_img(img_url, 'jianshu', file_path=file_path)
