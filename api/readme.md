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

--------------------

Extending the API
--------------------

If you extend the API at all, it is important to update `spider.py` to test the functionality. If the spider cannot finish all of its assertion tests the API should not be released.


---------------------
Get API Information
---------------------

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
<tr><td>type</td><td>String </td><td> Can be either `forum`, `general message`, `trash pickup` or `help needed` </td></tr>
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
            "type" : "trash pickup", 
            "message" : "I need help with the trash on Colchester ave",
            "timestamp" : "2013-05-07 17:12:01",
            "pin" : 3,
            "id" : 4156
        },
        {
            "type" : "help needed",
            "message" : "There's a lot of trash on Pearl St, I could use some help!"
            "timestamp" : "1970-01-01 00:00:01",
            "pin" : None,
            "id" : 1134
        }
    ],
    "page" : {
        "next" : "http://greenup.xenonapps.com/api/comments?type=help+needed&amp;page=3",
        "previous" : "http://greenup.xenonapps.com/api/comments?type=help+needed&amp;page=1"
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
            <td> type </td><td>String </td><td> Can be either `forum`, `help needed`, `trash pickup` or `general message` </td>
        </tr>
        <tr>
            <td> message   </td><td> String </td><td> The message to associated with this comment. Message length must not exceed 140 characters, and must also be non-empty. </td>
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
        <tr><td>raw</td><td>boolean string</td><td>Whether to return secondsWorked from heatmap as a absolute or normalized value. Defaults to normalized, pass raw=true to retrieve absolute secondsWorked</td></tr>
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
        <tr><td>lonOffset</td><td>unsigned float</td><td>Offset to add to the longitude point to create a bounding rectangle on the points retrieved.</td></tr>
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
        "type" : "general message", 
        "message", "I need help with the trash on Colchester ave"
    },
    {
        "latDegrees" : 25.13, 
        "lonDegrees" : 41.2, 
        "type" : "help needed", 
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
        <tr><td>message</td><td>String</td><td>The message associated with this pin. May not be empty or a semantic error will occur</td></tr>
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

----------------------------

###Retrieve log messages

Method: **GET**

URL: **/api/debug**

####Optional Parameters
<table>
    <thead>
        <tr><th>name</th><th>type</th><th>description</th></tr>
    </thead>
    <tbody>
        <tr><td>since</td><td>timestamp</td><td>All messages retrieved will have a timestamp greater than this value</td></tr>
        <tr><td>hash</td><td>String</td><td>Used to get a single message that has the same hash value.</td></tr>
        <tr><td>page</td><td>unsigned Integer</td><td>Based on [RFC 5005], for use with pagination, a request for a page that does not exist will result in no debug messages being returned. A non-integer value for this parameter will result in a 422 HTTP status code. Paging begins at 1.</td></tr>
    </tbody>
</table>

####Example Request
`http://greenup.xenonapps.com/api/debug`

####Response
```
{
    "status" : 200,
    "messages" : [
        {
            "message" : "Null pointer exception on line 42 in badcontroller.java",
            "stackTrace" : " stack trace: ..."
            "timestamp" : "2013-05-08 00:00:01",
            "hash" : "aed60d05a1bd3f7633a6464a7a9b4eab5a9c13a185f47cb651e6b4130ce09dfa"
        },
        {
            "message" : "Problem resolving up address of server. stack trace: ...",
            "stackTrace" : " stack trace: ..."
            "timestamp" : "2014-03-11 00:00:01",
            "hash" : "6f3d78c8ca1d63645015d6fa2d975902348d585f954efd0e8ecca4f362c697d9"  
        }
    ]
}
```

###Post log message

Method: **POST**

URL: **/api/debug**

####Required POST data
<table>
    <thead>
        <tr><th>name</th><th>type</th><th>description</th></tr>
    </thead>
    <tbody>
        <tr><td>message</td><td>String</td><td>A custom message detailing origin of the error and any information that may assist with debugging the problem</td></tr>
        <tr><td>stackTrace</td><td>String</td><td>The programmatic stack trace of the failure</td></tr>
        <tr><td>origin</td><td>String</td><td>Unique information from a client device that allows deletion of a log message by the client</td></tr>
    </tbody>
</table>

####Example Request
`http://greenup.xenonapps.com/api/debug`

####Message Body
```
{
    "message" : "There was a problem in the main controller",
    "stackTrace" : "line 52... etc etc" 
    "origin" : "6f3d78c8ca1d63645015d6fa2d975902348d585f954efd0e8ecca4f362c697d9"
}
```

####Response
```
{ 
 "status" : 200, 
 "message" : "Successful submit",
}
```

###Delete log message

Method: **DELETE**

URL: **/api/debug**

####Required DELETE data
<table>
    <thead>
        <tr><th>name</th><th>type</th><th>description</th></tr>
    </thead>
    <tbody>
        <tr><td>origin</td><td>String</td><td>The unique id identifying a client device.</td></tr>
        <tr><td>hash</td><td>String</td><td>The identifying id for a submitted debug message (can be found through get)</td></tr>
    </tbody>
</table>

Debug messages can also be deleted by developers through the use of a master key. Or through direct access to the database. This master key should not be stored in a public place.

####Example Request
`http://greenup.xenonapps.com/api/debug/?origin=6f3d78c8ca1d63645015d6fa2d975902348d585f954efd0e8ecca4f362c697d9&hash=aed60d05a1bd3f7633a6464a7a9b4eab5a9c13a185f47cb651e6b4130ce09dfa`

####Response
```
{ 
 "status" : 200, 
 "message" : "Successful deletion",
}
```

-------------------------------

##Error messages and codes

####Error Codes
The error codes returned by the API are either of HTTP Code 400 for a bad request (typically a syntax error or problem with the form of the JSON sent.) or a 422 for an unprocessable entry (the JSON is valid but the values or keys are invalid in some way).

###Error messages by Endpoint

#### Comments
<table> 
    <thead>
        <tr><th>Code</th><th>Message</th><th>Causes</th></tr>
    </thead>
    <tr>
        <td colspan="3" style="text-align: center;">GET Requests</td>
    </tr>
    <tbody>
        <tr>
            <td>422</td> <!-- 422 is semantic-->
            <td>Unrecognized type</td>
            <td>The type specified in the request is not a valid type listed by the specification.</td>
        </tr>
        <tr>
            <td>422</td>
            <td>Non-integer page value not allowed</td>
            <td>You requested a page, but did not use an integral number as the page number requested</td>
        </tr>
    </tbody>
    <tr>
        <td colspan="3" style="text-align: center;">POST Requests</td>
    </tr>
    <tbody>
        <tr>
            <td>400</td>
            <td>Request body is malformed</td>
            <td>Attempting to load the JSON sent has failed, the submitted JSON is malformed </td>
        </tr>
        <tr>
            <td>422</td>
            <td>Required keys not present in request</td>
            <td>The JSON submitted is well-formed, but missing one of the keys listed as mandatory in the specification</td>
        </tr>
        <tr>
            <td>422</td>
            <td>Cannot accept null data for required parameters</td>
            <td>Either the type or the message field of the JSON has been left empty and has evaluated to null</td>
        </tr>
        <tr>
            <td>422</td>
            <td>Unrecognized type</td>
            <td>The type specified in the request is not a valid type listed by the specification.</td>
        </tr>
        <tr>
            <td>422</td>
            <td>If pin information is sent in a request, it must be a numeric id</td>
            <td>A pin was submitted that did not have an integral value</td>
        </tr>
        <tr>
            <td>422</td>
            <td>Cannot accept an empty message</td>
            <td>The message submitted to the endpoint was of length 0</td>
        </tr>
        <tr>
            <td>422</td>
            <td>Message exceeds 140 characters</td>
            <td>The message submitted is longer that the maximum length of 140 characters</td>
        </tr>
    </tbody>
</table>

#### Heatmap
<table> 
    <thead>
        <tr><th>Code</th><th>Message</th><th>Causes</th></tr>
    </thead>
    <tr>
        <td colspan="3" style="text-align: center;">GET Requests</td>
    </tr>
    <tbody>
        <tr>
            <td>422</td>
            <td>latDegrees must be within the range of -90.0 and 90.0</td>
            <td>The latitude degree range request is out of bounds</td>
        </tr>
        <tr>
            <td>400</td>
            <td>latDegrees parameter must be numeric</td>
            <td>The value of the latDegree's field sent to the server was not numeric.</td>
        </tr>
        <tr>
            <td>422</td>
            <td>lonDegrees must be within the range of -180.0 and 180.0</td>
            <td>The longitude degree range request is out of bounds</td>
        </tr>
        <tr>
            <td>400</td>
            <td>lonDegrees parameter must be numeric</td>
            <td>The value of the lonDegree's field sent to the server was not numeric</td>
        </tr>
        <tr>
            <td>400</td>
            <td>Precision value must be a numeric integer</td>
            <td>The value of the precision field sent to the server was not numeric</td>
        </tr>
        <tr>
            <td>422</td>
            <td>Both lonOffset and latOffset must be present if either is used</td>
            <td>If any offset is used, longitudinal or latitudinal, both fields must be specified</td>
        </tr>
        <tr>
            <td>400</td>
            <td>Offsets defined must both be integers</td>
            <td>One of the offsets provided is not a valid integral value</td>
        </tr>
    </tbody>
     <tr>
        <td colspan="3" style="text-align: center;">PUT Requests</td>
    </tr>
    <tbody>
        <tr>
            <td>400</td>
            <td>Request body is malformed</td>
            <td>The JSON array sent to the server was not valid</td>
        </tr>
        <tr>
            <td>400</td>
            <td>Required keys not present in request</td>
            <td>One of the key's in the objects within the array sent to the server does not contain the neccesary keys</td>
        </tr>
        <tr>
            <td>422</td>
            <td>Cannot accept null data for required parameters</td>
            <td>One of the values of the required keys in the JSON objects within the array is null</td>
        </tr>
        <tr>
            <td>422</td>
            <td>latDegrees must be within the range of -180.0 and 180.0</td>
            <td>The value of the latitude given for the latDegrees key is out of range</td>
        </tr>
        <tr>
            <td>400</td>
            <td>latDegrees parameter must be numeric</td>
            <td>The given latDegrees key's value is not numeric</td>
        </tr>
        <tr>
            <td>422</td>
            <td>Longitude degrees must be within the range of -90 to 90 degree</td>
            <td>The value of the longitude given for the lonDegrees key is out of range</td>
        </tr>
        <tr>
            <td>400</td>
            <td>lonDegrees parameter must be numeric</td>
            <td>The given lonDegrees key's value is not numeric</td>
        </tr>
        <tr>
            <td>422</td>
            <td>Seconds worked must be a non negative unsigned integer value</td>
            <td>The given value for the seconds worked sent to the server was a signed negative number</td>
        </tr>
        <tr>
            <td>400</td>
            <td>Seconds worked must be an unsigned integer value</td>
            <td>The given value for the seconds worked sent to the server was not an integral value</td>
        </tr>
    </tbody>
</table>

#### Pins
<table> 
    <thead>
        <tr><th>Code</th><th>Message</th><th>Causes</th></tr>
    </thead>
    <tr>
        <td colspan="3" style="text-align: center;">GET Requests</td>
    </tr>
    <tbody>
        <tr>
            <td>422</td>
            <td>latDegrees must be within the range of -90.0 and 90.0</td>
            <td>The latitude degree range request is out of bounds</td>
        </tr>
        <tr>
            <td>400</td>
            <td>latDegrees parameter must be numeric</td>
            <td>The value of the latDegree's field sent to the server was not numeric.</td>
        </tr>
        <tr>
            <td>422</td>
            <td>lonDegrees must be within the range of -180.0 and 180.0</td>
            <td>The longitude degree range request is out of bounds</td>
        </tr>
        <tr>
            <td>400</td>
            <td>lonDegrees parameter must be numeric</td>
            <td>The value of the lonDegree's field sent to the server was not numeric</td>
        </tr>
        <tr>
            <td>422</td>
            <td>Both lonOffset and latOffset must be present if either is used</td>
            <td>If any offset is used, longitudinal or latitudinal, both fields must be specified</td>
        </tr>
        <tr>
            <td>400</td>
            <td>Offsets defined must both be integers</td>
            <td>One of the offsets provided is not a valid integral value</td>
        </tr>
    </tbody>
     <tr>
        <td colspan="3" style="text-align: center;">POST Requests</td>
    </tr>
    <tbody>
        <tr>
            <td>400</td>
            <td>Request body is malformed</td>
            <td>The JSON array sent to the server was not valid</td>
        </tr>
        <tr>
            <td>400</td>
            <td>Required keys not present in request</td>
            <td>One of the key's in the objects within the array sent to the server does not contain the neccesary keys</td>
        </tr>
        <tr>
            <td>422</td>
            <td>Pin type not a valid type.</td>
            <td>The type given for the Pin to be created does not match any of the types specified in the documentation</td>
        </tr>
        <tr>
            <td>422</td>
            <td>latDegrees must be within the range of -90.0 and 90.0</td>
            <td>The latitude degree range request is out of bounds</td>
        </tr>
        <tr>
            <td>400</td>
            <td>latDegrees parameter must be numeric</td>
            <td>The value of the latDegree's field sent to the server was not numeric.</td>
        </tr>
        <tr>
            <td>422</td>
            <td>lonDegrees must be within the range of -180.0 and 180.0</td>
            <td>The longitude degree range request is out of bounds</td>
        </tr>
        <tr>
            <td>400</td>
            <td>lonDegrees parameter must be numeric</td>
            <td>The value of the lonDegree's field sent to the server was not numeric</td>
        </tr>
        <tr>
            <td>422</td>
            <td>Pin message may not be empty.</td>
            <td>The message to be associated with the pin was empty or null</td>
        </tr>
    </tbody>
</table>


#### Debug
<table> 
    <thead>
        <tr><th>Code</th><th>Message</th><th>Causes</th></tr>
    </thead>
    <tr>
        <td colspan="3" style="text-align: center;">GET Requests</td>
    </tr>
    <tbody>
        <tr>
            <td colspan="3">TO DO</td>
        </tr>
    </tbody>
    <tr>
        <td colspan="3" style="text-align: center;">POST Requests</td>
    </tr>
    <tbody>
        <tr>
            <td colspan="3">TO DO</td>
        </tr>
    </tbody>
    <tr>
        <td colspan="3" style="text-align: center;">DELETE Requests</td>
    </tr>
    <tbody>
        <tr>
            <td colspan="3">TO DO</td>
        </tr>
    </tbody>
</table>


[RFC 5005]: http://www.ietf.org/rfc/rfc5005.txt
