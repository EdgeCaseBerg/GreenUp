<?php
/*  Simple Auth De-Registration Endpoint Prototype. 
 * Interpret incoming POST/GET request
 * Specification:
 *
 * De-registration is a two step process.
 * 1. The request to deregister is created by issuing a POST request
 *    to the API with the `id` and `us` of the User to be deleted. 
 *    The calling client is returned a 200 code and a URL to follow 
 *    with a GET request that will confirm the deletion.
 * 2. The client follows the URL given, which contains a token that will
 *    delete the user from the system
*/

$response = new stdClass();
$response->code = 400; 

if($_SERVER['REQUEST_METHOD'] != 'POST' && $_SERVER['REQUEST_METHOD'] != 'GET'){
	$response->message = "Unsupported HTTP Method";
	goto send_response;
}

/* Valid Possibly. Perform Database access and token exchange */
require_once __DIR__.'/../conf.php';
require_once BASE_INCLUDE . "/db/UserDAO.php";
$database = UserDAO::Instance();

if($_SERVER['REQUEST_METHOD'] == 'GET'){
	if( ! isset($_GET['token'] ) ){
		$response->message = "Authorization parameters not found";
		goto send_response;
	}
	if( ! isset($_GET['id']) ){
		$response->message = "id parameter not found";
		goto send_response;
	}
	/* Expect the hash of the secret */
	if( ! isset($_GET['us']) ){
		$response->message = "us parameter not found";
		goto send_response;
	}
	try{
		$response->message =  $database->deregister( $_GET['id'],  $_GET['us'], $_GET['token'] );
	}catch(DatabaseException $err){
		$response->message = $err->getMessage();
		$response->code = $err->getCode();
		goto send_response;
	}	
} else {
	/* Generate URL for client */
	$raw = file_get_contents("php://input");
	try {
		$jsRequest = json_decode($raw);	
	} catch ( Exception $e ) {
		$response->message = "Could not Parse JSON request";
		goto send_response;
	}

	if( ! $jsRequest->id ) {
		$response->message = "id key not found in data";
		goto send_response;
	}

	if( ! $jsRequest->us ) {
		$response->message = "us key not found in data";
		goto send_response;
	}

	try{
		$response->url = $database->generateDeRegisterURL($jsRequest->id, $jsRequest->us);
	}catch(DatabaseException $err){
		$response->message = $err->getMessage();
		$response->code = $err->getCode();
		goto send_response;
	}
}

$response->code = 200;

send_response:
header( "Content-Type: application/json", true, $response->code );
echo json_encode($response);
exit();
?>