window.DEBUG = false;

// prototype objects for posting to API
function Pin(){
	this.latDegrees; 
    this.lonDegrees;
    this.type; 
    this.message = "I had to run to feed my cat, had to leave my Trash here sorry! Can someone pick it up?";
    this.addressed = false;
}


//We cannot call this Comment because it's reserved by javascript
function FCommment(){
	this.message ="FORUM";
	this.pin = null;
	this.type = "";
}

function INPUT_TYPE(){
	this.NONE  = -1;
	this.PIN = 0;
	this.MARKER = 0;
	this.COMMENT = 1;
}

// logger for reporting problems to the server
function ClientLogger(){
	ClientLogger.prototype.logEvent = function logEvent(eventString, methodNameString){
		console.log(methodNameString, eventString);
	}
}

// --------- Auth and Load Google Shit -----

function loadAnalytics(){
	// alert("analytics");
	if(window.DEBUG == false){
		var clientId = '603345821345.apps.googleusercontent.com';
		var apiKey = 'AIzaSyBYp3Dhzy4PR0TPmtw7y2cnMz7nQrPJ9yQ';
		var scopes = 'https://www.googleapis.com/auth/analytics.readonly';

		gapi.client.setApiKey(apiKey);

		gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: false}, handleAuthResult);

	}else{
		alert("DEBUG");
		$('#loginContainer').fadeOut(1000);
		mainLoad();	
	}

}

function analyticsLoaded(){
	// alert("analytics loaded");
	mainLoad();
	gapi.client.analytics.management.accounts.list().execute(handleAccounts);
}

function handleAuthResult(authResult) {
  if (authResult) {
    console.log('The user has authorized access');

    gapi.client.load('analytics', 'v3', analyticsLoaded);
    $('#loginContainer').fadeOut(1000);


  } else {
    console.log('*** User is not Authenticated or Authorized **');
    // handleUnAuthorized();
  }
}

function handleAccounts(results) {
  if (!results.code) {
    if (results && results.items && results.items.length) {

      // Get the first Google Analytics account
      var firstAccountId = results.items[0].id;

      // Query for Web Properties
      queryWebproperties(firstAccountId);

    } else {
      console.log('No accounts found for this user.')
    }
  } else {
    console.log('There was an error querying accounts: ' + results.message);
  }
}



function queryWebproperties(accountId) {
  console.log('Querying Webproperties.');

  // Get a list of all the Web Properties for the account
  gapi.client.analytics.management.webproperties.list({'accountId': accountId}).execute(handleWebproperties);
}

function handleWebproperties(results) {
  if (!results.code) {
    if (results && results.items && results.items.length) {

      // Get the first Google Analytics account
      var firstAccountId = results.items[0].accountId;
      console.log(results.items);

      // Get the first Web Property ID
      var firstWebpropertyId = results.items[0].id;

      // Query for Views (Profiles)
      queryProfiles(firstAccountId, firstWebpropertyId);

    } else {
      console.log('No webproperties found for this user.');
    }
  } else {
    console.log('There was an error querying webproperties: ' + results.message);
  }
}

function queryProfiles(accountId, webpropertyId) {
  console.log('Querying Views (Profiles).');

  // Get a list of all Views (Profiles) for the first Web Property of the first Account
  gapi.client.analytics.management.profiles.list({
      'accountId': accountId,
      'webPropertyId': webpropertyId
  }).execute(handleProfiles);
}

function handleProfiles(results) {
  if (!results.code) {
    if (results && results.items && results.items.length) {

      // Get the first View (Profile) ID
      var firstProfileId = results.items[0].id;

      var HELPER = new Helper();
  	// var endDate = HELPER.getGoogleFormattedDate(new Date());
  	var endDate = "2013-09-01";
  // var startDate = HELPER.getGoogleFormattedDate(new Date(2013, 8, 3, 3, 3, 4, 567));
  var startDate = "2013-05-01";

      // Step 3. Query the Core Reporting API
      queryCoreReportingApi(firstProfileId, startDate, endDate);

    } else {
      console.log('No views (profiles) found for this user.');
    }
  } else {
    console.log('There was an error querying views (profiles): ' + results.message);
  }
}

function queryCoreReportingApi(profileId, startDate, endDate) {
  window.ANALYTICS_PROFILE = profileId;
  console.log('Querying Core Reporting API.');
  

  // Use the Analytics Service Object to query the Core Reporting API
  gapi.client.analytics.data.ga.get({
    'ids': 'ga:' + profileId,
    'start-date': startDate,
    'end-date': endDate,
    'metrics': 'ga:visits, ga:newVisits', 
    'dimensions': 'ga:date, ga:operatingSystem'
  }).execute(handleCoreReportingResults);
}

function handleCoreReportingResults(results) {
  if (results.error) {
  	// TODO error message in place of analytics
    console.log('There was an error querying core reporting API: ' + results.message);
  } else {
  	console.log("core reporting results");
    console.log(results);

    var androidCount = 0;
    var iosCount = 0;
    var otherCount = 0;

  		var lineDataTemp = [];
  		lineDataTemp.push(['Hours', 'Visitors']) 
  		for(var zz=0; zz<results.rows.length; zz++){
  			lineDataTemp.push([results.rows[zz][0], parseInt(results.rows[zz][2])]);

  			switch(results.rows[zz][1]){
  				case "Android":
  					androidCount++;
  					break;
  				case "iOS":
  					iosCount++;
  					break;
  				default:
  					otherCount++;
  					break;
  			}
  		}

	  	var lineData = new google.visualization.arrayToDataTable(lineDataTemp);

	  	var pieData =  new google.visualization.arrayToDataTable([
	    	['Type', 'Users'],
	    	['iPhone', iosCount],
	    	['Android', androidCount],
	    	['Web', otherCount],
	  	]);

	  	var pctIphone = ((iosCount / results.rows.length) * 100);
	  	var pctAndroid = ((androidCount / results.rows.length) * 100);
	  	var pctOther = ((otherCount / results.rows.length) * 100);

	  	$('#pctIphone').html(pctIphone.toFixed(1) + "%");
	  	$('#pctAndroid').html(pctAndroid.toFixed(1) + "%");
	  	$('#pctOther').html(pctOther.toFixed(1) + "%");

        $('#infoIcon').show();

        window.UI.drawVisualisation(pieData, lineData);
    }
}

// https://developers.google.com/analytics/resources/concepts/gaConceptsAccounts
// https://developers.google.com/analytics/solutions/articles/hello-analytics-api
// https://developers.google.com/api-client-library/javascript/features/authentication#popup

// -------- end Google Shit ---------




/**
* This is where all the action begins (once content is loaded)
* @author Josh
*/



// document.addEventListener('DOMContentLoaded',function(){
// 	window.LOGGER = new ClientLogger();
// 	window.INPUT_TYPE = new INPUT_TYPE();
// 	window.DEBUG = false;


// 	// instansiate the api
// 	window.ApiConnector = new ApiConnector();
// 	// instansiate the forum
// 	window.Comments = new CommentsHandle();
// 	// instansiate /initialize the UI controls
// 	window.UI = new UiHandle();
// 	window.UI.init();
// 	// build out the google map
// 	window.MAP = new MapHandle();
// 	window.MAP.initMap();
// 	// grab our comments, map markers, and heatmap data
// 	window.ApiConnector.pullCommentData();
// 	window.ApiConnector.pullMarkerData();
// 	window.ApiConnector.pullHeatmapData();

// });

