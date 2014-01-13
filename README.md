GreenUp WebClient  - v0.01
=========
Powered by <a href="http://xenonapps.com">XenonApps</a>

GreenUp Repository for Client and Administration
------------------------------------------------------------------------

A mobile-web client for GreenUp-VT 

 - Tabbed menus
 - Interactive Maps
 - Discussion forum



####Notes<br />
Use of the proxy script:<br />
For development: In order to bypass the browser's origin-based security measures, it is necessary to run a php script locally that proxies
all HTTP requests to the live web-server.<br /><br />
Using the proxy is simple. Instead of making requests to http://199.195.248.180:31337/api,
I make a request to <a href="http://localhost/proxy.php?url=http://199.195.248.180:31337/api">http://localhost/proxy.php?url=http://199.195.248.180:31337/api</a>. Whereas the live server would return <br />
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
 To access the dash the user must log in using OAuth and the Google account, all of which occurs over HTTPS.<br /><br />
 To run provide HTTPS locally, you'll need to configure your Apache, and generate a cert.<br />
 <A href="http://webdevstudios.com/2013/05/24/how-to-set-up-ssl-with-osx-mountain-lions-built-in-apache/">Mac users, see this tutorial</a><br /><br />



License
--

<a href="3http://www.gnu.org/licenses/gpl.html">GPLv</a>
