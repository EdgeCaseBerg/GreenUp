Simple Auth API Documentation and Specification
=======================================================================

[TOC]

General Knowledge and Terms:
-----------------------------------------------------------------------

An API is simply an Application Protocol Interface, and is a defined way
of communicating with another process. This can be anything from sending
a 1 to a program to indicate that it should perform some action, or a 2
to tell it to stop. When you are on the command line shell and typing
commands, those commands are your API to the underlying operating
system through the shell. In recent years, an API has become synonymous
with a Server that hosts resources and access to those Resources in a
[REST]ful manner.

The Simple Auth API is one of these latter systems. Through a series of
Resources and a defined use of [HTTP] verbs, it is possible to obtain
information from the Simple Auth system to populate application views and user
contexts. This document is an almagation of the methods made available
to a public interface.

`Endpoints` is the term used by this document to refer to high level
concepts within the API. For example, all actions done directly to a
User resource, can be done through the User Endpoint, which is
identified by the Base Url of the Api, and the resource identifying
string of `/User`. In General [REST]ful fashion, the **C.R.U.D** events of
Create, Read, Update, and Delete are provided for most resources through
the use of the [HTTP] Verbs `POST`, `GET`, `PUT`, and `DELETE` respectfully.
Additional parameters that enhance the specificity of the requests are
generally included as Query level Parameters such as: `/User/123456789`
identifying a User whose identifying number is 123456789.

 
API Endpoint Definitions And Method Procedures
=======================================================================

For the purpose of generality, the Base Url (`http://www. ... .com`) is
left out of the method definitions, and only the resource identifying
component of the URI's are specified. (`/auth` for example, indicates
the url of `http://www.example.com/auth`) 

Registration
-----------------------------------------------------------------------

Endpoint: `/register`  
Method: **POST**  
Data Format: **JSON**  
Required Data:  
<table>
<thead><tr><th>Key</th><th>Value</th></tr></thead>
<tbody>
<tr>
    <td>id</td>
    <td>String identifying connecting client</td>
</tr>
<tr>
    <td>us</td>
    <td>Unique string used as pass phrase</td>
</tr>
</tbody>
</table>

Example Request:  

    {
        "id" : "abcdefghijklmnopqrstuvwxyz0123456789",
        "us" : "63124bc7aa9cdfbf2112b3b22130fbb7"
    }

Response to Example Request:
    
    {
        "code" : 200,
        "token" : "b91d1910c62928dd157081599f5c3e7f"
    }




Authorization
-----------------------------------------------------------------------

Endpoint: `/auth`  
Method: **POST**  
Data Format: **JSON**  
Required Data:  
<table>
<thead><tr><th>Key</th><th>Value</th></tr></thead>
<tbody>
<tr>
	<td>id</td>
	<td>String identifying connecting client</td>
</tr>
<tr>
	<td>us</td>
	<td>Unique string used as pass phrase</td>
</tr>
</tbody>
</table>

Example Request:  

    {
        "id" : "abcdefghijklmnopqrstuvwxyz0123456789",
        "us" : "63124bc7aa9cdfbf2112b3b22130fbb7"
    }

Response to Example Request:
    
    {
        "code" : 200,
        "token" : "b91d1910c62928dd157081599f5c3e7f"
    }



DeRegistration - Part 1
-----------------------------------------------------------------------

Removing a client from the System is a two part process. First, one
issues a `POST` request to the de-registration endpoint with the user
identifier and client secret. If the request is valid a URL to issue a
`GET` request to will be returned. After visiting this URL with the
proper credentials, the User will be removed from the System. 

Endpoint: `/deregister`  
Method: **POST**  
Data Format: **JSON**  
Required Data:  
<table>
<thead><tr><th>Key</th><th>Value</th></tr></thead>
<tbody>
<tr>
    <td>id</td>
    <td>String identifying connecting client</td>
</tr>
<tr>
    <td>us</td>
    <td>Unique string used as pass phrase</td>
</tr>
</tbody>
</table>

Example Request:  

    {
        "id" : "abcdefghijklmnopqrstuvwxyz0123456789",
        "us" : "63124bc7aa9cdfbf2112b3b22130fbb7"
    }

Response to Example Request:
    
    {
        "code" : 200,
        "url" : /deregister.php?token=$2y$10$ax6DiYSQlvLWhXZOisKJze0ZwwXVz0FJuBooHo67yJENhsY4Kfbra&us=$2y$10$KJyK6ZhL7Evt0KUNKEZnBOsQsJNVqtGb9CdLR.JiGW/8m7hrx69zy&id=abcdefghijklmnopqrstuvwxyz0123456789"
    }


DeRegistration - Part 2
-----------------------------------------------------------------------

Endpoint: `/deregister?token=<token>&id=<id>&us=<us>`  
Method: **GET**  
Data Format: **JSON**  
Required Query Parameters:  
<table>
<thead><tr><th>Key</th><th>Value</th></tr></thead>
<tbody>
<tr>
	<td>id</td>
	<td>String identifying connecting client</td>
</tr>
<tr>
	<td>us<sup><a href="#" title="This is not the same `us` as the client
secret used for authentication">Note</a></sup></td>
	<td>Authorization secret returned from part 1 of /deregister</td>
</tr>
<tr>
	<td>token</td>
	<td>Authorization token returned from part 1 of /deregister</td>
</tr>
</tbody>
</table>

Example Request:  

    /deregister?token=$2y$10$bGTfTa36ZW/Rwa0ENITaY.UFZv5QqeBqO3dIBcbdWMTfTQiS5uN7.&id=abcdefghijklmnopqrstuvwxyz0123456789"&us=$2y$10$bGTfTa36ZW/Rwa0ENITaY.UFZv5QqeBqO3dIBcbdWMTfTQiS5uN7.


Response to Example Request:
    
    {
	    "code" : 200,
	    "message" : "User <id> removed from System"    
    }



Reference Section
----------------------------------------------------------------------

- [HTTP]
- [REST]
- [Hash]
- [Salt]
- [BCrypt]
- [HoneyPots]

 
[HTTP]:(http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html) 
[REST]:(http://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm)
[Hash]:(http://en.wikipedia.org/wiki/Cryptographic_hash_function)
[Salt]:(http://en.wikipedia.org/wiki/Salt_(cryptography))
[BCrypt]:(http://en.wikipedia.org/wiki/Bcrypt)
[HoneyPots]:(http://en.wikipedia.org/wiki/Honeypot_(computing))
