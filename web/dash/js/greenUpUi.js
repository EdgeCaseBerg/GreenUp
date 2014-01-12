// class for managing the UI
function UiHandle(){
	this.currentDisplay = 1;
	this.isMarkerDisplayVisible = false;
	this.MOUSEDOWN_TIME;
	this.MOUSEUP_TIME;
	this.isMarkerVisible = true;
	this.isMapLoaded = false;

	this.isAddMarkerDialogVisible = false

	this.scrollPosition = 0;

	this.isNavbarUp = true;
	this.isTopSliderUp = true;

	this.textInputIsVisible = false;

	this.isOptionsVisible = false;
	this.isCommentsSliderVisible = false;

	this.isClockRunning = false;
	this.clockHrs = 00;
	this.clockMins = 00;
	this.clockSecs = 00;

	this.commentPurpose = -1;
	this.MARKER = 1; 
	this.COMMENT = 0;

	// for comment pagination
	this.commentsType = ""
	this.commentsNextPageUrl = "";
	this.commentsPrevPageUrl = "";

    UiHandle.prototype.init = function init(){

    	$('#addMarkerCaneclButton').click(function(){
    		window.UI.toggleAddMarkerOptions();
    	});

 	   	$(".addressIconWrapper").click(function(){
 	   		$(this).parent().parent().addClass("addressedComment");
    	});

    	$(".navLink").click(function(){
    		$('.navLi').removeClass("active");
    		$(this).parent().addClass("active");
    	});

    	$('#navMapLink').click(function(){
    		$('.row').hide();
    		$('.mapAdminContainer').show();	
    	});
		
		$('#navCommentsLink').click(function(){
    		$('.row').hide();
    		$('.commentsAdminContainer').show();	
    	});

    	$('#infoIcon').click(function(){
    		if(window.UI.isOptionsVisible){
    			window.UI.toggleMapOptions(function(){
	    			$('#addMarkerDialog').hide();
	    			$('#analyticsDialog').show();
	    			window.UI.toggleMapOptions();
	    		});
    		}else{
    			if(window.UI.isCommentsSliderVisible){
    				window.UI.toggleCommentsSlider();
    			}
    			$('#addMarkerDialog').hide();
    			$('#analyticsDialog').show();
    			window.UI.toggleMapOptions();
    		}
    	});

    	$('#commentsIcon').click(function(){
    		if(window.UI.isCommentsSliderVisible){
    			window.UI.toggleCommentsSlider(function(){
	    			window.UI.toggleCommentsSlider();
	    		});
    		}else{
    			if(window.UI.isOptionsVisible){
    				window.UI.toggleMapOptions();
    			}
    			window.UI.toggleCommentsSlider();
    		}
    	});

    	$('.datePicker').datepicker({ dateFormat: "yy-mm-dd" });

    	$('#infoIcon').mouseenter(function(){
    		$(this).attr("src", "images/info-icon-light.png");	
    	});

    	$('#infoIcon').mouseleave(function(){
    		$(this).attr("src", "images/info-icon-dark.png");	
    	});

    	$('#commentsIcon').mouseenter(function(){
    		$(this).attr("src", "images/comment-icon-hover.png");	
    	});

    	$('#commentsIcon').mouseleave(function(){
    		$(this).attr("src", "images/comment-icon.png");	
    	});

    	$('#latLonSelect').click(function(){
    		$('.locationTypeInputContainer').slideUp().removeClass("visible");

    		if($('#coordsInputContainer').hasClass("visible")){
    			$('#coordsInputContainer').slideUp().removeClass("visible");

    		}else{
    			$('#coordsInputContainer').slideDown().addClass("visible");
    		}
    	});

    	$('#streetSelect').click(function(){
    		$('.locationTypeInputContainer').slideUp().removeClass("visible");

    		if($('#streetInputContainer').hasClass("visible")){
    			$('#streetInputContainer').slideUp().removeClass("visible");
    		}else{
    			$('#streetInputContainer').slideDown().addClass("visible");
    		}
    	});

    	$('#updateAnalyticsButton').click(function(){
    		queryCoreReportingApi(window.ANALYTICS_PROFILE, $('#startDateInput').val(), $('#endDateInput').val());
    	});
	} // end init

	UiHandle.prototype.drawVisualisation = function drawVisualization(pieData, lineData){	  	

        var lineOptions = {
        	backgroundColor: "#fff",
          	// legend: {position: 'none'},
          	hAxisTitle: "hour", 
          	height: 120
        };

        var lineChart = new google.visualization.LineChart(document.getElementById('usageDataLineChart'));
        lineChart.draw(lineData, lineOptions);

	  	var pieOptions = {
	  		backgroundColor: "#fff",
	  		height: 120,
	  		width: 120,
	  		legend: {position: 'none'}
	  	}
	  	var pieChart = new google.visualization.PieChart(document.getElementById('usageDataPieChart')).draw(pieData, pieOptions);

	  // });

	  // Create and draw the visualization.
	}

	UiHandle.prototype.toggleMapOptions = function toggleMapOptions(){
		if(window.UI.isOptionsVisible){
			window.UI.isOptionsVisible = false;
			$('#extendedAnalyticsDialog').css({"top":"-235px"});
			
			window.setTimeout(function(){
				$('.markerTypeSelectDialog').css({"top":"-200px"});	
			}, 100);
			
		}else{
			window.UI.isOptionsVisible = true;
			$('.markerTypeSelectDialog').css({"top":"35px"});
			setTimeout(function(){
				$('#extendedAnalyticsDialog').css({"top":"235px"});
			}, 100);	
			
		}
	}

	UiHandle.prototype.toggleCommentsSlider = function toggleCommentsSlider(){
		if(window.UI.isCommentsSliderVisible){
			window.UI.isCommentsSliderVisible = false;
			$('#commentsDialog').css({"right":"-530px"});
			
		}else{
			window.UI.isCommentsSliderVisible = true;
			$('#commentsDialog').css({"right":"-3px"});
			
		}
	}

	UiHandle.prototype.hideMarkerTypeSelect = function hideMarkerTypeSelect(){
		document.getElementById("markerTypeDialog").style.display = "none";
		window.UI.isMarkerDisplayVisible = false;
	}

	// shows the marker/comment type menu, and adds listeners to the buttons depending on their purpose
	UiHandle.prototype.showMarkerTypeSelect = function showMarkerTypeSelect(){
		console.log("marker");
		// add marker type selectors
		// alert("marker");
		document.getElementById("markerTypeDialog").className = "markerTypePanel2";
		document.getElementById("selectPickup").addEventListener('mousedown', function(){window.UI.markerTypeSelect("trash pickup")});
		document.getElementById("selectComment").addEventListener('mousedown', function(){window.UI.markerTypeSelect("general message")});
		document.getElementById("selectTrash").addEventListener('mousedown', function(){window.UI.markerTypeSelect("help needed")});
		
		document.getElementById("cancel").addEventListener('mousedown', function(){
	    	window.UI.hideMarkerTypeSelect();
	    });
		
		document.getElementById("markerTypeDialog").style.display = "block";
		window.UI.isMarkerDisplayVisible = true;
	}

	// called after the map has loaded, and hides the loading screen
	UiHandle.prototype.setMapLoaded = function setMapLoaded(){
		window.MAP.isMapLoaded = true;
	}


	// when the user chooses which type of marker to add to the map
	UiHandle.prototype.markerTypeSelect = function markerTypeSelect(markerType){
		console.log(markerType);
		// first we need to show the marker on the map
		// var iconUrl = "img/icons/blueCircle.png";
		var iconUrl = "";
		switch(markerType){
			case "forum":
				iconUrl = "images/icons/orangeCircle.png";
				break;
			case "trash pickup":
				iconUrl = "images/icons/blueCircle.png";
				break;
			case "help needed":
				iconUrl = "images/icons/greenCircle.png";
				break;
			default:
				iconUrl = "images/icons/orangeCircle.png";
				break;
		}

		window.MAP.markerType = markerType;

		// console.log(window.MAP.markerEvent);

		var marker = new google.maps.Marker({
        	position: new google.maps.LatLng(window.MAP.markerEvent.latLng.mb, window.MAP.markerEvent.latLng.nb),
        	map: window.MAP.map,
        	icon: iconUrl
    	});
		marker.setVisible(window.UI.isMarkerVisible);
    	window.MAP.pickupMarkers.push(marker);



		window.UI.hideMarkerTypeSelect();
		window.CURRENT_USER_INPUT_TYPE = INPUT_TYPE.MARKER;
		window.UI.showTextInput();
		// (bug) here we need to prevent more map touches
	}

	// track how long the user's finger was toucking to determine click while allowing map to be usable (touch-scroll)
	UiHandle.prototype.mapTouchDown = function mapTouchDown(event){
		// set the coords of the marker event
	
		    window.MAP.markerEvent = event;
		    this.MOUSEDOWN_TIME = new Date().getTime() / 1000;
	
	}

	// show the marker type select dialog
	UiHandle.prototype.mapTouchUp = function mapTouchUp(){
		// set the coords of the marker event
	    MOUSEUP_TIME = (new Date().getTime());
	    MOUSEUP_TIME = MOUSEUP_TIME / 1000;
	    // if it was a short touch
	    console.log((MOUSEUP_TIME - this.MOUSEDOWN_TIME));
	    if((MOUSEUP_TIME - this.MOUSEDOWN_TIME) < 0.5){
	    	// check if the marker select menu is showing and toggle appropriately	
	        this.MOUSEDOWN_TIME = 0;
	        this.MOUSEDOWN_TIME = 0;
	        window.UI.toggleAddMarkerOptions(window.MAP.markerEvent);
	    }else{


	        this.MOUSEDOWN_TIME = 0;
	        this.MOUSEDOWN_TIME = 0;
	    }
	}

	UiHandle.prototype.toggleAddMarkerOptions = function toggleAddMarkerOptions(point){
		if(window.UI.isAddMarkerDialogVisible){
			$('#addMarkerDashContainer').fadeOut(500);
			window.UI.isAddMarkerDialogVisible = false;
		}else{
			console.log(point);
			var lat = point.latLng.lat();
			var lng = point.latLng.lng();

			$('#markerLat').val(lat);
			$('#markerLng').val(lng);

			window.ApiConnector.getStreetFromLatLng(lat, lng)
			$('#addMarkerDashContainer').fadeIn(500);
			window.UI.isAddMarkerDialogVisible = true;

			var streetAddress = [];
			$('#addMarkerGoButton').click(function(){
				console.log("clicked");
				// collect the street address data from the form
				var streetAddr = { 
					"street" : $("input[name='streetAddress1']").val(),
					"city" : $("input[name='streetCity']").val(),
					"state": $("input[name='streetAddressState']").val()
				}

				var pin = new Pin();
				pin.latDegrees = $('#markerLat').val();
				pin.lonDegrees = $('#markerLng').val();
				pin.message = $('#markerTextarea').val();
				pin.type = "TRASH PICKUP";

				// we're using normal latlng for our pin
				if(pin.latDegrees.length > 1 && pin.lonDegrees.length >1 && pin.message.length >1){
					window.ApiConnector.pushNewPin(JSON.stringify(pin));
				}else{ // we're using a street address
					var fieldCount = 0;
					// check we've got the needed fields
					for(prop in streetAddr){
						if(prop.length > 0){
							fieldCount++;
						}
					}

					if(fieldCount > 2){
						console.log("new pin");
						var pin = new Pin();
						pin.message = $('#markerTextarea').val();
						window.streetAddr = streetAddr;
						window.ApiConnector.getLatLngFromStreet(streetAddr, pin, window.ApiConnector.buildNewPin);
					}
				}


				// streetAddr["number"] + "+"+
				// 		streetAddr["street"] + "+" +
				// 		streetAddr["streetType"] + ",+" +
				// 		streetAddr["city"] + ",+" +
				// 		streetAddr["state"]

				// window.ApiConnector.getLatLngFromStreet() 	

			
			});

			
		}
	}

	

	// ******* DOM updaters (callbacks for the ApiConnector pull methods) *********** 
	UiHandle.prototype.updateHeatmap = function updateHeatmap(data){
		console.log("Heatmap data returned from api, preparing to apply data to map.");
		window.MAP.applyHeatMap(data);
	}

	UiHandle.prototype.updateRawHeatmapData = function updateRawHeatmapData(data){
		console.log("raw heatmap data: ");
		console.log(data);
		var HELPER = new Helper();
		var totalSecondsWorked = new BigNumber(0);
		for(var ii=0; ii<data.grid.length; ii++){
			totalSecondsWorked = totalSecondsWorked.add(data.grid[ii].secondsWorked);
			console.log(ii + "-" + totalSecondsWorked);
		}

		// alert(data.grid[0].secondsWorked + " - " + data.grid[(data.grid.length - 1)].secondsWorked);

		var metersPerSecond = 0.25; // this is a guess
		var sqMeters = (totalSecondsWorked * metersPerSecond);
		var acresWorked = HELPER.metersToAcres(sqMeters);
		// alert(acresWorked.toFixed(3));
		var timeWorked = HELPER.secondsToHoursMinutesSeconds(totalSecondsWorked);
		$('#acresWorked').html(acresWorked.toFixed(4));
		$('#totalHoursWorked').html(timeWorked['hours']);
		$('#totalMinutesWorked').html(timeWorked['minutes']);
		$('#totalSecondsWorked').html(timeWorked['seconds']);
		$('#totalDaysWorked').html(timeWorked['days']);
	}

	// markers coming from the apiconnector comes here to be added to the UI
	UiHandle.prototype.updateMarker = function updateMarker(data){
		console.log("marker response: ");
		console.log(data);

		window.PINS = [];
		window.PINS = data.pins;
		// var dataArr = JSON.parse(data);
		var dataArr = data;
        for(ii=0; ii<dataArr.pins.length; ii++){
            window.MAP.addMarkerFromApi(dataArr.pins[ii].type, dataArr.pins[ii].message, dataArr.pins[ii].latDegrees, dataArr.pins[ii].lonDegrees);
        }

	}

	// data is passed from the api connector to here to update the forum.
	UiHandle.prototype.updateForum = function updateForum(data){
		document.getElementById("bubbleContainer").innerHTML = "";
		console.log("In Update forum");
		// console.log("Comment data: "+data);
		// document.getElementById("bubbleContainer").innerHTML = "";
		console.log(data);
		window.COMMENTS = data;
		dataObj = data;
		// var dataObj = JSON.parse(data);
		var comments = dataObj.comments;
		// window.UI.commentsPrevPageUrl = dataObj.page.previous;
		// window.UI.commentsNextPageUrl = dataObj.page.next;
		if(dataObj.page.next != null){
			var nextArr = dataObj.page.next.split("greenupapp.appspot.com/api");
			window.UI.commentsNextPageUrl = window.ApiConnector.BASE+"/"+nextArr[1];
		}else{
			window.UI.commentsNextPageUrl = null;
		}
		if(dataObj.page.previous != null){
			var prevArr = dataObj.page.previous.split("greenupapp.appspot.com/api");
			window.UI.commentsPrevPageUrl = window.ApiConnector.BASE+"/"+prevArr[1];
		}else{
			window.UI.commentsPrevPageUrl = null;
		}

		console.log("comments: ");
		console.log(comments);

		for(var ii=0; ii<comments.length; ii++){

				var div = document.createElement("div");
				var controlDiv = document.createElement("div");
				var commentNest = document.createElement("div");

				controlDiv.className = "bubbleControls";

				controlDiv.innerHTML = '<div class="iconWrapper closeIconWrapper"><img title="Delete Comment" src="images/icons/Cross.png"></div>';
				controlDiv.innerHTML += '<div class="iconWrapper addressIconWrapper"><img title="Address Comment" src="images/icons/Tick.png"></div>';

				if(comments[ii].pin != "0"){
					controlDiv.innerHTML += '<div class="iconWrapper gotoIconWrapper"><img title="Go To Pin" src="images/icons/Flag.png"></div>';
				}



				commentNest.className = "commentTextNest";

				var timeDiv = document.createElement("div");
				var pinIdHolder = document.createElement("input");
				var commentIdHolder = document.createElement("input");
				pinIdHolder.type = "hidden";
				pinIdHolder.className = "pinIdHolder";
				pinIdHolder.value = comments[ii].pin;
				commentIdHolder.type = "hidden";
				commentIdHolder.className = "commentIdHolder";
				commentIdHolder.value = comments[ii].id;
				
				var messageContent = document.createElement("span");
				var currentDate = new Date();
				var timezoneOffsetMillis = currentDate.getTimezoneOffset()*60*1000;
				var messageDate = new Date(comments[ii]['timestamp']);
				var diffMins = Math.round((((timezoneOffsetMillis + currentDate.getTime()) - messageDate.getTime())/1000)/60);
				if(diffMins > 59){
					var mins = (diffMins % 60);
					var timeSinceMessage = ((diffMins - mins)/60)+"hrs, "+mins+"mins ago"; 
				}else{
					var timeSinceMessage = diffMins+"mins ago"; 
				}
				
				messageContent.innerHTML = comments[ii]['message'];
				timeDiv.innerHTML = timeSinceMessage;
				timeDiv.className = "bubbleTime";



				if(ii % 2 == 0){
					div.className = "bubbleRight bubble"; 
				}else{
					div.className = "bubbleLeft bubble";
				}

				switch(comments[ii]['type']){
					case 'FORUM':
						div.className += " bubbleForum";
					break;
					case 'TRASH PICKUP':
						div.className += " bubbleNeeds";
					break;
					case 'GENERAL MESSAGE':
						div.className += " bubbleMessage";
					break;
					default:
						div.className += " bubbleForum";
					break;
				}

				div.appendChild(pinIdHolder);
				div.appendChild(commentIdHolder);
				div.appendChild(controlDiv);
				
				commentNest.appendChild(messageContent);
				div.appendChild(commentNest);
				div.appendChild(timeDiv);
				
				document.getElementById("bubbleContainer").appendChild(div);

		}

		$('.commentTextNest').mouseenter(function(){
			$(this).parent().css({"border" : "solid 2px red"});
		});

		$('.commentTextNest').mouseleave(function(){
			$(this).parent().css({"border" : "solid 2px #333"});
		});

		$('.gotoIconWrapper').click(function(){
			var pinId = $(this).parent().parent().find(".pinIdHolder").val();
			for(var ii=0; ii<window.PINS.length; ii++){
				if(window.PINS[ii].id == pinId){
					var centerPoint = new google.maps.LatLng(window.PINS[ii].latDegrees, window.PINS[ii].lonDegrees); 	
					window.MAP.map.setCenter(centerPoint);
					window.MAP.map.setZoom(20);
				}
			}
			// console.log(pinId);
		});

		$('.closeIconWrapper').click(function(){
			var commentId = $(this).parent().parent().find(".commentIdHolder").val();
			// alert(commentId);
			$(this).parent().parent().fadeOut();
		});

		$('.addressIconWrapper').click(function(){
			var commentId = $(this).parent().parent().find(".commentIdHolder").val();
			// alert(commentId);
		});
	}

	UiHandle.prototype.updateMarkerAddStreetAddr = function updateMarkerAddStreetAddr(data){
		console.log("geocode data");
		console.log(data);
	}


	// updates the clock over time
	UiHandle.prototype.updateClock = function updateClock(){
		if(window.UI.clockSecs == 59){
			window.UI.clockSecs = 00;
			if(window.UI.clockMins == 59){
				window.UI.clockMins = 00;
				window.UI.clockHrs++;
			}else{
				window.UI.clockMins++;
			}
		}else{
			window.UI.clockSecs++;
		}
		var clockSecStr = (window.UI.clockSecs < 10) ? "0"+window.UI.clockSecs : window.UI.clockSecs;
		var clockMinStr = (window.UI.clockMins < 10) ? "0"+window.UI.clockMins : window.UI.clockMins;
		var clockHrStr = (window.UI.clockHrs < 10) ? "0"+window.UI.clockHrs : window.UI.clockHrs;
		
		document.getElementById("timeSpentClockDigits").innerHTML = clockHrStr + ":" + clockMinStr + ":" + clockSecStr;
	}
	// ******** End DOM Updaters *********

	// ---- begin COMMENT pagination control toggle ----
	UiHandle.prototype.showNextCommentsButton = function showNextCommentsButton(){
		document.getElementById("nextPage").style.display = "inline-block";
	}

	UiHandle.prototype.hideNextCommentsButton = function hideNextCommentsButton(){
		document.getElementById("nextPage").style.display = "none";
	}

	UiHandle.prototype.showPrevCommentsButton = function showPrevCommentsButton(){
		document.getElementById("prevPage").style.display = "inline-block";
	}

	UiHandle.prototype.hidePrevCommentsButton = function hidePrevCommentsButton(){
		document.getElementById("prevPage").style.display = "none";
	}
	// ---- end COMMENT pagination control toggle


	// mock callback function for logging data that would ordinarily hit one of the UI updates
	UiHandle.prototype.updateTest = function updateTest(data){
		console.log(data);
	}

} // end UiHandle class def