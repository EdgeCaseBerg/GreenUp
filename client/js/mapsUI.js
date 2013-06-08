
var map, pointarray, heatmap, pickupMarkers, markerFlag;
var markerType = -1;
var markerEvent;
var HELP_TRASH = 1;
var TRASH_DROP = 2;
var COMMENT_LOC = 3;
var MOUSEDOWN_TIME;
var MOUSEUP_TIME;

var heatmapData = [];


            
function initialize() {
    var query = "/server/getHeatmapPoints.php";
    $.getJSON(query, function(data) {
	   var dataArr = data[0].split(",");
        heatmapData.push({location: new google.maps.LatLng(parseFloat(dataArr[0]), parseFloat(dataArr[1])), weight: parseInt(dataArr[2])});
    });

    centerPoint = new google.maps.LatLng(37.774546, -122.433523); 
    var mapOptions = {
    zoom: 17,
    center: centerPoint,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions);

  var pointArray = new google.maps.MVCArray(heatmapData);

  heatmap = new google.maps.visualization.HeatmapLayer({
    data: pointArray,
    dissipating: true, 
    radius: 5
  });

  heatmap.setMap(null);
  
  google.maps.event.addListener(map, 'mousedown', markerSelectDown);
  google.maps.event.addListener(map, 'mouseup', markerSelectUp);
} // end initialize

function initIcons(){
var pickupIcon = "img/icons/greenCircle.png";
  pickupMarkers = [];

  $.getJSON("/server/getPointsOfInterest.php", function(data) {
       for (var i = data.length - 1; i >= 0; i--) {
           var types = [null, "img/icons/blueCircle.png" ,"img/icons/redCircle.png" ,"img/icons/greenCircle.png" ];
           pickupMarkers.push( new google.maps.Marker({position: new google.maps.LatLng(data[i].lat,data[i].lon), map: map, icon: types[data[i].fkType]}));
       };
    });


  pickupMarkers[0].setVisible(false);
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

google.maps.event.addDomListener(window, 'load', initialize);
google.maps.event.addDomListener(window, 'load', initIcons);

$(document).ready(function(){
    $(document).bind("touchmove",function(e){
        e.preventDefault();
    });
    
    $('.scrollable').bind("touchmove",function(e){
        e.stopPropagation();
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
