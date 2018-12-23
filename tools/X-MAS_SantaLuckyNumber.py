import sys
import requests

url = 'http://95.179.163.167:12005/?page='
for n in range(int(sys.argv[1]),int(sys.argv[2])):
	r = requests.get(url+str(n))
	if 'X-MAS' in r.text:
		print r.text
		break
	value = r.text[841:].replace('</p>','').strip()
	sys.stdout.write('\r[%d] %s'%(n,value))
	try:
		decoded = value.decode('HEX')	
		if 'X_MAS' in decoded:
			print decoded
			break
	except Exception as e:
		print e
		pass
