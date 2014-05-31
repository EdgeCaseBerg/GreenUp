/* SimpleAuth Javascript Library 
 * 
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2013 Ethan Eldridge
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * This Javascript Library adds complete functionality to a
 * webpage to use the SimpleSimple Auth Open API. Documentation is inline this file
 * and bug fixes and error reports may be sent to ejayeldridge@gmail.com
 * for review. Patch files in git's format-patch format are also
 * acceptable. 
 *
*/
function SimpleAuth(options){
	if(options == null || typeof options != "object")
		throw new Error('Initialization Failure of SimpleAuth library. Please include an object to your call to Simple Auth.')

	this.proxy = options.proxy ? options.proxy : "" /* Include a proxy script here if desired, Will be appended to host */
	this.host = (options.host  ? options.host : "http://localhost") + this.proxy
	this.extension = options.extension ? options.extension : "" /* For targeting a language version of the API */

	var auth = "auth" + this.extension
	var register = "register" + this.extension
	var deregister = "deregister" + this.extension

	this.callback = function(json_obj){ console.log(json_obj) }
	/* Before All Functions the client should
	 * set the callback function that will accept 
	 * an object sent to it from the API
	*/
	this.setCallback = function(callback){
		this.callback = callback
	}

	this.get = function( endpoint ){
		var xmlHttp = null
		var ref = this;
    	xmlHttp = new XMLHttpRequest()
    	xmlHttp.onreadystatechange = function(){
    		if( xmlHttp.readyState == 4 )
    			ref.callback(JSON.parse(xmlHttp.response))
    	}
    	xmlHttp.open( "GET", this.host + endpoint , true )
    	xmlHttp.send( null )
	}

	this.post = function( endpoint , data ){
		var xmlHttp = null;
		var ref = this
		xmlHttp = new XMLHttpRequest()
		xmlHttp.onreadystatechange = function(){
    		if( xmlHttp.readyState == 4 )
    			ref.callback(JSON.parse(xmlHttp.response))
    	}
    	xmlHttp.open( "POST", this.host + endpoint , true )
    	xmlHttp.send( JSON.stringify( data ) )
	}
	
	this.auth = function(id, us){
		/* Call the authorization endpoint of the api 
		 * with the credentials given. Will pass the
		 * xmlHttp object to the callback set by setCallback
		*/
		this.post(auth, {"id" : id, "us" : us})
	}

	this.register = function(id, us){
		/* Call the registration endpoint of the api
		 * with the credentials, pass the resulting
		 * xmlHttp object to the function set by setCallback
		 * You'll want to check xmlHttp.status and .response
		*/
		this.post(register, {"id" : id, "us" : us})
	}

	this.get_deregister_url = function(id, us){
		/* Call deregisteration POST endpoint to get 
		 * the unique url that will remove the user
		 * called if followed.
		*/
		this.post(deregister,{"id" : id, "us" : us})
	}

	this.deregister = function(url){
		/* Deregisters a user by following a deactivation
		 * URL. If no host is found in URL then default API
		 * host is appended.
		*/
		if(url.indexOf("http") == 0){
			var tempHost = this.host
			this.host = url
			this.get("")
			this.host = tempHost
		}else{
			/* Assume url is just query params and use default host */
			url = url.indexOf("?") == 0 ? url : '?' + url
			this.get(deregister + url)
		}
		
	}

	return this;
}

