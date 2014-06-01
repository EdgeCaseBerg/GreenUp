
// prototype objects for posting to API
function Pin(){
	this.latDegrees;
    this.lonDegrees;
    this.type;
    this.message = "I had to run to feed my cat, had to leave my Trash here sorry! Can someone pick it up?";
    this.addressed = false;
}

function LogEvent(message, stackTrace, origin){
    this.message = message;
    this.stackTrace = stackTrace,
    this.origin = origin;
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

    ClientLogger.prototype.obj = function obj(object, methodName, details){
        this.info(details, methodName);
        //console.log(object)
        this.info("******", "******");
    }

    ClientLogger.prototype.error = function error(eventString, methodNameString){
        var str = methodNameString + ' - ' +eventString;
        console.log('%c [ERROR] ' + str, 'background: #fff; color: red');
    }

    ClientLogger.prototype.serverLog = function serverLog(message, stacktrace){
        this.debug(arguments.callee.name, "[METHOD]");
        var event = new LogEvent(message, stacktrace, "Green-UP Admin Dash");
        window.ApiConnector.postLogEvent(event, window.ApiConnector.pullServerLog(window.UI.updateLogContent));
    }
}

