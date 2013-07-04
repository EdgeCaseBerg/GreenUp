GreenUpVT
==========

Vermont National Hack for Change day application
--------------------------------------------------

Problem: Each year the State of Vermont holds Green-up VT events (see website) where volunteers spend part of a spring day cleaning up litter and other found waste, but while the event is highly publicized, the organization of the clean-up tasks themselves are ad-hoc and disorganized. Volunteers are given little or no directions regarding where to clean or where to drop off the collected refuse. Furthermore, there is no coordination between volunteers and the central organization about “high-need” areas. This lack of coordination leads to overlapping zones covered (wasted time), bags of garbage left where they won’t be collected, and an overall feeling of “you’re on your own”, once the volunteers have been given their bags. 

Possible solution: A web-service that allows volunteers to collect and distribute information with each other and with a central team, about high-need locations (lots of garbage to collect), ground already covered, and drop-off locations for collected waste. 

Possible features: 
GPS/mapped tracks of ground covered by collectors
Way to post information about high-need areas (e.g. “There’s tons of garbage on Pine St.”) 
Map of drop-off locations
Way for leadership team to communicate with volunteers about needs
Calendar/Notifications to remind people about Clean-Up VT day/time

Resources

List of solid waste disposal facilities: http://www.anr.state.vt.us/dec/wastediv/solid/documents/cathylistforwebquery9-24-10.pdf
(other pages on that site may also have useful info)


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
[Paul Kiripolsky]: https://github.com/kiripaul

