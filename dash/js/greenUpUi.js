// class for managing the UI
function UiHandle(){
    this.currentDisplay = 1;
    this.isMarkerDisplayVisible = false;
    this.MOUSEDOWN_TIME;
    this.MOUSEUP_TIME;
    this.isMarkerVisible = true;
    this.isMapLoaded = false;
    window.IS_HM_LOADED = false;

    this.isAddMarkerDialogVisible = false

    this.scrollPosition = 0;

    this.isNavbarUp = true;
    this.isTopSliderUp = true;

    this.textInputIsVisible = false;

    this.isOptionsVisible = false;
    this.isCommentsSliderVisible = false;
    this.isLogSliderVisible = false;

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
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");

        $('#viewLogButton').click(function(){
            window.UI.toggleLogSlider();
        });

        $('#addMarkerCaneclButton').click(function(){
            window.UI.toggleAddMarkerOptions();
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

        $('#updateAnalyticsButton').click(function(){
            queryCoreReportingApi(window.ANALYTICS_PROFILE, $('#startDateInput').val(), $('#endDateInput').val());
        });
    } // end init

    // for writing google charts
    /*
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
    */

    UiHandle.prototype.toggleMapOptions = function toggleMapOptions(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
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
                $('#extendedAnalyticsDialog').css({"top":"15px"});
            }, 100);

        }
    }

    UiHandle.prototype.updateLogContent = function updateLogContent(data){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        window.LOGGER.obj(data, arguments.callee.name, null);
        $('#logNest').html("");
        $('#logPageNo').html("Page: <b>"+data.page.index+"</b>");
        $('#prevLogPage').attr("data-var", data.page.previous);
        $('#nextLogPage').attr("data-var", data.page.next);
        $('#nextLogPage').click(function(){
            if(!window.HELPER.isNull($(this).attr("data-var"))){
                window.ApiConnector.pullServerLog(updateLogContent, $(this).data("var"));
            }
        });

        $('#prevLogPage').click(function(){
            if(!window.HELPER.isNull($(this).data("var"))){
                window.ApiConnector.pullServerLog(updateLogContent, $(this).data("var"));
            }
        });

        for(var ii=0; ii<data.messages.length; ii++){
            if(data.messages[ii].message.indexOf("AUTH") != -1){
                var str = "<div class='logBubble authBubble'>";
            }else if(data.messages[ii].message.indexOf("AUTH") != -1){
                var str = "<div class='logBubble errorBubble'>";
            }else{
                var str = "<div class='logBubble'>";
            }

            str += "<div class='logTime'>"+data.messages[ii].timestamp+"</div>";
            str += "<div class='logMessage'>"+data.messages[ii].message+"</div>";
            str += "</div>";
            $('#logNest').append(str);
        }
    }

    UiHandle.prototype.toggleLogSlider = function toggleLogSlider(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");

        if(window.UI.isLogSliderVisible){
            window.UI.isLogSliderVisible = false;
            $('#logDialog').tween({
                left:{
                    start: 0,
                    stop: -640,
                    time: 0,
                    duration: 1,
                    units: 'px',
                    effect: 'easeInOut',
                    onStop: function(){
                        $('#logDialog').hide();
                    }
                }
            });

            $.play();

        }else{
            $('#logDialog').show();
            window.UI.isLogSliderVisible = true;


            $('#logDialog').tween({
                left:{
                    start: -640,
                    stop: 0,
                    time: 0,
                    duration: 1,
                    units: 'px',
                    effect: 'easeInOut',
                    onStop: function(){
                        // do stuff
                    }
                }
            });

            $.play();
        }
    }

    UiHandle.prototype.toggleCommentsSlider = function toggleCommentsSlider(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");

        if(window.UI.isCommentsSliderVisible){
            window.UI.isCommentsSliderVisible = false;
            $('#commentsDialog').tween({
                right:{
                    start: 0,
                    stop: -530,
                    time: 0,
                    duration: 1,
                    units: 'px',
                    effect: 'easeInOut',
                    onStop: function(){
                        $('#commentsDialog').hide();
                    }
                }
            });

            $.play();

        }else{
            $('#commentsDialog').show();
            window.UI.isCommentsSliderVisible = true;
            $('#commentsDialog').tween({
                right:{
                    start: -530,
                    stop: -3,
                    time: 0,
                    duration: 1,
                    units: 'px',
                    effect: 'easeInOut',
                    onStop: function(){
                        // do stuff
                    }
                }
            });

            $.play();


        }
    }

    UiHandle.prototype.hideMarkerTypeSelect = function hideMarkerTypeSelect(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        document.getElementById("markerTypeDialog").style.display = "none";
        window.UI.isMarkerDisplayVisible = false;
    }

    // shows the marker/comment type menu, and adds listeners to the buttons depending on their purpose
    UiHandle.prototype.showMarkerTypeSelect = function showMarkerTypeSelect(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
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
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        window.MAP.isMapLoaded = true;
    }


    // when the user chooses which type of marker to add to the map
    UiHandle.prototype.markerTypeSelect = function markerTypeSelect(markerType){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
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
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        // set the coords of the marker event
        window.MAP.markerEvent = event;
        this.MOUSEDOWN_TIME = new Date().getTime() / 1000;

    }

    // show the marker type select dialog
    UiHandle.prototype.mapTouchUp = function mapTouchUp(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
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
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        if(window.UI.isAddMarkerDialogVisible){
            $('#addMarkerDashContainer').fadeOut(400, function(){
                window.UI.isAddMarkerDialogVisible = false;
                $('#markerTextarea').val("");
                $('#markerSelector .default').attr("selected", "selected");
            });
        }else{
            console.log("point:");
            console.log(point);
            var lat = point.latLng.lat();
            var lng = point.latLng.lng();
            // set our inputs
            $('#markerLat').val(lat);
            $('#markerLng').val(lng);

            $('#addMarkerDashContainer').fadeIn(400);
            window.UI.isAddMarkerDialogVisible = true;

            var streetAddress = [];
            var markerType = "MARKER";

            $('#markerSelector').change(function(){
                markerType = $('#markerSelector option:selected').data("var");
            });

            // we're submitting our form
            $('#addMarkerGoButton').click(function(){
                var pin = new Pin();
                pin.latDegrees = parseFloat($('#markerLat').val());
                pin.lonDegrees = parseFloat($('#markerLng').val());
                pin.message = $('#markerTextarea').val();
                pin.type = markerType;
                pin.addressed = false;

                if(!window.HELPER.isNull(pin.latDegrees) && !window.HELPER.isNull(pin.lonDegrees)){
                    window.ApiConnector.pushNewPin(JSON.stringify(pin));
                }else{
                    alert("You must include a latitude, longitude, and message for your marker");
                }
            });
        }
    }



    // ******* DOM updaters (callbacks for the ApiConnector pull methods) ***********
    UiHandle.prototype.updateHeatmap = function updateHeatmap(data){
        window.IS_HM_LOADED = false;
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        if(!window.HELPER.isNull(data.page.next) && data.page.next != "null" ){
            console.log("data.page.next not null: "+data.page.next);
            window.ApiConnector.pullHeatmapData(data.page.next);
        }else{
            window.IS_HM_LOADED = true;
        }
        window.MAP.applyHeatMap(data);
    }

    UiHandle.prototype.updateRawHeatmapData = function updateRawHeatmapData(data){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        window.IS_HM_LOADED = false;
        var HELPER = new Helper();

        if(!window.HELPER.isNull(data.grid)){
            for(var ii=0; ii<data.grid.length; ii++){
                window.totalSecondsWorked = window.totalSecondsWorked.add(data.grid[ii].secondsWorked);
            }
        }else{
            console.log("Data grid not found --> ");
            console.log(data);
        }

        var metersPerSecond = 0.25; // this is a guess
        window.sqMeters += (window.totalSecondsWorked * metersPerSecond);
        var acresWorked = HELPER.metersToAcres(window.sqMeters);
        // alert(acresWorked.toFixed(3));
        var timeWorked = HELPER.secondsToHoursMinutesSeconds(window.totalSecondsWorked);
        $('#acresWorked').html(acresWorked.toFixed(4));
        $('#totalHoursWorked').html(timeWorked['hours']);
        $('#totalMinutesWorked').html(timeWorked['minutes']);
        $('#totalSecondsWorked').html(timeWorked['seconds']);
        $('#totalDaysWorked').html(timeWorked['days']);

        if(!window.HELPER.isNull(data.page.next) && data.page.next != "null" ){
            console.log("data.page.next not null: "+data.page.next);
            window.ApiConnector.pullRawHeatmapData(data.page.next);
        }else{
            window.IS_HM_LOADED = true;
        }
    }

    // markers coming from the apiconnector comes here to be added to the UI
    UiHandle.prototype.updateMarker = function updateMarker(data){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");

        window.PINS = [];
        window.PINS = data.pins;
        // var dataArr = JSON.parse(data);
        var dataArr = data;
        for(ii=0; ii<dataArr.pins.length; ii++){
            window.MAP.addMarkerFromApi(dataArr.pins[ii].type, dataArr.pins[ii].message, dataArr.pins[ii].latDegrees, dataArr.pins[ii].lonDegrees);
        }

    }

    // data is passed from the api connector to here to update the forum.
    // !!!! all listeners for comments controls are in here, too
    // todo: refactor this
    UiHandle.prototype.updateForum = function updateForum(data){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        if(window.HELPER.isNull(document.getElementById("bubbleContainer"))){
            return false;
        }
        document.getElementById("bubbleContainer").innerHTML = "";
        window.COMMENTS = data;
        dataObj = data;

        window.LOGGER.obj(data, "updateForum", "data from update forum");

        var comments = dataObj.comments;
        if(!window.HELPER.isNull(dataObj.page) && !window.HELPER.isNull(dataObj.page.next)){
            var nextArr = dataObj.page.next.split("/api");
            window.UI.commentsNextPageUrl = nextArr[1];
            window.LOGGER.debug("url stored: "+window.UI.commentsNextPageUrl, "", "");
        }else{
            window.UI.commentsNextPageUrl = null;
        }
        if(!window.HELPER.isNull(dataObj.page) && !window.HELPER.isNull(dataObj.page.previous)){
            var prevArr = dataObj.page.previous.split("/api");
            window.UI.commentsPrevPageUrl = prevArr[1];
            window.LOGGER.debug("url stored: "+window.UI.commentsPrevPageUrl);

//            window.UI.commentsPrevPageUrl = dataObj.page.previous;
        }else{
            window.UI.commentsPrevPageUrl = null;
        }



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
                case 'HAZARD':
                    div.className += " bubbleHazard";
                    break;
                case 'MARKER':
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
                    window.MAP.map.setZoom(16);
                }
            }
        });

        $('.closeIconWrapper').click(function(){
            var commentId = $(this).parent().parent().find(".commentIdHolder").val();
            $(this).parent().parent().fadeOut();
            window.ApiConnector.deleteComment(commentId);
        });

        $('.addressIconWrapper').click(function(){
            var commentId = $(this).parent().parent().find(".commentIdHolder").val();
            // alert(commentId);
        });
    }



    // mock callback function for logging data that would ordinarily hit one of the UI updates
    UiHandle.prototype.updateTest = function updateTest(data){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
    }

} // end UiHandle class def