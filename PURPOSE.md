GreenUpVT
==========

Vermont National Hack for Change day application
--------------------------------------------------


#### Why are we making this?
Each year the State of Vermont holds Green-up VT events [(see website)] where volunteers spend part of a spring day cleaning up litter and other found waste, but while the event is highly publicized, the organization of the clean-up tasks themselves are ad-hoc and disorganized. Volunteers are given little or no directions regarding where to clean or where to drop off the collected refuse. Furthermore, there is no coordination between volunteers and the central organization about “high-need” areas. This lack of coordination leads to overlapping zones covered (wasted time), bags of garbage left where they won’t be collected, and an overall feeling of “you’re on your own”, once the volunteers have been given their bags. 

This project was started by a team of 7 developers during the [National Day of Civic Hacking] held on 6/22 by [Code For Btv]. It has continued since then, and was [featured] on the news the night after the event was over. 

#### Our solution: 
An application that allows volunteers to collect and distribute information with each other and with a central team, about high-need locations (lots of garbage to collect), ground already covered, and drop-off locations for collected waste. The application is available currently as a mobile website, however we are in development of both Android and iOS native applications.

Features: 
---------
- GPS/mapped tracks of ground covered by collectors
- Way to post information about high-need areas (e.g. “There’s tons of garbage on Pine St.”) 

Possible Enhancments:
---------
- Map of drop-off locations
- Way for leadership team to communicate with volunteers about needs
- Calendar/Notifications to remind people about Clean-Up VT day/time

Setup
------------------
- `$$ git clone https://github.com/EJEHardenberg/GreenUp.git` (or fork the repository then download it)
- Install the google app engine for your system. [Linux] or [Windows or Mac]
- Run the dev_appserver.py script against GreenUp/ or use the GUI interface to make a new project against that folder
- Navigate to your localhost:XXXXX (where XXXXX is the port specified by the app server console)
- All should be working well. If you have trouble, ask for our help with the issue tracker on github and we'll get back to you ASAP

#### If you just want to run the API:
- Run the dev_appserver.py script against GreenUp/api/

Contributing
--------------------
If you are going to contribute to the project (please do!) there is a general flow for how we do things in this project.

- All development work is done on the develop branch or a branch based off from it. The master branch is left for releases
- We use git flow. So you'll see a lot of feature/branches or commits merged in with the --no-ff flag if they weren't started through flow.
- Releases are done when breaking changes to the API occur or when there's a major update for clients. 
- Send a pull request with your changes and it will be reviewed and merged if it passes inspection. In general, if you want a quick response then target your pull requests by tagging one of the developers listed below. In General:
	- API pull requests you should tag [Ethan Eldridge]
	- Web Application requests you should tag [Joshua Dickerson]
	- iOS requests you should tag [Anders Melen]
	- android requests you should tag [Evan Yandell] and [Ethan Eldridge]
- If you have trouble with the public API or see an issue report the issue and let us know. 


Developers (Current):
------------------
- [Ethan Eldridge]
- [Joshua Dickerson]
- [Scott MacEwan]
- [Anders Melen]
- [Evan Yandell]
- [Phelan Vendeville]

Designers:
------------------
- [Doug Blackmore]


Contributors (git log --format='%aN' | sort -u)
--------------------
- Anders Melen
- Collin
- Collin DeWitt
- Danielle Steimke
- EC2
- EJEHardenberg
- Ethan Joachim Eldridge
- JoshuaDickerson
- Joshua.Dickerson
- justcadams
- Phelan Vendeville
- popwarfour
- primehunter326
- root
- Scott MacEwan
- the-hobbes
- Ubuntu


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
[(see website)]: http://www.greenupvermont.org/
[Doug Blackmore]: http://dblackmoredesign.com/
[Code For Btv]: http://codeforbtv.org/
[featured]: http://www.wptz.com/news/vermont-new-york/burlington/Coders-designers-hack-for-change/-/8869880/20394732/-/13wdolaz/-/index.html
[National Day of Civic Hacking]: http://hackforchange.org/
[Linux]: http://askubuntu.com/questions/123553/how-to-install-google-appengine/126687#126687
[Windows or Mac]: https://developers.google.com/appengine/docs/python/gettingstartedpython27/devenvironment
[Paul Kiripolsky]: https://github.com/kiripaul
[Anders Melen]: https://github.com/popwarfour
