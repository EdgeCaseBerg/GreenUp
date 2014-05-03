// class for managing all Map work
function MapHandle(){
    // BTV coords
    this.currentLat = 44.476621500000000;
    this.currentLon = -73.209998100000000;
    this.currentZoom = 10;
    this.markerEvent;
    this.markerType;
    this.map;
    this.pickupMarkers = [];
    this.isHeatmapVisible = true;

    // fire up our google map
    MapHandle.prototype.initMap = function initMap(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        // define the initial location of our map
        // centerPoint = new google.maps.LatLng(window.MAP.currentLat, window.MAP.currentLon);
        centerPoint = new google.maps.LatLng(this.currentLat, this.currentLon);
        var mapOptions = {
            center: centerPoint,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            panControl: false,
            mapTypeControl: true,
            mapTypeControlOptions: {
                position: google.maps.ControlPosition.TOP_CENTER,
                style: google.maps.MapTypeControlStyle.DEFAULT
            },
            zoomControl: true,
            zoomControlOptions: {
                style: google.maps.ZoomControlStyle.LARGE,
                position: google.maps.ControlPosition.LEFT_CENTER
            },
            zoom: window.MAP.currentZoom,
            streetViewControl: false
        };

        // instanciate our map
        window.MAP.map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions);
        // get our bounds and set our map as loaded
        google.maps.event.addListener(window.MAP.map, 'idle', function(ev){
            window.UI.setMapLoaded
            window.MAP.updateBounds();
        });

        $('#toggleHeatmap').click(function(){
            window.MAP.toggleHeatmap();
        });

        $('#toggleMarkers').click(function(){
           window.MAP.toggleIcons();
        });

        $('#toggleHybrid').click(function(){
            if(!window.MAP.isHeatmapVisible){
                window.MAP.toggleHeatmap();
            }

            if(!window.UI.isMarkerVisible){
                window.MAP.toggleIcons();
            }

        });

        // google.maps.event.addListener(window.MAP.map, 'mousedown', this.setMarkerEvent);
        google.maps.event.addListener(window.MAP.map, 'mousedown', window.UI.mapTouchDown);
        google.maps.event.addListener(window.MAP.map, 'mouseup', window.UI.mapTouchUp);
    }

    MapHandle.prototype.addMarkerFromUi = function addMarkerFromUi(message, lat, lon){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");

        var pin = new Pin();
        pin.message = message;
        pin.type = window.MAP.markerType;

        var iconUrl;
        switch(window.MAP.markerType){
            case "general message":
                pin.type = "general message";
                iconUrl = "images/icons/orangeCircle.png";
                break;
            case "help needed":
                pin.type = "help needed";
                iconUrl = "images/icons/blueCircle.png";
                break;
            case "trash pickup":
                pin.type = "trash pickup";
                iconUrl = "images/icons/new_trash1.png";
                break;
            default:
                pin.type = "general message";
                iconUrl = "icons/blueCircle.png";
                break;
        }

        var eventLatLng = window.MAP.markerEvent;
        pin.latDegrees = eventLatLng.latLng.lat();
        pin.lonDegrees = eventLatLng.latLng.lng();

        var marker = new google.maps.Marker({
            position: new google.maps.LatLng(pin.latDegrees, pin.lonDegrees),
            map: window.MAP.map,
            icon: iconUrl,
            title: message
        });

        google.maps.event.addListener(marker, 'click', function() {
            window.MAP.map.setZoom(20);
            window.MAP.map.setCenter(marker.getPosition());
        });

        marker.setVisible(window.UI.isMarkerVisible);
        window.MAP.pickupMarkers.push(marker);

        var serializedPin = JSON.stringify(pin);
        window.ApiConnector.pushNewPin(serializedPin);
    }

    MapHandle.prototype.applyHeatMap = function applyHeatMap(data){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        var dataObj = data;
        for(var ii=0; ii<dataObj.grid.length; ii++){
            window.heatmapData.push(
                new google.maps.LatLng( dataObj.grid[ii].latDegrees, dataObj.grid[ii].lonDegrees)
            )
        }


        if(window.heatmapData.length > 0 && window.IS_HM_LOADED){
            console.log("num heatmap points: "+window.heatmapData.length);
            var POINT_ARR = new google.maps.MVCArray(window.heatmapData);
            window.MAP.heatmap = new google.maps.visualization.HeatmapLayer({
                data: POINT_ARR,
                dissipating: true,
                opacity: 0.99,
                radius: 5
            });

            if(window.IS_HM_LOADED){
                console.log("hm loaded - applying");
                window.MAP.heatmap.setMap(window.MAP.map);
            }else{
                console.log("hm not loaded - unable to apply");
            }
        }
    }

    MapHandle.prototype.addMarkerFromApi = function addMarkerFromApi(markerType, message, lat, lon){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        var pin = new Pin();
        pin.message = message;
        pin.type = markerType;
        pin.latDegrees = lat;
        pin.lonDegrees = lon;

        var iconUrl;
        switch(markerType){
            case "HAZARD":
                pin.type = "HAZARD";
                iconUrl = "images/icons/hazardMarker.png";
                break;
            case "ADMIN":
                pin.type = "ADMIN";
                iconUrl = "images/icons/trashMarker.png";
                break;
            default:
                pin.type = "MARKER";
                iconUrl = "images/icons/marker.png";
                break;
        }

        var marker = new google.maps.Marker({
            position: new google.maps.LatLng(pin.latDegrees, pin.lonDegrees),
            map: window.MAP.map,
            icon: iconUrl,
            title: message
        });

        google.maps.event.addListener(marker, 'click', function() {
            window.MAP.map.setZoom(20);
            window.MAP.map.setCenter(marker.getPosition());
        });

        marker.setVisible(window.UI.isMarkerVisible);
        window.MAP.pickupMarkers.push(marker);
    }

    MapHandle.prototype.updateMap = function updateMap(lat, lon, z){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        window.UI.isMapLoaded = false;
        var newcenter = new google.maps.LatLng(lat, lon);
        window.MAP.map.panTo(newcenter);
        window.MAP.map.setZoom(z);

    }
    MapHandle.prototype.updateBounds = function updateBounds(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        window.MAP.bounds = window.MAP.map.getBounds();
        window.MAP.bounds_ne = window.MAP.bounds.getNorthEast(); // LatLng of the north-east corner
        window.MAP.bounds_sw = window.MAP.bounds.getSouthWest(); // LatLng of the south-west corder
        window.MAP.bounds_nw = new google.maps.LatLng(window.MAP.bounds_ne.lat(), window.MAP.bounds_sw.lng());
        window.MAP.bounds_se = new google.maps.LatLng(window.MAP.bounds_sw.lat(), window.MAP.bounds_ne.lng());
    }

    MapHandle.prototype.toggleIcons = function toggleIcons(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        if(window.UI.isMarkerVisible){
            window.UI.isMarkerVisible = false;
        }else{
            window.UI.isMarkerVisible = true;
        }
        for(var ii=0; ii<window.MAP.pickupMarkers.length; ii++){
            window.MAP.pickupMarkers[ii].setVisible(window.UI.isMarkerVisible);
        }
    }

    MapHandle.prototype.toggleHeatmap = function toggleHeatmap(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        if(window.HELPER.isNull(window.MAP.heatmap)){
            return false;
        }

        if(window.MAP.isHeatmapVisible){
            window.MAP.heatmap.setMap(null);
            window.MAP.isHeatmapVisible = false;
        }else{
            window.MAP.heatmap.setMap(window.MAP.map);
            window.MAP.isHeatmapVisible = true ;
        }
    }

    MapHandle.prototype.setCurrentLat = function setCurrentLat(CurrentLat){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        this.currentLat = CurrentLat;
    }

    MapHandle.prototype.setCurrentLon = function setCurrentLon(CurrentLon){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        this.currentLon = CurrentLon;
    }

    MapHandle.prototype.setCurrentZoom = function setCurrentZoom(CurrentZoom){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        this.currentZoom = CurrentZoom;
    }

    MapHandle.prototype.setMarkerEvent = function setMarkerEvent(event){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        this.markerEvent = event;
    }

    MapHandle.prototype.getCurrentLat = function getCurrentLat(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        return currentLat;
    }

    MapHandle.prototype.getCurrentLon = function getCurrentLon(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        return this.currentLon;
    }

    MapHandle.prototype.getCurrentZoom = function getCurrentZoom(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        return this.currentZoom;
    }

} //end MapHandle