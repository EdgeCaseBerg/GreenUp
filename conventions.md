Coding Conventions For API / Server team
=========================================



The API team follows the following conventions:

* Classnames begin with an uppercase and are camel cased from there
* Constants are defined with underscores for spaces and all capital letters
* Functions are camel cased beginning with lower case letters
* Variable names are descriptive, if the descriptive text of the variable name is very long it is acceptable to use all lowercase underscore notation. If the variable name is short it is prefferable to use camel case.
* Status codes should not be hardcoded in and should instead rely on the status code constants defined in api.py 
* Code is tested before commited to the remote repository. A test harness exists to unit test datastore side code, and a spider exists to crawl the api endpoint side code. If an endpoint is extended, then the spider should be extended as well to encompass the new feature