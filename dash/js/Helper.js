// the helper object is for storing all our misc functions. 

function Helper(){

	// in JS there's a lot of ways that soemthign could be null
	Helper.prototype.isNull = function isNull(testVar){
		if(testVar == "undefined"){
			return true;
		}else if (testVar == undefined){
			return true;
		}else if(testVar == null){
			return true;
		}else if(testVar == ""){
			return true;
		}else if(testVar === null){
			return true;
		}else{
			return false;
		}
	}

	Helper.prototype.isString = function isString(o) {
    	return typeof o == "string" || (typeof o == "object" && o.constructor === String);
	}

    Helper.prototype.isArray = function isArray(obj){
        if( Object.prototype.toString.call( obj ) === '[object Array]' ) {
            // it's an array
            return true;
        }else{
            return false;
        }
    }

	Helper.prototype.stripTags = function stripTags(string){
		if(this.isString(string)){
			var cleanText = string.replace(/<\/?[^>]+(>|$)/g, "");
			return cleanText;
		}else{
			return string;
		}
	}

	// iterates over a dictionary and returns the values in an array
	Helper.prototype.objToArray = function objToArray(obj){
		var arr = [];
		for (key in obj){
			arr.push(obj[key]);
		}
		return arr;
	}

	// returns an int to indicate the size of a dictionary object
    Helper.prototype.dictSize = function dictSize(obj) {
        var size = 0, key;
        for (key in obj) {
            if (obj.hasOwnProperty(key)) size++;
        }
        return size;
    };

    Helper.prototype.isJson = function isJson(str) {
    	try {
        	JSON.parse(str);
    	} catch (e) {
        	return false;
    	}
    	return true;
	}

	Helper.prototype.isArray = function isArray(value){
		if (value instanceof Array) {
			return true;
		} else {
			return false;
		}
	}

	// used for checking if a player object has been changed during the update player operations
	// returns a boolean indicating 
	Helper.prototype.hasPlayerChanged = function hasPlayerChanged(beforePlayer, afterPlayer){
		try{
			for(property in beforePlayer){
				if(beforePlayer[property] != afterPlayer[property]){
					return true;
				}
			}
		}catch(e){
			// the property was not likely found in both objects
			console.log("EXCEPTION: attempt to determine if the player object has changed: "+e);
			return true;
		}
		return false;
	}

	// searches through the player and team dictionaries to identify players not assigned
	// to teams, and returns an array of those player objects
	Helper.prototype.findPlayersNotOnTeam = function findPlayersNotOnTeam(){
		var results = []; 
		for(key in window.playerDict){
			var player = window.playerDict[key];
			var isOnTeam = false;

			for(t in window.teamDict){
				for(var ii=0; ii<t.players.length; ii++){
					if(players[ii].player_id == player.player_id){
						isOnTeam = true;
					}
				}
			}

			if(!isOnTeam){
				results.push(player);
			}

		}
		return results;
	}

	// returns empty metrics divs based on the metric type
	// used in LoadSnippet.showPlayerDetail()
    // todo: should probably be in the UI class
    Helper.prototype.createMetricDiv = function createMetricDiv(metric){
    	if(metric.type == "STAR"){
            return window.UI.buildStarMetricDiv(metric);
        }else{
	        if(metric.type == "QUANT"){
                return window.UI.buildQuantMetricDiv(metric);
	        }else if(metric.type == "BOOL"){
                return window.UI.buildBoolMetricDiv(metric);
	        }else if(metric.type == "CAT"){
                return window.UI.buildCatMetricDiv(metric);
	        }else{
	        	console.log("Helper.createMetricDiv : unable to determine metric type");
	        }
	    }
    };

     Helper.prototype.createCookie = function createCookie(name, value, days) {
	    if (days) {
	        var date = new Date();
	        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
	        var expires = "; expires=" + date.toGMTString();
	    } else var expires = "";
	    document.cookie = escape(name) + "=" + escape(value) + expires + "; path=/";
	}

	 Helper.prototype.readCookie = function readCookie(name) {
	    var nameEQ = escape(name) + "=";
	    var ca = document.cookie.split(';');
	    for (var i = 0; i < ca.length; i++) {
	        var c = ca[i];
	        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
	        if (c.indexOf(nameEQ) == 0) return unescape(c.substring(nameEQ.length, c.length));
	    }
	    return null;
	}

	 Helper.prototype.eraseCookie = function eraseCookie(name) {
	    window.Helper.createCookie(name, "", -1);
	}

    Helper.prototype.isNumber = function isNumber(o){
        try{
            return ! isNaN (o-0) && o !== null && o.replace(/^\s\s*/, '') !== "" && o !== false;
        }catch(e){
            return false;
        }
    }

    Helper.prototype.isTrue = function isTrue(o){

        if(o == undefined){
            throw "undefined boolean type: "+(new Error).lineNumber;
        }
//        console.log("** isTrue:");
//        console.log(o);

        if(o === true || o == true){
            return true;
        }

        if(window.Helper.isString(o)){
            if(o == "1"){
                return true;
            }else if(o.toLowerCase() == "true"){
                return true;
            }
        }else if(window.Helper.isNumber(o)){
            if(o != 0 && o != -1){
                return true;
            }
        }else{
            return false;
        }
    }

    Helper.prototype.getGoogleFormattedDate = function getGoogleFormattedDate(dateObj){
        var monthString = dateObj.getMonth().toString();
        var dayString = dateObj.getDay().toString();
        if(dateObj.getMonth() < 10){
            monthString = "0"+monthString;
        }
        if(dateObj.getDay() < 10){
            dayString = "0"+dayString;
        }

        var result = dateObj.getFullYear().toString() + "-"+
            monthString + "-" + dayString;

        return result;
    }

    Helper.prototype.metersToAcres = function metersToAcres(sqMeters){
        return (sqMeters * 0.000247105);
    }

    Helper.prototype.secondsToHoursMinutesSeconds = function secondsToHoursMinutesSeconds(seconds){

        var remainderSeconds = (seconds % 60);
        var minutes = ((seconds - remainderSeconds) / 60);
        var remainderMinutes = (minutes % 60);
        var hours = ((minutes - remainderMinutes) / 60);
        var remainderHours = (hours % 24);
        var days = ((hours - remainderHours) / 24);

        if(remainderHours < 10){
            remainderHours = ("0"+remainderHours);
        }
        if(remainderMinutes < 10){
            remainderMinutes = ("0"+remainderMinutes);
        }
        if(remainderSeconds < 10){
            remainderSeconds = ("0"+remainderSeconds);
        }

        var results = {"days": days, "hours" : remainderHours, "minutes" : remainderMinutes, "seconds" : remainderSeconds};
        console.log(results);
        return results;
    }
		
}