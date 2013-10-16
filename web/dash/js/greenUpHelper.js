function Helper(){
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