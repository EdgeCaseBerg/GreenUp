GreenUp API Documenation
=========================

Powered By [Xenon App's]

[Xenon App's]: http://www.XenonApps.com

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

Error Messages:
--------------------

When the API has difficulty processing any request it will return an error message within the json string in the following format:
```
{
    "Error_Message" : "There was a problem with your request"
}
```
The value of the `Error_Message` field will be an informative message that will help you troubleshoot your malformed request. 

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
<tr><td>page</td><td>unsigned Integer</td><td>Based on [RFC 5005], for use with pagination, a request for a page that does not exist will result in no comments being returned. A non-integer value for this parameter will result in a 422 HTTP status code. Paging begins at 1.</td></tr>
</tbody>

</table> 

No type specified will return all comments.

####Example request
`http://greenup.xenonapps.com/api/comments?type=needs`

####Response:
```no-highlight
{
    "comments" : [
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
    ],
    "page" : {
        "next" : "http://greenup.xenonapps.com/api/comments?type=needs&amp;page=3",
        "previous" : "http://greenup.xenonapps.com/api/comments?type=needs&amp;page=1"
    }
}
```
The pin field refers to a pin resource. Each pin is identified uniquely by an unsigned integer value assigned to it from the database. If a comment originated from a pin being created with a message, then this message will appear as a comment with a non None pin resource id.

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

If the post data is malformed, the server will return a `400 bad request` response, on success a `200` will be returned. If the POSTed data is syntactically correct but semantically incorrect (such as giving a string value instead of an integer for pin), a 422 will be returned. If a pin resource id is POSTed in the response, it must correspond to a valid pin and the message submited will replace the message stored for that pin.

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
 "message" : "Succesfully submited new comment",
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
        <tr><td>latDegrees</td><td>float</td><td>The latitude boundary of the grid of points to retrieve,only values between -90.0 and 90.0 will be accepted.</td></tr>
        <tr><td>latOffset</td><td>unsigned float</td><td>Offset to add to the latitude point to create a bounding rectangle on the points retrieved.</td></tr>
        <tr><td>lonDegrees</td><td>float</td><td>The longitude boundary of the grid of points to retrieve, only values between -180.0 and 180.0  will be accepted.</td></tr>
        <tr><td>lonOffset</td><td>unsigned float</td><td>Offset to add to the longitude point to create a bounding rectangle on the points retrieved.</td></tr>
        <tr><td>precision</td><td>unsigned integer</td><td>The integer precision for rounding degrees. It is recommended to leave this blank unless you know what you're doing.</td></tr>
    </tbody>
</table>

If none of these parameters are specified, all points will be returned. Note that this may be slow depending on the total number of points stored in the grid as well as the precision of the grid coordinates as well. 

If the request only specifies the offset then the API will return an error message.

####Example Request
`http://greenup.xenonapps.com/api/heatmap?latDegrees=23.45&latOffset=2.0&lonDegrees=40.3&lonOffset=5.12`

####Response
```
[
    {
        "latDegrees" : 24.53, 
        "lonDegrees" : 43.2, 
        "secondsWorked" : 120
    },
    {
        "latDegrees" : 25.13, 
        "lonDegrees" : 41.2, 
        "secondsWorked" : 133
    }
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
            <td>latDegree</td><td>float</td><td>The latitude degree (in decimal degrees) of the grid point, between -90.0 and 90.0</td>
        </tr>
        <tr>
            <td>lonDegree</td><td>float</td><td>The longitude degree (in decimal degrees) of the grid point, between -180.0 and 180.0</td>
        </tr>
        <tr>
            <td>secondsWorked</td><td>unsigned integer</td><td>The number of seconds spent in this grid location</td>
        </tr>
    </tbody>
</table>

If the request is malformed the server will return an error code of `400 bad request`, on success it will return a `200` to indicate that the resource was updated

####Example Request
`http://greenup.xenonapps.com/api/heatmap`
#####Message Body
```
[
    {
        "latDegrees" : 24.53, 
        "lonDegrees" : 43.2, 
        "secondsWorked" : 120
    }
]
```

####Response
```
{ 
 "status" : 200, 
 "message" : "Successful submit",
}
```

It is important to note that the heatmap endpoint for **PUT** accepts only json arrays of headmap data objects, this enables batch updating of the heatmap resource.


-----------------------

###Get Pins

Method: **GET**

URL: **/api/pins**

####Optional Parameters
<table>
    <thead>
        <tr><th>name</th><th>type</th><th>description</th></tr>
    </thead>
    <tbody>
        <tr><td>latDegrees</td><td>float</td><td>The latitude boundary of the grid of points to retrieve, values must be between -90.0 and 90.0</td></tr>
        <tr><td>latOffset</td><td>unsigned float</td><td>Offset to add to the latitude point to create a bounding rectangle on the points retrieved.</td></tr>
        <tr><td>lonDegrees</td><td>float</td><td>The longitude boundary of the grid of points to retrieve, values must be between -180.0 and 180.0</td></tr>
        <tr><td>lonOffset</td><td>unsigned float</td>Offset to add to the longitude point to create a bounding rectangle on the points retrieved.</tr>
    </tbody>
</table>

If no latitude or longitude are specified then all pins will be returned.

####Example Request
`http://greenup.xenonapps.com/api/pins`

####Response
```
[
    {
        "latDegrees" : 24.53, 
        "lonDegrees" : 43.2, 
        "type" : "message", 
        "message", "I need help with the trash on Colchester ave"
    },
    {
        "latDegrees" : 25.13, 
        "lonDegrees" : 41.2, 
        "type" : "needs", 
        "message", "There's a lot of trash on Pearl St, I could use some help!"
    }
]
```


---------------------

###Submit Pin

Method: **POST**

URL: **/api/pins**

####Required POST data
<table>
    <thead>
        <tr><th>name</th><th>type</th><th>description</th></tr>
    </thead>
    <tbody>
        <tr><td>latDegrees</td><td>float</td><td>The latitude coordinate of the pin in Decimal Degrees, values must range between -90.0 and 90.0</td></tr>
        <tr><td>lonDegrees</td><td>float</td><td>The longitude coordinate of the pin in Decimal Degrees, values must range between -180.0 and 180.0</td></tr>
        <tr><td> type </td><td>String </td><td> Can be either `general message`, `help needed`, or `trash pickup` </td></tr>
        <tr><td>message</td><td>String</td><td>The message associated with this pin</td></tr>
    </tbody>
</table>


####Example Request
`http://greenup.xenonapps.com/api/pins`
#####Message Body
```
{
    "latDegrees" : 24.53, 
    "lonDegrees" : 43.2, 
    "type" : "trash pickup", 
    "message" : "I had to run to feed my cat, had to leave my Trash here sorry! Can someone pick it up?"
}
```

####Response
```
{ 
 "status" : 200, 
 "message" : "Successful submit",
}
```

If the Post body is malformed, then the server will emit a `400 Bad Request` response, and if possible state the reason for why the pin was rejected. For example, a post body with a type of `pickup` will be rejected because it is not a valid type of pin.

[RFC 5005]: http://www.ietf.org/rfc/rfc5005.txt
