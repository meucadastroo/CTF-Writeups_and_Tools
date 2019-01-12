<strong>Olah caros leitores !!</strong>

<p>Hoje estou aqui para falar um pouco sobre <strong>DLLs</strong>. Mais exatamente sobre alguns Desafios de <strong>CTF</strong> que envolvem  <strong>reverse</strong> em DLLs.</p>

<p>Tomando como Exemplo de DLL irei usar uma <a href=”https://github.com/sql3t0/shellterlabsCTF/blob/master/tools/LoadDLL/CTF-Esecurity_LaricasCriptografia.dll?raw=true”>DLL</a> de um desafio que ocorreu no CTF da <a href=”https://ctf.esecurity.com.br”>Esecurity</a> de 2018.</p> 

<img src="https://github.com/sql3t0/shellterlabsCTF/blob/master/tools/WriteupsSiteDeadlokTeam/LoadDLLsPowerShell/imgs/img_00.png?raw=true" />
 
<p>Usando o comando <strong>file</strong> na DLL para descobrir a qual arquitetura ela pertence,descobrimos que ela eh x86.</p>
--------------------------------------------------------------------------------------------------------------------------------------
<p>
<div>
C:\Users\Sql3t0\Desktop> file CTF-Esecurity_LaricasCriptografia.dll<br/>
CTF-Esecurity_LaricasCriptografia.dll: PE32 executable (DLL) (console) Intel 80386 Mono/.Net assembly, for MS Windows
</div>
</p>
--------------------------------------------------------------------------------------------------------------------------------------	
<p>Apartir dessa descoberta, agora podemos selecionar a versão correta do <a href=”https://en.wikipedia.org/wiki/Decompiler”>Decompiler</a>,que nesse caso eh o <a href=”https://github.com/0xd4d/dnSpy”>dnSpy x86</a>,que eh um decompiler opensource e que estah disponível para download no <strong>Github</strong>.</p>

<img src="https://github.com/sql3t0/shellterlabsCTF/blob/master/tools/WriteupsSiteDeadlokTeam/LoadDLLsPowerShell/imgs/img_01.png?raw=true" />
 
<p>Como eh possível perceber,utilizando o dnSpy conseguimos encontrar duas <strong>Classes</strong> dentro do NameSpace <strong>Laricas</strong>:</p>
<h3>Database</h3>
<p>Olhando a <strong>Classe</strong> <strong>Database</strong> eh facil perceber que ha duas variáveis(<strong>DB_USER</strong>,<strong>DB_PASS</strong>) bem sugestivas e que parecem estar <strong>Encriptadas</strong>.</p>
 
<img src="https://github.com/sql3t0/shellterlabsCTF/blob/master/tools/WriteupsSiteDeadlokTeam/LoadDLLsPowerShell/imgs/img_02.png?raw=true" />

<h3>Encryption</h3>
<p>Olhando agora a <strong>Classe</strong> <strong>Encryption</strong> podemos notar que existe um <strong>método</strong> chamado <strong>crypt</strong>.</p>

<img src="https://github.com/sql3t0/shellterlabsCTF/blob/master/tools/WriteupsSiteDeadlokTeam/LoadDLLsPowerShell/imgs/img_03.png?raw=true" />
 
<p>Indo mais a fundo no método <strong>crypt</strong> eh possível deduzir que ele nada mais eh que <strong>uma variação do algoritimo de <a href=”https://en.wikipedia.org/wiki/XOR_cipher”>XOR</a></strong>.</p>

```
byte[] array = new byte[input.Length];
            for (int i = 0; i < input.Length; i++)
            {
                array[i] = (byte)((int)input[i] ^ this._secret[i % this._secret.Length]);
            }
return array;
```

<p>Apartir desse ponto pressupõe-se que os valores das variaves <strong>DB_USER</strong> e <strong>DB_PASS</strong> foram criptografados usando o método <strong>crypt</strong>.</p>

<p>Sabendo-se que a reversão para criptografia de XOR eh simplismente XOR,então podemos usar o mesmo método que foi utilizado na cifragem para tentar realizar a decifragem.<br/>
E eh nessa parte onde entra uma dica que pode lhe fazer economizar muito tempo em futuros CTFs que venham a utilizar DLLs.</p>

<p>Esse dica nada mais eh que usar o <strong>powershell</strong> do Windows para <strong>carregar</strong> a DLL na <strong>memoria</strong> e utilizar ela.Tudo isso apartir da linha de comando.</p>

<h3>Como fazer isso<strong> ?</strong></h3>
<p>Usando a classe <strong><a href=”https://docs.microsoft.com/pt-br/dotnet/api/system.reflection.assembly?view=netframework-4.7.2”>System.Reflection.Assembly</a></strong> eh possivel carregar o conteudo da DLL, criar objetos das classes e ainda utilizar os seus metodos contidos em cada classe.</p>
```
PS C:\Users\Sql3t0\Desktop> $DLLbytes = [System.IO.File]::ReadAllBytes("C:\Users\Sql3t0\Desktop\CTF-Esecurity_LaricasCriptografia.dll")
<br/>
PS C:\Users\Sql3t0\Desktop> [System.Reflection.Assembly]::Load($DLLBytes)

GAC    Version        Location
---    -------        --------
False  v4.0.30319


PS C:\Users\Sql3t0\Desktop>
```
<p>Caso queira <strong>Listar</strong> todos o métodos contidos na DLL recém carregada basta executar o comando :</p>
--------------------------------------------------------------------------------------------------------------------------------------
<p>
<div>
PS C:\Users\Sql3t0\Desktop> [Laricas.Encryption].GetMethods()
</div>
</p>
--------------------------------------------------------------------------------------------------------------------------------------
<p>Para criar um <strong>Objeto</strong> de uma Classe basta executar o comando :</p>
--------------------------------------------------------------------------------------------------------------------------------------
<p>
<div>
PS C:\Users\Sql3t0\Desktop>$objeto = New-Object "Laricas.Encryption"
</div>
</p>
--------------------------------------------------------------------------------------------------------------------------------------
<p>Onde<strong>Laricas</strong> eh o <strong>Namespace</strong> e <strong>Encryption</strong> o nome da <strong>Classe</strong>.</p>

<p>Olhando para os valores cifrados podemos deduzir que eles estao em Base64 e teremos que decodificar eles antes de passarmos como parâmetro no método <strong>crypt</strong>.</p>
--------------------------------------------------------------------------------------------------------------------------------------
<p>
<div>
public class Database<br/>
{
    // Token: 0x04000001 RID: 1<br/>
    public string DB_USER = "exFzCnkMXhFxCmoMRBFWCkkM";<br/>

    // Token: 0x04000002 RID: 2<br/>
    public string DB_PASS = "UhFBCm4MVBFpCnwMUhFzCmAMaBFxCnkMThFiCn8MWBEvCnsMQBF8CjgMUxFvCg==";<br/>
}
</div>
</p>
--------------------------------------------------------------------------------------------------------------------------------------	
<p>Para isso usaremos o comando :</p>
--------------------------------------------------------------------------------------------------------------------------------------
<p>
<div>
PS C:\Users\Sql3t0\Desktop> $string = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("UhFBCm4MVBFpCnwMUhFzCmAMaBFxCnkMThFiCn8MWBEvCnsMQBF8CjgMUxFvCg==")
</div>
</p>
--------------------------------------------------------------------------------------------------------------------------------------
<p>Sequencialmente codificaremos a <strong>$string</strong> para <strong>UTF-8</strong> :</p>
--------------------------------------------------------------------------------------------------------------------------------------
<p>
<div>
PS C:\Users\Sql3t0\Desktop> $enc = [system.Text.Encoding]::UTF8<br/>
PS C:\Users\Sql3t0\Desktop> $data = $enc.GetBytes($string)
</div>
</p>
--------------------------------------------------------------------------------------------------------------------------------------
<p>E entao chamamos o método <strong>crypt</strong> para decodificar,salvando o resultado em uma outra variável na qual codificaremos o resultado em <strong>ASCII</strong> para ser finalmente impresso na tela:</p>
--------------------------------------------------------------------------------------------------------------------------------------
<p>
<div>
PS C:\Users\Sql3t0\Desktop> $array = $objeto.crypt($data)<br/>
PS C:\Users\Sql3t0\Desktop> $enc = [System.Text.Encoding]::ASCII<br/>
PS C:\Users\Sql3t0\Desktop> $enc.GetString($array)<br/>
e S e c { w e a k _ c r y p t o = p w n 3 d }<br/>
PS C:\Users\Sql3t0\Desktop>
</div>
</p>
--------------------------------------------------------------------------------------------------------------------------------------
<img src="https://github.com/sql3t0/shellterlabsCTF/blob/master/tools/WriteupsSiteDeadlokTeam/LoadDLLsPowerShell/imgs/img_04.png?raw=true" />

<p>E eh isso aew pessoal !!</p>

<p>Espero que todos tenham gostado do conteúdo aqui repassado.E para todos aqueles que chegaram ateh aqui eu deixo o meu sincero <strong>Muito Obrigado</strong> e ateh a proxima.</p>

<p>\m/...<strong>Hack_Never_Ends</strong>...\m/</p>

<p>Codigo final :</p>
--------------------------------------------------------------------------------------------------------------------------------------
<p>
<div>
if($args.count -eq 2){<br/>
	$DLLName = $args[0]<br/>
	$DLLbytes = [System.IO.File]::ReadAllBytes($DLLName)<br/>
	[System.Reflection.Assembly]::Load($DLLBytes)<br/>
	#lista todos os metodos na DLL<br/>
	#[Laricas.Encryption].GetMethods()<br/>
	$objeto = New-Object "Laricas.Encryption"<br/>
	$string = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($args[1]))<br/>
	$enc = [system.Text.Encoding]::UTF8<br/>
	$data = $enc.GetBytes($string)<br/>
	$array = $objeto.crypt($data)<br/>
	$enc = [System.Text.Encoding]::ASCII<br/>
	$enc.GetString($array)<br/>
}else{<br/>
	echo "Usage : script.ps1 DLLNameStringToDecode"<br/>
}<br/>	
</div>
</p>
--------------------------------------------------------------------------------------------------------------------------------------
