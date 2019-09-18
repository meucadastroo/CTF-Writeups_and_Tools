import re
import sys
import time
import argparse
import requests
import threading
import pandas as pd
from termcolor import colored
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

NumberThreads = 0
t0=time.time()

def TimeToResp(df,ip,filename,timeout_=3):
	# print(chr(27) + "[2J")
	global NumberThreads
	protocols = ['http','https']
	ports     = [80,8080,9090,3128]
	rHTTP 	  = []
	rHTTPs 	  = []
	for protocol in protocols:
		for port in ports:
			resp = '*'
			url = '%s://%s:%s/'%(protocol,ip,port)
			sys.stdout.write('\r%s Testing URL: %s 	  '%(colored('[>]', 'yellow'), colored(url, 'green')))
			try:
				# r = requests.get('http://checkip.dyn.com/', timeout=3, verify=False, proxies={protocol : url})
				proxy = {protocol: 'http://%s:%s' %(ip, port)}
				url_check = 'http://checkip.dyn.com/'
				validate  = 'Current IP Address:'
				if protocol == 'https':
					url_check = 'https://www.checkip.org/'
					validate  = 'Your IP Address:'

				r = requests.get(url_check, headers = { 'User-Agent': 'Mozilla/5.0' }, timeout=timeout_, verify=False, proxies=proxy)
				if validate in r.content:
					resp = (r.elapsed.total_seconds())
					df.loc[-1] = [protocol,ip,port,resp,url]  # adding a row
			 		df.index = df.index + 1   			   	  # shifting index
			 		df = df.sort_index()   			 	  	  # sorting by index
			except Exception as e:
				# print('Error ->\n',e)
				pass

	
	NumberThreads -= 1
	try:
		if NumberThreads <= 0:
			global t0
			d=time.time()-t0; 
		 	df = df.sort_values(by ='Response' )
			sys.stdout.write('\r%s %s Proxys Found in %.2f s. : 								\n\n%s\n'%(colored('[+]', 'green'),colored(len(df.index), 'green'), d, df.to_string(index=False)))
			if filename != None :
				df.to_csv('%s.csv'%filename, sep=';', decimal=',', index=False)
	except Exception as e:
			print('Error ->',e)
			pass



if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('-t', action='store', dest='timeout', required=False, help='Maximum request time wait. Default value = 3. ( E.g: 5 ) ')
	parser.add_argument('-o', action='store', dest='filename', required=False, help='Pass the output filename. Default ext = .csv ( E.g: proxys )')
	argumentos = parser.parse_args()

	df = pd.DataFrame(columns=['Protocol','IP','Port','Response','URL'])
	regex = r'([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)'
	ProxySites = ['http://spys.one/free-proxy-list/BR/0','http://spys.one/free-proxy-list/BR/1','http://spys.one/','http://spys.one/en/']
	r = ''
	for url in ProxySites:
		r += requests.get(url).content

	ips = re.findall(regex, r)
	ips = list(dict.fromkeys(ips))
	if argumentos.timeout:
		timeout_ = int(argumentos.timeout)
	else:
		timeout_ = 3

	print('%s Timeout  		  : %s     '%(colored('[>]', 'yellow'), colored(timeout_, 'green')))
	print('%s Save in file 	  : %s     '%(colored('[>]', 'yellow'), colored(argumentos.filename, 'green')))
	print('%s Number of IPs to test : %s     '%(colored('[>]','yellow'), colored(len(ips), 'green')))
	for ip in ips:
		threading.Thread(target=TimeToResp,args=(df,ip,argumentos.filename,timeout_)).start()
		NumberThreads += 1
