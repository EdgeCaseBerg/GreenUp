GreenUp
=============

Setup
------------------
- Run a LAMP or WAMP server with mysql 5.5 and PHP 5.3
- set the document root to the root directory of the web folder
- Create a config.php file in the server directory with the proper user and password credentials for mysql
 
 ><?php
 >
 >//Rename this file to config.php
 >
 > define("HOST","localhost");
 >
 > define("DB_NAME","GreenUp");
 >
 > define("DB_USER","");
 >
 > define("DB_PASS","");
 
 >
 >?>
- run the server/createDatabase.php script to create the database
- Use the application

Developers:
------------------
- [Ethan Eldridge]
- [Joshua Dickerson]
- [Collin Dewitt]
- [Scott MacEwan]
- [Justin Adams]
- [Danielle Steimke]
- [Paul Kiripolsky]
- [Evan Yandell]
- [Phelan Vendeville]

Designers:
------------------
- 

License:
----------
[GNU Public License]

[GNU Public License]: http://www.gnu.org/licenses/gpl.html
[Ethan Eldridge]: https://github.com/EJEHardenberg/
[Evan Yandell]: https://github.com/primehunter326
[Collin Dewitt]: https://github.com/milus16
[Joshua Dickerson]:https://github.com/JoshuaDickerson
[Scott MacEwan]: https://github.com/smacewan101
[Danielle Steimke]: https://github.com/iknitformydog
[Justin Adams]:https://github.com/justcadams
[Phelan Vendeville]: https://github.com/the-hobbes

Server Readme
-------------------------
The server folder contains the following files
- Grid.php
- addGridData.php
- communication.php
- config.php (Not Tracked by github, you'll have to add this yourself, see setup instructions)
- createDatabase.php
- getHeatmapPoints.php
- testAddGridDataForm.php

