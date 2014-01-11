<?php
/*  Simple Auth Registration Endpoint Prototype. 
 * Interpret incoming POST request
 * Specification:
 *
 * Expects a JSON object of { "id" : <id> , "us" : <unique string used as password> }
 * Will return an object with a code property indicating result of request. Clients
 * are expected to handle the case of 200 or 400 correctly. 200 indicating success
 * and that a token has been generated for them, and 400 indicating that their
 * request was invalid and they will not be signed up for service.
*/

$response = new stdClass();
$response->code = 400; 

if($_SERVER['REQUEST_METHOD'] != 'POST'){
	$response->message = "Unsupported HTTP Method";
	goto send_response;
}

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

/* Valid Possibly. Perform Database access and token exchange */
require_once __DIR__.'/../conf.php';
require_once BASE_INCLUDE . "/db/UserDAO.php";

$database = UserDAO::Instance();

try{
	$token = $database->register( $jsRequest->id,  $jsRequest->us );
}catch(RegistrationException $err){
	$response->message = $err->getMessage();
	$response->code = $err->getCode();
	goto send_response;
}

$response->token = $token;
$response->code = 200;

send_response:
header( "Content-Type: application/json", true, $response->code );
echo json_encode($response);
exit();
?>