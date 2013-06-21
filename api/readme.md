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
  
All API parameters are returned in the JSON format, and all data sent to the API must be in JSON as well. 

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
<tr><th>name</th><th>type</th><th>description  </th>
</thead>
<tbody>
<tr><td>type</td>String <td></td> Can be either `forum`, `needs`, or `message` </td></tr>
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

####POST Data:
<table>
| name       | type           | description  |
|: ------------- :|:-------------:|:-----|
| type      | String | Can be either `forum`, `needs`, or `message` |
| message   | String | The message to associated with this comment | 
| pin (optional) | Integer | The id of a pin to be associated with this comment | 
</table>

####Example Request
`http://greenup.xenonapps.com/api/comments`

####Response:
```
{ 
 "status" : 200, 
 "message : "Succesfully submited new comment",
}
```

---------------------------------


