
var map, pointarray, heatmap, pickupMarkers, markerFlag;
var markerType = -1;
var markerEvent;
var HELP_TRASH = 1;
var TRASH_DROP = 2;
var COMMENT_LOC = 3;
var MOUSEDOWN_TIME;
var MOUSEUP_TIME;

            var heatmapData = [
                {location: new google.maps.LatLng(37.782, -122.447), weight: 0.5}, 
                {location: new google.maps.LatLng(37.782, -122.445), weight: 1},
                {location: new google.maps.LatLng(37.782, -122.443), weight: 2},
                {location: new google.maps.LatLng(37.782, -122.441), weight: 3},
                {location: new google.maps.LatLng(37.782, -122.439), weight: 2},
                {location: new google.maps.LatLng(37.782, -122.437), weight: 1},
                {location: new google.maps.LatLng(37.782, -122.435), weight: 0.5},
                {location: new google.maps.LatLng(37.785, -122.447), weight: 3},
                {location: new google.maps.LatLng(37.785, -122.445), weight: 2},
                {location: new google.maps.LatLng(37.785, -122.443), weight: 1},
                {location: new google.maps.LatLng(37.785, -122.441), weight: 0.5},
                {location: new google.maps.LatLng(37.785, -122.439), weight: 1},
                {location: new google.maps.LatLng(37.785, -122.437), weight: 2},
                {location: new google.maps.LatLng(37.785, -122.435), weight: 3}
            ];


            
function initialize() {

    var centerPoint = new google.maps.LatLng(37.774546, -122.433523); 
    var mapOptions = {
    zoom: 13,
    center: centerPoint,
    mapTypeId: google.maps.MapTypeId.SATELLITE
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
  pickupMarkers = [new google.maps.Marker({
      position: new google.maps.LatLng(37.785, -122.435),
      map: map,
      icon: pickupIcon
  })];
  pickupMarkers[0].setVisible(false);
  markerFlag = false;
}

function toggleHeatmap() {
  heatmap.setMap(heatmap.getMap() ? null : map);
}

function toggleIcons(){
    //if(markerFlag){
    //    pickupMarker.setVisible(false);
    //    markerFlag = false;
    //}else{
    //    pickupMarker.setVisible(true);
    //    markerFlag = true;
    //};
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
    info.setContent('<form method="GET" action="/server/communication.php"><input type="hidden" name="lat" value="'+marker.position.lat()+'"/><input type="hidden" name="lon" value="'+marker.position.lng()+'" /><input name="message" type="text"/><input type="hidden" name="topic" value="1" /><input type="hidden" name="add" /><input type="submit"  />');
    info.setPosition(marker.position);
    info.open(map);

    // var marker = new MarkerWithLabel({
    //    position: markerEvent.latLng,
    //    draggable: true,
    //    raiseOnDrag: true,
    //    map: map,
    //    labelContent: "$425K",
    //    labelAnchor: new google.maps.Point(22, 0),
    //    labelClass: "labels", // the CSS class for the label
    //    labelStyle: {opacity: 0.75}
    //  });
}

// add an icon to indicate where trash was found
function addTrashMarker(){
    var marker = new google.maps.Marker({
        position: markerEvent.latLng,
        map: map,
        icon: "img/icons/redCircle.png"
    });
    pickupMarkers.push(marker);
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

    $('#startButton').click(function(){
        start();
    });

    $('#stopButton').click(function(){
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
        addPickupMarker();
    });

    $('#selectComment').click(function(){
        $('#markerTypeDialog').toggle();
        addCommentMarker();
    });

    $('#selectTrash').click(function(){
        $('#markerTypeDialog').toggle();
        addTrashMarker();
    });


    $('#pr1').click(function(){
        $('#container').removeClass("panel1Center");
        $('#container').removeClass("panel3Center");
        $('#container').addClass("panel2Center");
    });
    $('#prr1').click(function(){
        $('#container').removeClass("panel1Center");
        $('#container').removeClass("panel2Center");
        $('#container').addClass("panel3Center");
    });

    $('#pr2').click(function(){
        $('#container').removeClass("panel1Center");
        $('#container').removeClass("panel2Center");
        $('#container').addClass("panel3Center");
    });

    $('#pl2').click(function(){
        $('#container').removeClass("panel3Center");
        $('#container').removeClass("panel2Center");
        $('#container').addClass("panel1Center");
    });

    $('#pl3').click(function(){
        $('#container').removeClass("panel3Center");
        $('#container').removeClass("panel1Center");
        $('#container').addClass("panel2Center");
    });

    $('#pll3').click(function(){
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