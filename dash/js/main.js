
// prototype objects for posting to API
function Pin(){
	this.latDegrees; 
    this.lonDegrees;
    this.type; 
    this.message = "I had to run to feed my cat, had to leave my Trash here sorry! Can someone pick it up?";
    this.addressed = false;
}


//We cannot call this Comment because it's reserved by javascript
function FCommment(){
	this.message ="FORUM";
	this.pin = null;
	this.type = "";
}

function INPUT_TYPE(){
	this.NONE  = -1;
	this.PIN = 0;
	this.MARKER = 0;
	this.COMMENT = 1;
}

// logger for reporting problems to the server
function ClientLogger(){
	ClientLogger.prototype.debug = function debug(eventString, methodNameString){
        if(window.DEBUG){
            var str = methodNameString + ' - ' +eventString;
            console.log('%c [DEBUG] ' + str, 'background: #fff; color: blue');
        }
	}

    ClientLogger.prototype.log = function log(eventString, methodNameString){
        console.log(methodNameString, eventString);
    }

    ClientLogger.prototype.info = function info(eventString, methodNameString){
        var str = methodNameString + ' - ' +eventString;
        console.log('%c [INFO] ' + str, 'background: #fff; color: green');
    }

    ClientLogger.prototype.error = function error(eventString, methodNameString){
        var str = methodNameString + ' - ' +eventString;
        console.log('%c [ERROR] ' + str, 'background: #fff; color: red');
    }
}

