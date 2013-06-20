GreenUp
=============



Setup
------------------
- Run a LAMP or WAMP server with mysql 5.5 and PHP 5.3
- set the document root to the root directory of the web folder
- Create a config.php file in the server directory with the proper user and password credentials for mysql
```php
define("HOST","localhost");
define("DB_NAME","GreenUp");
define("DB_USER","");
define("DB_PASS","");
```
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

Grid.php
--------
The Grid class is an interface to the grid table in the database. It's primary function is to respond to requests for grid locations and to increment the time spent within a specific grid location.

###To Do
- The Grid class currently retrieves all grid points from the database no matter the request. This query needs to be fine grained to return the grid locations only within a specific region of the map. 
- The incrementTime procedure doesn't work with certain versions of mySQL right now, it would be nice if we could have a version that worked accross all versions, or at least those within the 5.x subset.

addGridData.php
--------
The addGridData script responds to POST requests in order to store the points worked on sent by the client applications. 

###To Do
- This script needs to be documented better. 
- Checks for the format of the incoming POST request might be a wise thing to do, as it current makes the assumption that the POSTed data is well formed. 
- Error checking, again, this has to do with insuring that the format of the incoming POST request matches what we're expecting. While we can expect the client code that we create ourselves to return syntactically correct data, we should be able to respond to POST data from any source (such as a rest client application such as POSTMAN during testing)
 
communication.php
--------
The communication script responds to things having to do with the forums. It responds to user's placing pins down onto the map with a message, as well as submissions from the form on the comments page. Currently the script detects the presense of specific form fields in order to determine where the incoming information comes from. 

###To Do
- The script is currently very tightly coupled to the database schema as well as the names of certain files. It would be nice to abstract part of this away in order to make the script more readable as well as move the database interaction into a single place.
- More comments and documentation on how and why it does what it does

config.php
---------
The config.php file does not exist until you make it. It is an ignored file within the repository as to make sure that no sensitive information about any developers database information is leaked. Therefore it is highly discouraged from manually adding your config file to the repository. The config file defines the constants, HOST, DB_NAME, DB_USER,	and DB_PASS. See the setup section for the default values. Changing the name of the of the database name is discouraged as some pieces of the code currently reference it by name.

createDatabase.php
---------
This file, when ran, will create the database for the application. It depends on config.php and simply echos the result of each query it executes. Upon success you should see a series of 1's and 0's.

###To Do
- Create an sql file that can be imported into a database instead of having to run this script.
- DeCouple the values of the 3 types from their current order. (Currently, the values 1 2 and 3 are dispersed throughout the code to represent these inserted types. While this is not a problem, should someone insert the values into the database at first in the wrong order, or change them from their default values the application might break. In fact, the comments form in particular and communication.php would suffer)
- Document what sequence of 0's and 1's mark a successful execution of the database.

getHeatmapPoints.php
----------
The getHeatmapPoints script functions as an endpoint to requests for the Grid class's getHeatmapPoints function. 

###To Do
- This file, if possible, could be made aware of the users location and map zoom level in order to more efficiently serve the points to the user. As mentioned in the summary of the Grid.php file, the current function retrieves all datapoints from the database and therefore is remarkbly unefficient should this go into production.
- A bit of documentation on this file could be nice.

testAddGridDataForm.php
----------
This is a simple html form which post's to the addGridData.php script in order to test the functionality of it. This script could be deleted and replaced with the use of a [simple rest client](https://chrome.google.com/webstore/detail/postman-rest-client/fdmmgilgnpjigdojojpjoooidkmcomcm?hl=en)
