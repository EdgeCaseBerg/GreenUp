function ApiConnector(){
	var heatmapData = []; 
	var markerData = []; 
	var commentData = [];


    this.LOCALHOST = "https://127.0.0.1/green-web"
    this.PROXYBASE = "/proxy.php?url=";
    this.HOST = "http://199.195.248.180";
    this.PORT = ":31337"
    this.BASE = "/api";


	// api URLs have been moved into each of the functions using them as per issue 46

	// performs the ajax call to get our data
	ApiConnector.prototype.pullApiData = function pullApiData(URL, DATATYPE, QUERYTYPE, CALLBACK, USE_URL){
		console.log("url requested");
		console.log(URL);
        if(!window.HELPER.isNull(USE_URL) && USE_URL == 1){
            // leave the URL alone
        }else{
            URL = this.LOCALHOST+this.PROXYBASE+this.HOST+this.PORT+this.BASE+URL;
        }
        console.log(URL);
		$.ajax({
			type: QUERYTYPE,
			url: URL,
			dataType: DATATYPE,
			success: function(data){
                if(window.HELPER.isNull(data.contents)){
                    CALLBACK(data);
                }else{
                    CALLBACK(data.contents);
                }
				console.log("Pull API Data: SUCCESS");
				// console.log(data);

			},
			error: function(xhr, errorType, error){
				// alert("error: "+xhr.status);
				switch(xhr.status){
					case 500:
						// internal server error
						// consider leaving app
						console.log("Error: api response = 500");
						break;
					case 404:
						// not found, stop trying
						// consider leaving app
						console.log('Error: api response = 404');
						break;
					case 400:
						// bad request
						console.log("Error: api response = 400");
						break;
					case 422:
						console.log("Error: api response = 422");
						break;
					case 200:
						console.log("Pull API data: 200");
						break;
					default:
						// alert("Error Contacting API: "+xhr.status);
						break;
				}
			}
		});
	} // end pullApiData



	ApiConnector.prototype.pushNewPin = function pushNewPin(jsonObj){
		console.log(jsonObj);
		var pinsURI = "/pins";
		$.ajax({
			type: "POST",
			url: pinsURI,
			data: jsonObj,
    		cache: false,
			// processData: false,
			dataType: "json",
			// contentType: "application/json",
			success: function(data){
				console.log("INFO: Pin successfully sent");
				if(window.UI.isAddMarkerDialogVisible){
					window.UI.toggleAddMarkerOptions();
				}
				//Becuase of the datastore's eventual consistency you must wait a brief moment for new data to be available.
				setTimeout(function(){window.ApiConnector.pullMarkerData();},1500);
			},
			error: function(xhr, errorType, error){
				// // alert("error: "+xhr.status);
				switch(xhr.status){
					case 500:
						// internal server error
						// consider leaving app
						window.LOGGER.logEvent("Error: api response = 500", "ApiConnector: pushNewPin()");

						break;
					case 503:
						window.LOGGER.logEvent("Service Unavailable");
						break;

					case 404:
						// not found, stop trying
						// consider leaving app
						window.LOGGER.logEvent('Error: api response = 404', "ApiConnector: pushNewPin()");
						break;
					case 400:
						// bad request
						window.LOGGER.logEvent("Error: api response = 400", "ApiConnector: pushNewPin()");
						window.LOGGER.logEvent(error);
						break;
					case 422:
						window.LOGGER.logEvent("Error: api response = 422", "ApiConnector: pushNewPin()");
						break;
					case 200:
						console.log("Request successful");
						break;
					default:
						window.LOGGER.logEvent("Unknown Error Code", "ApiConnector: pushNewPin()");
						break;
				}
			}
		});
		//zepto

	}

	


	// ********** specific data pullers *************
	ApiConnector.prototype.pullHeatmapData = function pullHeatmapData(latDegrees, latOffset, lonDegrees, lonOffset){
		/*
			To be extra safe we could do if(typeof(param) === "undefined" || param == null),
			but there is an implicit cast against undefined defined for double equals in javascript
		*/
		var heatmapURI = "/heatmap";
		var params = "";
		if(latDegrees != null){
			params = "?";
			params += "latDegrees=" + latDegrees + "&";
		}
		if(latOffset != null){
			params = "?";
			params += "latOffset=" + latOffset + "&";
		}
		if(lonDegrees != null){
			params = "?";
			params += "lonDegrees" + lonDegrees + "&";
		}
		if(lonOffset != null){
			params = "?";
			params += "lonOffset" + lonOffset + "&";
		}
		console.log("Preparing to pull heatmap data");
		var URL = heatmapURI+params;
		this.pullApiData(URL, "JSON", "GET", window.UI.updateHeatmap);

	}

	// ********** specific data pullers *************
	ApiConnector.prototype.pullRawHeatmapData = function pullRawHeatmapData(){
		/*
			To be extra safe we could do if(typeof(param) === "undefined" || param == null),
			but there is an implicit cast against undefined defined for double equals in javascript
		*/
		var heatmapURI = "/heatmap";
		var params = "?raw=true";
		console.log("Preparing to pull RAW heatmap data");
		var URL = heatmapURI+params;
		this.pullApiData(URL, "JSON", "GET", window.UI.updateRawHeatmapData, null);
	}

	ApiConnector.prototype.pullMarkerData = function pullMarkerData(){
		console.log("pullMarkerData");
		var pinsURI = "/pins";
		var URL = pinsURI;
		//Clear the markers
		for( var i =0 ; i < window.MAP.pickupMarkers.length; i++){
			window.MAP.pickupMarkers[i].setMap(null);
		}
		window.MAP.pickupMarkers = [];
        var customUrl = null;
		this.pullApiData(URL, "JSON", "GET", window.UI.updateMarker, customUrl);
	}

	// by passing the url as an argument, we can use this method to get next pages
	ApiConnector.prototype.pullCommentData = function pullCommentData(commentType, url){
		var urlStr = "";
		if(url == null || url == "null"){
			urlStr += "/comments";
		}else{
			urlStr += url;
		}
        var customUrl = null;
		this.pullApiData(urlStr, "JSON", "GET",  window.UI.updateForum, customUrl);
	} // end pullCommentData()

	ApiConnector.prototype.pushCommentData = function pushCommentData(jsonObj){
		var commentsURI = "/comments";
		console.log("json to push: "+jsonObj);
		console.log("Push comment data to: "+commentsURI);
		$.ajax({
			type: "POST",
			url: commentsURI,
			data: jsonObj,
    		cache: false,
			// processData: false,
			dataType: "json",
			// contentType: "application/json",
			success: function(data){
				console.log("INFO: Comment successfully sent");
				window.ApiConnector.pullCommentData(JSON.parse(jsonObj).type, null);
			},
			error: function(xhr, errorType, error){
				// // alert("error: "+xhr.status);
				switch(xhr.status){
					case 500:
						// internal server error
						// consider leaving app
						console.log("Error: api response = 500");
						break;
					case 503:
						console.log("Service Unavailable");
						break;

					case 404:
						// not found, stop trying
						// consider leaving app
						console.log('Error: api response = 404');
						break;
					case 400:
						// bad request
						console.log("Error: api response = 400");
						break;
					case 422:
						console.log("Error: api response = 422");
						break;
					case 200:
						console.log("Request successful");
						break;
					default:
						// alert("Error Contacting API: "+xhr.status);
						break;
				}
			}
		});
	}

	ApiConnector.prototype.pullTestData = function pullTestData(){
		this.pullApiData(BASE, "JSON", "GET", window.UI.updateTest);
		this.pullCommentData("needs", null);
		this.pullCommentData("messages", null);
		this.pullCommentData("", null);
		this.pullHeatmapData();
		this.pullMarkerData();
	}

	ApiConnector.prototype.getStreetFromLatLng = function getStreetFromLatLng(lat, lng, callback){
		var baseGeocodeUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=";
		baseGeocodeUrl += lat + ",";
		baseGeocodeUrl += lng;
		baseGeocodeUrl += "&sensor=false";

        var customUrl = 1;
		// URL, DATATYPE, QUERYTYPE, CALLBACK
		this.pullApiData(baseGeocodeUrl, "JSON", "GET", window.UI.updateMarkerAddStreetAddr, customUrl);

	}

	ApiConnector.prototype.getLatLngFromStreet = function getStreetFromLatLng(streetAddr, pin, callback){
		var baseGeocodeUrl = "https://maps.googleapis.com/maps/api/geocode/json?address=";
		for(prop in streetAddr){
			prop = prop.replace(" ", "+");
			baseGeocodeUrl += prop + ",+"
		}

		baseGeocodeUrl = baseGeocodeUrl.substring(0, baseGeocodeUrl.length - 2);
		baseGeocodeUrl += "&sensor=false";
        var customUrl = 1;
		// URL, DATATYPE, QUERYTYPE, CALLBACK
		this.pullApiData(baseGeocodeUrl, "JSON", "GET", window.ApiConnector.buildNewPin, customUrl);

	}

	ApiConnector.prototype.buildNewPin = function buildNewPin(data){
		console.log("build new pin");
		console.log(data);
	}



	//Uploads all local database entries to the Server
	//Clears the local storage after upload
	ApiConnector.prototype.pushHeatmapData = function pushHeatmapData(){
		var heatmapURI = "/heatmap";
	    if(window.logging){
	        //server/addgriddata.php
	        var jsonArray = [];
	        console.log("Heatmap data to be pushed:")
	    	window.database.all(function(data){
	   			jsonArray.push(data[0].value);
			});

			console.log(jsonArray);
		}
	
		// zepto code
		$.ajax({
	    	type:'PUT',
	    	url: heatmapURI,
	    	dataType:"json",
	    	data:  JSON.stringify(jsonArray),
	    	failure: function(errMsg){
		      	// alert(errMsg);
	      		console.log("Failed to PUT heatmap: "+errMsg);
	    	}, 
	    	success: function(data){
		      	console.log("PUT heatmap success: "+data);
	       		// window.database.nuke();
	       		window.ApiConnector.pullHeatmapData();
	    	}
		});//Ajax	
	}

	

	// baseline testing
	ApiConnector.prototype.testObj = function testObj(){
		var URL = testurl;
		this.pullApiData(URL, "JSON", "GET", this.updateTest);
	}

	ApiConnector.prototype.googleClientLibLoaded = function googleClientLibLoaded(){
		alert("working");
	}

} // end ApiConnector class def