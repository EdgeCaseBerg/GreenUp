
var map, pointarray, heatmap, pickupMarkers, markerFlag;
var markerType = -1;
var markerEvent;
var HELP_TRASH = 1;
var TRASH_DROP = 2;
var COMMENT_LOC = 3;
var MOUSEDOWN_TIME;
var MOUSEUP_TIME;


pickupMarkers = [];


// we should be supplying the 4 lat/lons to frame the map and only download what we need
// gets heatmap data and formats it for initHeatMap() 
function getHeatmapData(){
    var heatmapData = [];
    var query = "/server/getHeatmapPoints.php";
    // $.getJSON(query, function(data) {
    //    var dataArr = data[0].split(",");
    //     heatmapData.push({location: new google.maps.LatLng(parseFloat(dataArr[0]), parseFloat(dataArr[1])), weight: parseInt(dataArr[2])});
    // });
    Lib.ajax.getJSON({
        url:"/server/getHeatmapPoints.php",
        type: 'json'
        }function(points){
            heatmapData.push({location: new google.maps.LatLng(parseFloat(dataArr[0]), parseFloat(dataArr[1])), weight: parseInt(dataArr[2])});
        }
    });
    return heatmapData;
} // end getHeatmapData

// @argument heatData = array returned by getHeatMapData()
function initHeatMap(heatData){
  var pointArray = new google.maps.MVCArray(heatData);
  heatmap = new google.maps.visualization.HeatmapLayer({
    data: pointArray,
    dissipating: true, 
    radius: 5
  });

  heatmap.setMap(null);
}

 // Lib.ajax.getJSON({
 //        url: 'https://api.twitter.com/1/statuses/user_timeline.json?&screen_name=gabromanato&callback=?&count=1',
 //        type: 'jsonp'
 //    }, function(tweet) {
 //        document.querySelector('#tweet').innerHTML = tweet[0].text;
 //    });

// fire up our google map
function initMap(centerpointLat, centerpointLon, zoom){
    // define the initial location of our map
    centerPoint = new google.maps.LatLng(centerpointLat, centerpointLon); 
    var mapOptions = {
    zoom: zoom,
    center: centerPoint,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions);
  google.maps.event.addListener(map, 'mousedown', markerSelectDown);
  google.maps.event.addListener(map, 'mouseup', markerSelectUp);

}

function initIcons(){
    var pickupIcon = "img/icons/greenCircle.png";
    pickupMarkers = [];

  $.getJSON("/server/getPointsOfInterest.php", function(data) {
       for (var i = data.length - 1; i >= 0; i--) {
           var types = [null, "img/icons/blueCircle.png" ,"img/icons/redCircle.png" ,"img/icons/greenCircle.png" ];
           var marker =  new google.maps.Marker({position: new google.maps.LatLng(data[i].lat,data[i].lon), 
                                                map: map, 
                                                icon: types[data[i].fkType]
                                            });

           pickupMarkers.push(marker);
       };
       for (var i = pickupMarkers.length - 1; i >= 0; i--) {
            pickupMarkers[i].setVisible(false);
            //Add a custom field to the markers so we can have the information that goes in the infobox
            pickupMarkers[i].messageData = data[i].message;

            google.maps.event.addListener(pickupMarkers[i], "click", function () {
                var info = new google.maps.InfoWindow();
                info.setContent(this.messageData);
                info.setPosition(this.position);
                info.open(map);
                
            });
        }
    });

    

    markerFlag = false;
}

function toggleHeatmap() {
    // var query = "http://ec2-54-214-91-160.us-west-2.compute.amazonaws.com/server/getHeatmapPoints.php";
    // $.getJSON(query, function(data) {
    //    var dataArr = data[0].split(",");
    //     heatmapData.push({location: new google.maps.LatLng(parseFloat(dataArr[0]), parseFloat(dataArr[1])), weight: parseInt(dataArr[2])});
    // });
    heatmap.setMap(heatmap.getMap() ? null : map);
}

function toggleIcons(){
    var newState;
    if(markerFlag){
        newState = false;
        markerFlag = false;
    }else{
        newState = true;
        markerFlag = true;
    }
    for (var i = 0; i < pickupMarkers.length; i++){
        pickupMarkers[i].setVisible(newState);
    }
}

// add an icon for a pickup
function addPickupMarker(){
    var marker = new google.maps.Marker({
        position: markerEvent.latLng,
        map: map,
        icon: "img/icons/greenCircle.png"
    });
    pickupMarkers.push(marker);

    var info = new google.maps.InfoWindow();
    info.setContent('<form id="hook" class="infowindow pickup" method="GET" action="/server/communication.php"><input type="hidden" name="lat" value="'+marker.position.lat()+'"/><input type="hidden" name="lon" value="'+marker.position.lng()+'" /><textarea name="message"/></textarea><input type="hidden" name="topic" value="3" /><input type="hidden" name="add" /><input type="submit"  onmousedown="showToggleContainer" />');
    info.setPosition(marker.position);
    info.open(map);
}

// add an icon for a Comment location
function addCommentMarker(){
    var marker = new google.maps.Marker({
        position: markerEvent.latLng,
        map: map,
        icon: "img/icons/blueCircle.png"
    });
    pickupMarkers.push(marker);

    var info = new google.maps.InfoWindow();
    info.setContent('<form id="hook" class="infowindow comment" method="GET" action="/server/communication.php"><input type="hidden" name="lat" value="'+marker.position.lat()+'"/><input type="hidden" name="lon" value="'+marker.position.lng()+'" /><textarea name="message"/></textarea><input type="hidden" name="topic" value="1" /><input type="hidden" name="add" /><input type="submit"  onmousedown="showToggleContainer" />');
    info.setPosition(marker.position);
    info.open(map);
}

// add an icon to indicate where trash was found
function addTrashMarker(){
    var marker = new google.maps.Marker({
        position: markerEvent.latLng,
        map: map,
        icon: "img/icons/redCircle.png"
    });
    pickupMarkers.push(marker);

    //corresponds to the help needed
    var info = new google.maps.InfoWindow();
    info.setContent('<form id="hook" class="infowindow helpme" method="GET" action="/server/communication.php"><input type="hidden" name="lat" value="'+marker.position.lat()+'"/><input type="hidden" name="lon" value="'+marker.position.lng()+'" /><textarea name="message"/></textarea><input type="hidden" name="topic" value="2" /><input type="hidden" name="add" /><input type="submit"  onmousedown="showToggleContainer" />');
    info.setPosition(marker.position);
    info.open(map);
}

function showToggleContainer(){
    $('.toggleContainer').show();
}

function markerSelectUp(event){
    markerEvent = event;
    MOUSEUP_TIME = new Date().getTime() / 1000;
    if((MOUSEUP_TIME - MOUSEDOWN_TIME) < 0.3){
        // alert((MOUSEUP_TIME - MOUSEDOWN_TIME));
        $('#markerTypeDialog').toggle();
        MOUSEDOWN_TIME =0;
        MOUSEDOWN_TIME =0;
    }else{
        MOUSEDOWN_TIME =0;
        MOUSEDOWN_TIME =0;
    }
}

// native javascript version of $.getJSON
// http://gabrieleromanato.name/javascript-implementing-getjson-from-scratch/
(function() {
    var Lib = {
        ajax: {
            xhr: function() {
                var instance = new XMLHttpRequest();
                return instance;
            },
            getJSON: function(options, callback) {
                var xhttp = this.xhr();
                options.url = options.url || location.href;
                options.data = options.data || null;
                callback = callback ||
                function() {};
                options.type = options.type || 'json';
                var url = options.url;
                if (options.type == 'jsonp') {
                    window.jsonCallback = callback;
                    var $url = url.replace('callback=?', 'callback=jsonCallback');
                    var script = document.createElement('script');
                    script.src = $url;
                    document.body.appendChild(script);
                }
                xhttp.open('GET', options.url, true);
                xhttp.send(options.data);
                xhttp.onreadystatechange = function() {
                    if (xhttp.status == 200 && xhttp.readyState == 4) {
                        callback(xhttp.responseText);
                    }
                };
            }
        }
    };

    window.Lib = Lib;
})()


   

function markerSelectDown(event){
    markerEvent = event;
    MOUSEDOWN_TIME = new Date().getTime() / 1000;
    // if((MOUSEUP_TIME - MOUSEDOWN_TIME) < 2){
    //     $('#markerTypeDialog').toggle();
    //     MOUSEDOWN_TIME =0;
    //     MOUSEDOWN_TIME =0;
    // }else{
    //     MOUSEDOWN_TIME =0;
    //     MOUSEDOWN_TIME =0;
    // }
}


function changeRadius() {
  heatmap.setOptions({radius: heatmap.get('radius') ? null : 20});
}

function changeOpacity() {
  heatmap.setOptions({opacity: heatmap.get('opacity') ? null : 0.2});
}

function initialize() {
    var heatmapData = getHeatmapData();
    // initMap(lat, lon, zoom)
    initMap(37.774546, -122.433523, 17);
    initHeatMap(heatmapData);
} // end initialize

google.maps.event.addDomListener(window, 'load', initialize);
google.maps.event.addDomListener(window, 'load', initIcons);

$(document).ready(function(){
    // takes care of the horizontal scrolling on swipe
    $(document).bind("touchmove",function(e){
        e.preventDefault();
    });
    
    $('.scrollable').bind("touchmove",function(e){
        e.stopPropagation();
    });
    
    $('#mapInit').mousedown(function(){
        $('.mapDecoyContainer').hide(function(){
            $('.mapContainer').show();
        });
    });

    $('#startButton').mousedown(function(){
        start();
    });

    $('#stopButton').mousedown(function(){
        stop();
    });
    // loadScript();
    $('#toggleHeat').click(function(){
        toggleHeatmap();
    });
    $('#toggleIcons').click(function(){
        toggleIcons();
    });

    $('#selectPickup').click(function(){
        $('#markerTypeDialog').toggle();
        $('.toggleContainer').hide();
        addPickupMarker();
    });

    $('#selectComment').click(function(){
        $('#markerTypeDialog').toggle();
        $('.toggleContainer').hide();
        addCommentMarker();
    });

    $('#selectTrash').click(function(){
        $('#markerTypeDialog').toggle();
        $('.toggleContainer').hide();
        addTrashMarker();
    });


    $('#pr1').mousedown(function(){
        $('#container').removeClass("panel1Center");
        $('#container').removeClass("panel3Center");
        $('#container').addClass("panel2Center");
    });
    $('#prr1').mousedown(function(){
        $('#container').removeClass("panel1Center");
        $('#container').removeClass("panel2Center");
        $('#container').addClass("panel3Center");
    });

    $('#pr2').mousedown(function(){
        $('#container').removeClass("panel1Center");
        $('#container').removeClass("panel2Center");
        $('#container').addClass("panel3Center");
    });

    $('#pl2').mousedown(function(){
        $('#container').removeClass("panel3Center");
        $('#container').removeClass("panel2Center");
        $('#container').addClass("panel1Center");
    });

    $('#pl3').mousedown(function(){
        $('#container').removeClass("panel3Center");
        $('#container').removeClass("panel1Center");
        $('#container').addClass("panel2Center");
    });

    $('#pll3').mousedown(function(){
        $('#container').removeClass("panel3Center");
        $('#container').removeClass("panel2Center");
        $('#container').addClass("panel1Center");
    });


    //Get the parameters in the get url and expose them
    var prmstr = window.location.search.substr(1);
    var prmarr = prmstr.split ("&");
    var params = {};

    for ( var i = 0; i < prmarr.length; i++) {
        var tmparr = prmarr[i].split("=");
        params[tmparr[0]] = tmparr[1];
    }

    //Check the param and look for pane
    if(params.pane != "undefined"){
        switch(params.pane){
            case "2":
                    $('#container').removeClass('panel1Center');
                    $('#container').removeClass('panel2Center');
                    $('#container').removeClass('panel2Center');
                    $('#container').addClass('panel2Center');
                break;
            case "3":
                    $('#container').removeClass('panel1Center');
                    $('#container').removeClass('panel2Center');
                    $('#container').removeClass('panel2Center');
                    $('#container').addClass('panel3Center');
                break;
        }
    }


    // $('#map-canvas').mousedown(function(){
    //     MOUSEDOWN_TIME = new Date().getTime() / 1000;
    // });
    // $('#map-canvas').mouseup(function(){
    //     MOUSEUP_TIME = new Date().getTime() / 1000;
    // });
});
