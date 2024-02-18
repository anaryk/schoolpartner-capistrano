Účel
----
Jde o samostanou konfiguraci pro automatizovaný deployment pomocí Capistrano 3.

Princip je ten, že se mu zadá pokyn k deploy a on se připojí přes SSH na server, kam z BitBucket stáhne repozitář, provede zadané úkoly (migrace, čištění cache apod.) a pak přesune ukazatel aktuální verze na tu právě staženou.

Díky tomu se na serveru může evidovat několik verzí aplikace vedle sebe (tzn. snadný rollback) a k přepnutí mezi verzemi nedojde, pokud něco po cestě selže.

Předpoklady
----------
Deployment se musí spouštět na serveru/stroji, kde je nainstalované Capistrano. To potřebuje Ruby >= 2. Víc třeba není, kód si stáhne samo z BitBucket repozitáře.

Nastavení klíče
---------------
Každý vývojář bude používat vlastní klíč(e) k přístupu k serveru jako deploy user. Veřejný klíč se nahraje na server (to udělá Dalibor) a tvůj privátní se jen musí odkázat v nastavení.

Klíč ve vagrant boxu si lehce vygeneruješ `ssh-keygen -t rsa -C 'dasim@deployer'` (místo dasim použij svůj rozeznatelná username). Pokud nepoužíváš vagrant, můžeš použít svůj vlastní klíč, co už máš u sebe.

Cesta ke klíči se nastavuje v lokálním nastavení pro deployer, to je v souboru `config/local.rb.example`, který se přejmenuje na `config/local.rb` (který se neverzuje).

Použití
-------
`cap production deploy`