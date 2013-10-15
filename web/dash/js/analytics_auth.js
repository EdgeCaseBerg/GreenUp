var clientId = '326012990067.apps.googleusercontent.com';
var apiKey = 'AIzaSyACnq-9GkT--OraydO2wWiN10qK3Oh24-k';
var scopes = 'https://www.googleapis.com/auth/analytics.readonly';

function gClientLoaded(){
	// 1. Set the API Key
  gapi.client.setApiKey(apiKey);

  // 2. Call the function that checks if the user is Authenticated. This is defined in the next section
  window.setTimeout(checkAuth,1);
}

function checkAuth() {
  // Call the Google Accounts Service to determine the current user's auth status.
  // Pass the response to the handleAuthResult callback function
  gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: true}, handleAuthResult);
}

function handleAuthResult(authResult) {
  if (authResult) {
    alert('The user has authorized access');
    // Load the Analytics Client. This function is defined in the next section.
    // loadAnalyticsClient();
  } else {
    alert('User has not Authenticated and Authorized');
    // handleUnAuthorized();
  }
}