import socket

'''
[+] Estante 1/50:  [1, 2, 3, 4, 5, 6] = 21  / 6 = 3.5
				   [3, 2, 1, 0,-1,-2] = 3 
				   [4, 4, 4, 4, 4, 4] = 24 

 A resposta : 9
[+] Acerto, miseravi!

[+] Estante 2/50:  [1, 3, 3, 5, 3, 1] = 16
				   [3, 1, 1,-1, 1, 3] = 8
				   [4, 4, 4, 4, 4, 4] 

 A resposta : 6
[+] Acerto, miseravi!
'''

def SendResp(s,resp):
	r = s.recv(2048)
	r = r[r.find(':')+2:r.find('A resp')-6]
	r = eval(r)
	print r,'Resp:',resp
	s.send(str(resp))
	print '[<] %s' % s.recv(2048)

z = 0;
lista = [9]
while True:
	s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
	s.connect(('142.93.73.149',11349))
	s.recv(2048)
	s.send('start')
	s.recv(2048)
	for l in lista:
		SendResp(s,l)
	x = z
	while True:
		try:
			r = s.recv(2048)
			r = r[r.find(':')+2:r.find('A resp')-6]
			r = eval(r)
			print r,'Resp:',x
			s.send(str(x))
			test = s.recv(2048)
			if 'Acert' in test:
				lista.append(x)
				print lista

			if z == 10:
				z = 0
		except Exception as e:
			z += 1
			break
			#print 'Erro:',e
