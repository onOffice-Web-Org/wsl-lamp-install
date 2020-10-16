# WSL Installation & Einrichtung


## Was ist WSL?

Im Grunde ist es der Arbeitsbereich aus einer Linux-Distribution, die zu Windows 10 hinzugefügt wurde, um das Ausführen nativer Linux-Anwendungen zu ermöglichen. Derzeit funktioniert nur die CLI richtig gut, einige haben aber auch GUI-Programme zum Laufen gebracht, dies würde jedoch den Rahmen dieser Anleitung sprengen.


## Konfiguration von Windows

Die hier aufgeführten Anweisungen müssen in ein Ticket an die Admins gestellt werden.

Betreff: WSL2 Installation

Beschreibung:

Bitte um Installation & Aktivierung von WSL auf meinem Rechner.

Vorraussetzung für die Installation von WSL2 ist Windows 10 2004.

Als erstes müssen optionale Features aktiviert werden um WSL1 zu aktivieren:



*   `Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform`
*   `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`


### Installation von WSL2

Anschließend [WSL2 Kernelupdate](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi) (https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi) herunterladen und installieren.

Ab hier kann man selber machen.


### WSL-Version festlegen

Nach dem Neustart steht das Kommandozeilen-Tool wsl.exe zur Verfügung, mit dem man unter anderem zwischen WSL 1 und 2 umschalten kann. Vor der Installation der ersten Distribution empfiehlt es sich, WSL 2 durch den Aufruf von


```
wsl.exe --set-default-version 2
```


zu aktivieren. Es besteht aber auch die Möglichkeit, die WSL-Version für jede Linux-Distribution individuell zu wählen, und zwar nach dem Muster


```
wsl.exe --set-version <Name-der-Distribution> 2
```


Den genauen Namen der Distributionen ermittelt man mit


```
wsl.exe -l -v
```



## Installation einer Distribution

Wir empfehlen für die Entwicklung eine Ubuntu Version zu nutzen. Dazu einfach im Microsoft Store nach Ubuntu 20.04 LTS suchen oder [hier herunterladen](https://www.microsoft.com/de-de/p/ubuntu-2004-lts/9n6svws3rx71?activetab=pivot:overviewtab).

Nach der Installation kannst du über das Startmenu die Distribution öffnen.

Du wirst von einer Bash-Eingabeaufforderung begrüßt, die Dich nach einem Benutzernamen und einem Passwort fragt. Wenn Du damit fertig bist, wirst Du eine Eingabeaufforderung wie diese sehen:

Nun haben wir Ubuntu erfolgreich installiert.


## Pakete hinzufügen

Im nächsten Step fügen wir zwei zusätzliche Paket Repositories hinzu um Webmin per CLI zu installieren sowie mehr flexibilität bei den PHP Version zu haben.


### PHP Repository


```
sudo add-apt-repository ppa:ondrej/php
```



### Webmin Repository


```
sudo nano /etc/apt/sources.list
```


Dieser Aufruf öffnet die Datei sources.list im Editor nano. Im Editor in die letzte Zeile gehen und folgende Zeile hinzufügen:


```
deb http://download.webmin.com/download/repository sarge contrib
```


Anschließend speichern wir die Datei mit Strg+o und schließen diese mit Strg+x.

Hierzu muss noch eine Keyfile heruntergeladen und installiert werden. Dies bewerkstelligt man mit den folgenden Befehlen:


```
wget http://www.webmin.com/jcameron-key.asc
```


Und dann:


```
sudo apt-key add jcameron-key.asc
```


Nun folgt noch ein abschließendes update:


```
sudo apt update
```


Damit sind nun alle benötigten Voreinstellungen abgeschlossen. Installieren wir nun einen LAMP Stack.


### LAMP Stack installieren

Diese Schritt ist auch nicht sonderlich kompliziert. Als erstes installiert man alle benötigten Pakete für den LAMP Stack. Das heißt Apache2 als Webserver, MySQL 8 als Datenbankserver sowie PHP. Zusätzlich noch einige erweiterte PHP Pakete und das Webmin Paket zur Serververwaltung.


```
sudo apt install apache2 mysql-server php7.3 php7.3-xml php7.3-zip php7.3-mbstring php7.3-curl php7.3-mysql php7.3-gd php7.3-imagick curl webmin
```


Dieser Schritt kann eine Weile dauern, da recht viele Pakete geladen und installiert werden müssen. Wenn die Installation abgeschlossen ist, können wir die soeben installierten Services auch starten.


```
sudo service apache2 start && sudo service mysql start && sudo service webmin start
```


Wenn man nun im Browser auf [http://localhost](http://localhost) geht, sollte die Standard Apache2 Seite erscheinen. Webmin ist über [http://localhost:10000](http://localhost:10000) erreichbar. Hier jedoch noch nicht anmelden da zuerst die SSL Verschlüsselung deaktiviert werden muss.

Dazu öffnen wir die miniserv.conf in nano.

sudo nano /etc/webmin/miniserv.conf

und suchen nach der Zeile

ssl=1

diese ändern wir in

ssl=0

Nun speichern wir die Datei (Strg+o) und schließen sie (Strg+x). Und der Webmin Service muss noch neugestartet werden.

sudo service webmin restart


### MySQL konfigurieren

Dieser Abschnitt behandelt die Konfiguration und grobe Absicherung des MySQL Servers.

Erster Schritt ist die generelle Absicherung der Installation, hierfür gibt es bereits ein vorgefertigten Wizard.

sudo mysql_secure_installation

Die Fragen wie folgt beantworten:



*   Would you like to setup VALIDATE PASSWORD components?
    *   No
*   Please set the password for root here.
    *   Wunschpasswort eintragen
*   Remove anonymous users?
    *   Yes
*   Disallow root login remotely?
    *   No
*   Remove test database and access to it?
    *   Yes
*   Reload privileges tables now?
    *   Yes

Nach dieser Konfiguration erstellen wir uns einen eigenen DB User mit den passenden Rechten. Wir öffnen das mysql CLI mit

sudo mysql

und führen folgende Befehle aus:


```
CREATE USER 'WUNSCHUSERNAME'@'localhost' IDENTIFIED WITH mysql_native_password BY 'WUNSCHPASSWORT';
GRANT ALL PRIVILEGES ON *.* TO 'WUNSCHUSERNAME'@'localhost';
```



### Module installieren


```
sudo a2enmod rewrite
```



## Projektordner verknüpfen


```
sudo ln -s /mnt/c/projekte/projektroot /var/www/html