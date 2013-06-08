var lawnDB = null;
var logging = false;

function initializeGPS(){
	db = Lawnchair({name : 'db'}, function(store) {
		lawnDB = store;
		
		setInterval(function() {runUpdate(store)},5000);//update user location every 5 seconds
		setInterval(function() {upload(store)},30000);//upload locations to the server every 30 seconds
	});
}

function start(){
	logging = true;
	initializeGPS();
	console.log("starting...");
	document.getElementById('startButton').style.display = 'none';
	document.getElementById('stopButton').style.display = 'block';
	//document.getElementById('panel1').style.backgroundImage = 'url(/client/img/icons/leaf.png)';


	navigator.geolocation.getCurrentPosition(function(p){
		var newcenter = new google.maps.LatLng(p.coords.latitude, p.coords.longitude);
		map.panTo(newcenter);
	});
	
}

function stop(){
	upload(lawnDB);
	logging = false;
	console.log("stopping...")
	//document.getElementById('panel1').style.backgroundImage = '';
	document.getElementById('startButton').style.display = 'block';
	document.getElementById('stopButton').style.display= 'none';
}

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
	if(logging){
		//server/addgriddata.php
	
		database.all(function(data){
			console.log(data);
			$.ajax({
				type:'POST',
				url: 'http://ec2-54-214-91-160.us-west-2.compute.amazonaws.com/server/addGridData.php',
				dataType:"json",
				data: {data : data},
				failure: function(errMsg){alert(errMsg);}
			});//Ajax
		
			//Remove all uploaded database records
			for(var i=1;i<data.length;i++){
				database.remove(i);
			}
		});
	}
}

//Updates the local couch DB with the current info
function updateLocation(database, latitude, longitude){
	if(logging){
    	var datetime = new Date().getTime();//generate timestamp
    	var location = {
    			"latitude" : latitude,
    			"longitude" : longitude,
    			"datetime" : datetime,
    	}
	
    	database.save({value:location});//Save the record
	}
};

function findME(){
	var coords = new array();
	lawnDB.all(function(obj){
		coords.push(obj[obj.length - 1].value.latitude);
		coords.push(obj[obj.length - 1].value.longitude);
	});
	
	return coords;
}

