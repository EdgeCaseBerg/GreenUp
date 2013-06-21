GreenUp API Documenation
=========================

Powered By [Xenon App's]

[Xenon App's]:[http://www.XenonApps.com]

License:
----------
[GNU Public License]

[GNU Public License]: http://www.gnu.org/licenses/gpl.html

API Requests:
-------------------

`http://greenup.xenonapps.com/api/comments?type=forum`

Request URLs are composed from the protocol, host, context path, a resource path, and optional query parameters.

In this example, 
 - the protocol is `http://` 
 - the host is `greenup.xenonapps.com` 
 - the context path is `/api` 
 - the resource path is `/comments` 
 - and optional query parameters of `type=forum`. 
  
All API parameters are returned in the JSON format, and all data sent to the API must be in JSON as well. Query parameters follow a single `?` after the resource path, and are seperated by `&`.

--------------------

###Get API Information

Method: **GET**
URL: **/api**

####Example request:
`http://greenup.xenonapps.com/api` 

####Response:
```no-highlight
{
    "version" : 1.00,
    "Credit" : "Powered by Xenon Apps",
}
```

-----------------------------

###Get Comments
Method: **GET**
URL: **/api/comments**

####Optional Parameters:

<table>
<thead>
<tr><th>name</th><th>type</th><th>description  </th></tr>
</thead>
<tbody>
<tr><td>type</td><td>String </td><td> Can be either `forum`, `needs`, or `message` </td></tr>
</tbody>

</table> 

No type specified will return all comments.

####Example request
`http://greenup.xenonapps.com/api/comments?type=needs`

####Response:
```no-highlight
 [
  { 
  "type" : "needs", 
  "message" : "I need help with the trash on Colchester ave",
  "timestamp" : "2013-05-07 17:12:01",
  "pin" : 3,
  "id" : 4156
  },
  {
  "type" : "needs",
  "message" : "There's a lot of trash on Pearl St, I could use some help!"
  "timestamp" : "1970-01-01 00:00:01",
  "pin" : None,
  "id" : 1134
  }
 ]
```
The pin field refers to a pin resource. (To-Do this should be elaborated on)

-------------------------------------------------

###Submit Comments
Method: **POST**
URL: **/api/comments**

####Required POST Data:
<table>
    <thead>
        <tr><th>name</th><th>type</th><th>description</th></tr>
    </thead>
    <tbody>
        <tr>
            <td> type </td><td>String </td><td> Can be either `forum`, `needs`, or `message` </td>
        </tr>
        <tr>
            <td> message   </td><td> String </td><td> The message to associated with this comment </td>
        </tr>
    </tbody>
</table>

####Optional POST Data:
<table>
    <thead>
        <tr><th>name</th><th>type</th><th>description</th></tr>
    </thead>
    <tbody>
         <tr>
            <td> pin (optional) </td><td> Integer </td><td> The id of a pin to be associated with this comment </td>
        </tr>
    </tbody>
</table>

If the post data is malformed, the server will return a `400 bad request` response, on success a `200` will be returned

####Example Request
`http://greenup.xenonapps.com/api/comments`

####Example Request Body
```
{
    "type" : "forum",
    "message" : "Have you guys heard about the free cookies on Pearl St and South Winooski? Bring your green bags down there and get one!"
}
```

####Response:
```
{ 
 "status" : 200, 
 "message : "Succesfully submited new comment",
}
```

---------------------------------


###Get Heatmap Data
Method: **GET**
URL: **/api/heatmap**

####Optional Parameters
<table>
    <thead>
        <tr><th>name</th><th>type</th><th>description</th></tr>
    </thead>
    <tbody>
        <tr><td>latDegrees</td><td>float</td><td>The latitude boundary of the grid of points to retrieve</td></tr>
        <tr><td>latOffset</td><td>unsigned float</td><td>Offset to **add** to the latitude point to create a bounding rectangle on the points retrieved. __Required if latDegrees is used__</td></tr>
        <tr><td>lonDegrees</td><td>float</td><td>The longitude boundary of the grid of points to retrieve</td></tr>
        <tr><td>lonOffset</td><td>unsigned float</td>Offset to **add** to the longitude point to create a bounding rectanlge on the points retrieved. __Required if lonDegrees is used__</tr>
        <tr><td>precision</td><td>unsigned integer</td><td>The integer precision for rounding degrees. It is recommended to leave this blank unless you know what you're doing.</td></tr>
    </tbody>
</table>

If none of these parameters are specified, all points will be returned. Note that this may be slow depending on the total number of points stored in the grid as well as the precision of the grid coordinates as well.

####Example Request
`http://greenup.xenonapps.com/api/heatmap?latDegrees=23.45&latOffset=2.0&lonDegrees=40.3&lonOffset=5.12`

####Response
```
[
    {"latDegrees" : 24.53, "lonDegrees" : 43.2, "secondsWorked" : 120},
    {"latDegrees" : 25.13, "lonDegrees" : 41.2, "secondsWorked" : 133}
]
```

---------------------------

###Update Heatmap Data
Method: **PUT**
URL: **/api/heatmap**

####Required PUT data
<table>
    <thead>
        <tr><th>name</th><th>type</th><th>description</th></tr>
    </thead>
    <tbody>
        <tr>
            <td>latDegree</td><td>float</td><td>The latitude degree (in decimal degrees) of the grid point</td>
            <td>lonDegree</td><td>float</td><td>The longitude degree (in decimal degrees) of the grid point</td>
            <td>secondsWorked</td><td>unsigned integer</td><td>The number of seconds spent in this grid location</td>
        </tr>
    </tbody>
</table>

If the request is malformed the server will return an error code of `400 bad request`, on success it will return a `200` to indicate that the resource was updated

####Example Request
`http://greenup.xenonapps.com/api/heatmap`
#####Message Body
`{"latDegrees" : 24.53, "lonDegrees" : 43.2, "secondsWorked" : 120}`

####Response
```
{"response" : 200}
```


-----------------------