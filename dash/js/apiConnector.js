function ApiConnector(){
    var heatmapData = [];
    var markerData = [];
    var commentData = [];

    this.LOCALHOST = "http://localhost/green-web"
    this.PROXYBASE = "/proxy.php?url=";
    this.HOST = "http://greenup.xenonapps.com";
    this.PORT = ""
    this.PATH = "/api";

    this.TRUEBASE = "";


    if(window.HOST.indexOf("localhost") != -1 || window.HOST.indexOf("127.0.0.1") != -1){
        this.TRUEBASE = this.LOCALHOST+this.PROXYBASE+this.HOST+this.PATH;
    }else{
        this.TRUEBASE = this.HOST+this.PATH;
    }


    // api URLs have been moved into each of the functions using them as per issue 46

    ApiConnector.prototype.authenticateToken = function authenticateToken(user, token){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        jsonObj = {
            id : user,
            us : token
        };
        $.ajax({
            type: "POST",
            url: "../dash-auth/api/auth",
            dataType: "JSON",
            data: JSON.stringify(jsonObj),
            cache: false,
            success: function(data){
                return true;
            },
            error: function(xhr, errorType, error){
                console.log(xhr);
                return false;
            }
        });

    }

    // performs the ajax call to get our data
    ApiConnector.prototype.pullApiData = function pullApiData(URL, DATATYPE, QUERYTYPE, CALLBACK, USE_URL){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        if(!window.HELPER.isNull(USE_URL) && USE_URL == 1){
            // leave the URL alone
        }else{
            if(document.URL.indexOf("localhost") != -1 || document.URL.indexOf("127.0.0.1") != -1){
                URL = this.LOCALHOST+this.PROXYBASE+this.HOST+this.PORT+this.PATH+URL;
            }else{
                URL = this.HOST+this.PORT+this.PATH+URL;

            }
        }
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
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        var pinsURI = this.TRUEBASE+"/pins";
        $.ajax({
            type: "POST",
            url: pinsURI,
            data: jsonObj,
            cache: false,
            // processData: false,
            dataType: "json",
            contentType: "application/json",
            success: function(data){
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
                        window.LOGGER.error("api response = 500", arguments.callee.name);
                        break;
                    case 503:
                        window.LOGGER.error("api response = 503", arguments.callee.name);
                        break;
                    case 404:
                        // not found, stop trying
                        // consider leaving app
                        window.LOGGER.error("api response = 404", arguments.callee.name);
                        break;
                    case 400:
                        // bad request
                        window.LOGGER.error("api response = 400", arguments.callee.name);
                        break;
                    case 422:
                        window.LOGGER.error("api response = 422", arguments.callee.name);
                        break;
                    case 200:
                        window.LOGGER.error("api response = 200", arguments.callee.name);
                        break;
                    default:
                        window.LOGGER.error("unknown error code", arguments.callee.name);
                        break;
                }
            }
        });
        //zepto

    }




    // ********** specific data pullers *************
    ApiConnector.prototype.pullHeatmapData = function pullHeatmapData(latDegrees, latOffset, lonDegrees, lonOffset){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
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
        var URL = heatmapURI+params;
        this.pullApiData(URL, "JSON", "GET", window.UI.updateHeatmap);

    }

    // ********** specific data pullers *************
    ApiConnector.prototype.pullRawHeatmapData = function pullRawHeatmapData(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        /*
         To be extra safe we could do if(typeof(param) === "undefined" || param == null),
         but there is an implicit cast against undefined defined for double equals in javascript
         */
        var heatmapURI = "/heatmap";
        var params = "?raw=true";
        var URL = heatmapURI+params;
        this.pullApiData(URL, "JSON", "GET", window.UI.updateRawHeatmapData, null);
    }

    ApiConnector.prototype.pullMarkerData = function pullMarkerData(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
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
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
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
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        var commentsURI = "/comments";
        console.debug("Push comment data to: "+commentsURI);
        $.ajax({
            type: "POST",
            url: commentsURI,
            data: jsonObj,
            cache: false,
            // processData: false,
            dataType: "json",
            // contentType: "application/json",
            success: function(data){
                if(window.DEBUG){
                    console.log("[INFO] pushCommentData() success");
                }
                window.ApiConnector.pullCommentData(JSON.parse(jsonObj).type, null);
            },
            error: function(xhr, errorType, error){
                // // alert("error: "+xhr.status);
                switch(xhr.status){
                    case 500:
                        // internal server error
                        // consider leaving app
                        window.LOGGER.error("api response = 500", arguments.callee.name);
                        window.LOGGER.obj(error, arguments.callee.name, "500");
                        break;
                    case 503:
                        window.LOGGER.error(" Unavailable", arguments.callee.name);
                        window.LOGGER.obj(error, arguments.callee.name, "503");
                        break;

                    case 404:
                        // not found, stop trying
                        // consider leaving app
                        window.LOGGER.error('api response = 404', arguments.callee.name);
                        window.LOGGER.obj(error, arguments.callee.name, "404");
                        break;
                    case 400:
                        // bad request
                        window.LOGGER.error(" api response = 400", arguments.callee.name);
                        window.LOGGER.obj(error, arguments.callee.name, "400");
                        break;
                    case 422:
                        window.LOGGER.error("api response = 422", arguments.callee.name);
                        window.LOGGER.obj(error, arguments.callee.name, "422");
                        break;
                    case 200:
                        window.LOGGER.error(" api response = 200", arguments.callee.name);
                        window.LOGGER.obj(error, arguments.callee.name, "200");
                        break;
                    default:
                        // alert("Error Contacting API: "+xhr.status);
                        break;
                }
            }
        });
    }

    ApiConnector.prototype.pullTestData = function pullTestData(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        this.pullApiData(this.PATH, "JSON", "GET", window.UI.updateTest);
        this.pullCommentData("needs", null);
        this.pullCommentData("messages", null);
        this.pullHeatmapData();
        this.pullMarkerData();
    }

    ApiConnector.prototype.buildNewPin = function buildNewPin(data){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
    }

    ApiConnector.prototype.pullServerLog = function pullServerLog(callback, url){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        var logURI = "";
        if(window.HOST.indexOf("localhost") != -1 || window.HOST.indexOf("127.0.0.1") != -1){
            logURI += this.LOCALHOST+this.PROXYBASE;

        }
        if(!window.HELPER.isNull(url)){
            logURI += url;
        }else{
            logURI = this.TRUEBASE+"/debug";
        }


        window.LOGGER.debug(arguments.callee.name, "url: "+logURI);
        $.ajax({
            type:'GET',
            url: logURI,
            dataType:"json",
            failure: function(errMsg){
                window.LOGGER.error(arguments.callee.name,"[ERROR] Failed to GET server logs: "+errMsg);
            },
            success: function(data){
                if(!window.HELPER.isNull(callback)){
                    if(window.HELPER.isNull(data.contents)){
                        callback(data);
                    }else{
                        callback(data.contents);
                    }
                }

            },
            error: function(xhr, errorType, error){
                // // alert("error: "+xhr.status);
                switch(xhr.status){
                    case 500:
                        // internal server error
                        // consider leaving app
                        window.LOGGER.error("api response = 500", arguments.callee.name);
                        window.LOGGER.obj(error, arguments.callee.name, "500");
                        break;
                    case 503:
                        window.LOGGER.error(" Unavailable", arguments.callee.name);
                        window.LOGGER.obj(error, arguments.callee.name, "503");
                        break;

                    case 404:
                        // not found, stop trying
                        // consider leaving app
                        window.LOGGER.error('api response = 404', arguments.callee.name);
                        window.LOGGER.obj(error, arguments.callee.name, "404");
                        break;
                    case 400:
                        // bad request
                        window.LOGGER.error(" api response = 400", arguments.callee.name);
                        window.LOGGER.obj(error, arguments.callee.name, "400");
                        break;
                    case 422:
                        window.LOGGER.error("api response = 422", arguments.callee.name);
                        window.LOGGER.obj(error, arguments.callee.name, "422");
                        break;
                    case 200:
                        window.LOGGER.error(" api response = 200", arguments.callee.name);
                        window.LOGGER.obj(error, arguments.callee.name, "200");
                        break;
                    default:
                        // alert("Error Contacting API: "+xhr.status);
                        break;
                }
            }
        });
    }

    ApiConnector.prototype.postLogEvent = function postLogEvent(event, callback){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        window.LOGGER.obj(event, arguments.callee.name, "event to be posted");
        var logURI = this.TRUEBASE+"/debug";
        if(!window.HELPER.isNull(event)){
            var jsonEvent = JSON.stringify(event);
            window.LOGGER.debug(jsonEvent, arguments.callee.name);
            $.ajax({
                type:'POST',
                url: logURI,
                cache: false,
                // processData: false,
                dataType: "json",
                contentType: "application/json",
                data: jsonEvent,
                failure: function(errMsg){
                    window.LOGGER.error(arguments.callee.name,"[ERROR] Failed to GET server logs: "+errMsg);
                },
                success: function(data){
                    window.LOGGER.obj(data, arguments.callee.name, "result of posting log event");
                    if(!window.HELPER.isNull(callback)){
                        if(window.HELPER.isNull(data.contents)){
                            callback(data);
                        }else{
                            callback(data.contents);
                        }
                    }

                },
                error: function(xhr, errorType, error){
                    // // alert("error: "+xhr.status);
                    switch(xhr.status){
                        case 500:
                            // internal server error
                            // consider leaving app
                            window.LOGGER.error("api response = 500", arguments.callee.name);
                            window.LOGGER.obj(error, arguments.callee.name, "500");
                            break;
                        case 503:
                            window.LOGGER.error(" Unavailable", arguments.callee.name);
                            window.LOGGER.obj(error, arguments.callee.name, "503");
                            break;

                        case 404:
                            // not found, stop trying
                            // consider leaving app
                            window.LOGGER.error('api response = 404', arguments.callee.name);
                            window.LOGGER.obj(error, arguments.callee.name, "404");
                            break;
                        case 400:
                            // bad request
                            window.LOGGER.error(" api response = 400", arguments.callee.name);
                            window.LOGGER.obj(error, arguments.callee.name, "400");
                            break;
                        case 422:
                            window.LOGGER.error("api response = 422", arguments.callee.name);
                            window.LOGGER.obj(error, arguments.callee.name, "422");
                            break;
                        case 200:
                            window.LOGGER.error(" api response = 200", arguments.callee.name);
                            window.LOGGER.obj(error, arguments.callee.name, "200");
                            break;
                        default:
                            // alert("Error Contacting API: "+xhr.status);
                            break;
                    }
                }
            });
        }else{
            window.LOGGER.error("Error posting log event", arguments.callee.name);
        }
    }




    // DELETE a comment
    ApiConnector.prototype.deleteComment = function deleteComment(commentId){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        var commentsURI = this.TRUEBASE+"/comments";
        $.ajax({
            type:'DELETE',
            url: commentsURI+"?id="+commentId,
            dataType:"json",
            failure: function(errMsg){
                console.log("[ERROR] Failed to DELETE comment "+commentId+": "+errMsg);
            },
            success: function(data){
                console.log("[INFO] DELETE comment success");
                window.ApiConnector.pullCommentData("", null);
            }
        });//Ajax

    }


    // baseline testing
    ApiConnector.prototype.testObj = function testObj(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
        var URL = testurl;
        this.pullApiData(URL, "JSON", "GET", this.updateTest);
    }

    ApiConnector.prototype.googleClientLibLoaded = function googleClientLibLoaded(){
        window.LOGGER.debug(arguments.callee.name, "[METHOD]");
    }

} // end ApiConnector class def