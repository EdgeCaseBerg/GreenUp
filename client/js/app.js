db = Lawnchair({name : 'db'}, function(store) {
	
	setInterval(function() {runUpdate(store)},5000);//update user location every 5 seconds
	setInterval(function() {upload(store)},30000);//upload locations to the server every 30 seconds
	
});

//Runs the update script:

function runUpdate(database){
	//Grab the geolocation data from the local machine
    navigator.geolocation.getCurrentPosition(function(position) {
    	  updateLocation(database, position.coords.latitude, position.coords.longitude);
    });
}

//Uploads all local database entries to the Server
//Clears the local storage after upload
function upload(database){
	//server/addgriddata.php
	
	database.all(function(obj){
    	$.ajax({
    		type:'POST',
    		url: '/server/addGridData.php',
    		dataType:"json",
            data: obj,
            success: function(data){alert(obj);},   // Success Function
    		failure: function(errMsg){alert(errMsg);}
    	});//Ajax
		
		//Remove all uploaded database records
    	for(var i=1;i<obj.length;i++){
    		database.remove(i);
    	}
    });
}

//Updates the local couch DB with the current info
function updateLocation(database, latitude, longitude){
    var datetime = new Date().getTime();//generate timestamp
	var location = {
			"latitude" : latitude,
			"longitude" : longitude,
			"datetime" : datetime,
	}
	
	database.save({value:location});//Save the record
};
