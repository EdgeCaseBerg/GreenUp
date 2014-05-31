GreenUp WebClient  - v0.01
=========
Powered by <a href="http://xenonapps.com">XenonApps</a>

GreenUp Repository for Client and Administration
------------------------------------------------------------------------

A mobile-web client for GreenUp-VT 

 - Tabbed menus
 - Interactive Maps
 - Discussion forum



###Dev Notes

#####Use of the proxy script:<br />
For development: In order to bypass the browser's origin-based security measures, it is necessary to run a php script locally that proxies
all HTTP requests to the live web-server.<br /><br />
Using the proxy is simple.<br />Instead of making requests to http://199.195.248.180:31337/api,
I make a request to <a href="http://localhost/proxy.php?url=http://199.195.248.180:31337/api">http://localhost/proxy.php?url=http://199.195.248.180:31337/api</a>. <br /><br />
Whereas the live server would return: `{ "heartbeat": 1389547522 }`<br />
the proxied response looks like: `{ "status":  "http_code": 200 }, "contents": { "heartbeat": 138954752 } }`<br /><br />
Note:  There will be a line in the ApiConnectors that identifies the origin and switches the proxy script in and out accordingly.<br /><br />
 
####Problems with SSL and Google OAuth:

 The Admin dashboard uses Google Analytics data to feed some of the usage graphs, so when a user enters the admin dash he is prompted to login
 with google credentials. The dash uses these credentials to authenticate into google analytics, all over HTTPS. If you log in as you... you won't see analytics data,
 as the site will be looking for an anlytics profile for <b>YOUR</b> account.
 I am working on fixing this, but until I do, you have to log in as <b>xenonapplab@gmai.com</b><br /><br />
 Furthermore, you have to connect to your localhost using <b>https://127.0.0.1</b> meaning you'll have to configure Apache to listen for ssl traffic,
 and generate a certificate.<br />
 <A href="http://webdevstudios.com/2013/05/24/how-to-set-up-ssl-with-osx-mountain-lions-built-in-apache/">Mac users, see this tutorial</a><br /><br />



License
--

<a href="3http://www.gnu.org/licenses/gpl.html">GPLv</a>
