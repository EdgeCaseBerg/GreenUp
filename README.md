GreenUp WebClient  - v0.01
=========
Powered by <a href="http://xenonapps.com">XenonApps</a>

GreenUp Repository for Client and Administration
------------------------------------------------------------------------

A mobile-web client for GreenUp-VT 

 - Tabbed menus
 - Interactive Maps
 - Discussion forum



####Notes####<br />
Use of the proxy script:<br />
For development: In order to bypass the browser's origin-based security measures, it is necessary to run a php script locally that proxies<br />
all HTTP requests to the live web-server.<br />
Using the proxy is simple. Instead of making requests to http://199.195.248.180:31337/api,
I make a request to http://localhost/proxy.php?url=http://199.195.248.180:31337/api. Whereas the live server would return <br />
`{ "heartbeat": 1389547522 }`<br />
the proxied response looks like: <br />
`{ "status": {
         "http_code": 200
     },
     "contents": {
         "heartbeat": 1389547522
     }
 }`<br />
 So there will be a line in the ApiConnectors that identifies the origin and switches the proxy script in and out accordingly.<br /><br />

 Problems with SSL and Google OAuth:<br />
 The Admin dashboard uses Google Analytics data to feed some of the usage graphs and to log in to the dashboard in general.
 To access the dash the user must log in using OAuth and the Google account, all of which occurs over HTTPS. Unless you have a Cert and want
 to futz with that, you'll need to use an ssl tunnel to access the http content over https. I'm using Stunnel which, on a Mac, is avaiable
 as a tar archive or through MacPorts.



License
--

<a href="3http://www.gnu.org/licenses/gpl.html">GPLv</a>
