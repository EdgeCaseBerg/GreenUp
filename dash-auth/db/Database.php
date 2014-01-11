<?php
/* Establish a connection to the database and 
 * make a single-ton object available for use
 * as a database regulator. 
*/

require_once __DIR__.'/../conf.php';
require_once BASE_INCLUDE . '/models/User.php';
require_once BASE_INCLUDE . '/lib/password_compat/password.php';
class DatabaseException extends Exception{}
class AuthenticationException extends DatabaseException{}
class RegistrationException extends DatabaseException{}
class UnknownUserException extends DatabaseException{}

abstract class Singleton{
    static $instances = array();
    protected function __construct(){
    }

    final private function __clone(){
    }

    final public static function Instance(){
        $calledClass = get_called_class();
        if ( ! isset($instances[$calledClass]) ) {
            $instances[$calledClass] = new $calledClass();
        }
        return $instances[$calledClass];
    }   
}

class Database extends Singleton{
	protected static $inst = null;
	public static $connection = null;
	protected static $options = array("cost" => 10);

	protected function __construct() {
		$this->connect();
	}

	public function __destruct() {
		$this->close();
	}

	final public function __call($name, $arguments){
		$this->connect();
		return call_user_func_array(array($this, '__' . $name), $arguments);
	}

	public function connect(){
		if( is_null( self::$connection ) ){
			/* Connect to database */
			self::$connection = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
			if(self::$connection->connect_error)
				throw new DatabaseException("Error Connecting to Database", 503);
				
		}
		return True;
	}

	public function close(){
		if( ! is_null(self::$connection) ){
			self::$connection->close();
			self::$connection = NULL;
		}
	}

	/* Returns User Object if exists, throws UnknownUserException otherwise */
	protected function __user_exist($ident){
		$user_query = self::$connection->prepare("SELECT hash, nickname, realname, UNIX_TIMESTAMP(last_seen) FROM users WHERE ident = ?");
		$user_query->bind_param('s',$ident);
		if( ! $user_query->execute() ){
			error_log(self::$connection->error);
			throw new DatabaseException("Error Processing Query", 500);
		}
		$user_query->store_result();
		if( $user_query->num_rows == 0 ){
			throw new UnknownUserException("Unknown User, could not find User with that identifier", 404);
		}
		if( $user_query->num_rows != 1 ){
			error_log("WARNING Identifier $ident is not Unique");
		}
		$uObject = new User(array("id" => $ident));
		$user_query->bind_result($uObject->hash, $uObject->nickname, $uObject->realname, $uObject->lastseen);
		$user_query->fetch();
		$user_query->close();
		return $uObject;
	}

	public function __auth($user_id, $password){
		$this->connect();
		/* Get hash to check against */
		$db_User = $this->user_exist($user_id);

		if (password_verify($password, $db_User->hash)) {
			if (password_needs_rehash($db_User->hash, PASSWORD_BCRYPT, self::$options)) {
				$db_User->hash = password_hash($password, PASSWORD_BCRYPT, self::$options);
				/* Store new hash in db */
				$update = self::$connection->prepare("UPDATE users SET hash = ? WHERE ident = ? ");
				$update->bind_param('ss', $db_User->hash, $user_id);
				if( ! $update->execute() ){
					error_log(self::$connection->error);
					throw new DatabaseException("Error updating hash", 500);		
				}
				$update->close();
			}
			return $db_User->hash;
		} else {
			throw new AuthenticationException("Could not verify access", 400);
		}
	}

	public function __register($user_id, $password){
		$db_hash = NULL;
		/* Ensure User does not already exists */
		try{
			$this->user_exist($user_id);
			throw new RegistrationException("User already exists", 409);
		}catch(UnknownUserException $uue){
			/* This means the User does not exist and we should make one */
		}

		$hash = password_hash($password, PASSWORD_BCRYPT, self::$options);

		$insert = self::$connection->prepare("INSERT INTO users (ident, hash) VALUES ( ? , ? )");
		$insert->bind_param('ss',$user_id, $hash);
		if( ! $insert->execute() ){
			error_log(self::$connection->error);
			throw new DatabaseException("Could not create User, query error", 500);
		}
		$insert->close();

		if (password_needs_rehash($hash, PASSWORD_BCRYPT, self::$options)) {
			$hash = password_hash($password, PASSWORD_BCRYPT, self::$options);
			/* Store new hash in db */
			$update = self::$connection->prepare("UPDATE users SET hash = ? WHERE ident = ? ");
			$update->bind_param('ss', $hash, $user_id);
			if( ! $update->execute() ){
				error_log(self::$connection->error);
				throw new DatabaseException("Error updating hash", 500);		
			}
			$update->close();
		}

		return True;
	}


	public function __generateDeRegisterURL($user_id, $password){
		$uObject = $this->user_exist($user_id);
		/* http://stackoverflow.com/a/2297421/1808164 */
		$host = "";
		if( isset($_SERVER['HTTPS']) && ($_SERVER['HTTPS'] == 'on' || $_SERVER['HTTPS'] == 1) || isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')
			$protocol = 'https://';
		else
			$protocol = 'http://';
		if( isset($_SERVER['HTTP_HOST']) && isset($_SERVER['REQUEST_URI']) )
			$host =  $protocol . $_SERVER['HTTP_HOST'] . $_SERVER['PHP_SELF'] . '?';
		if(password_verify($password, $uObject->hash))
			return $host . 'token=' . password_hash( $uObject->getUnique() , PASSWORD_BCRYPT, self::$options) . '&us=' . password_hash(  $uObject->hash, PASSWORD_BCRYPT, self::$options) . '&id=' . $user_id;
		else
			throw new AuthenticationException("Deregistration refused. Incorrect Credentials", 403);
	}

	public function __deregister($user_id, $password, $token){
		$uObject = $this->user_exist($user_id);
		$password_check = password_hash( $uObject->hash , PASSWORD_BCRYPT, self::$options);
		if(password_verify($uObject->hash, $password )){
			$token_check = password_hash( $uObject->getUnique() , PASSWORD_BCRYPT, self::$options);
			if(password_verify($uObject->getUnique(), $token_check)){
				/* Valid token and User Password. Delete User */
				$delete =  self::$connection->prepare("DELETE FROM users WHERE ident = ?");
				$delete->bind_param("s",$user_id);
				if( ! $delete->execute() ){
					error_log(self::$connection->error);
					throw new DatabaseException("Could not complete request ", 500);
				}
				if( $delete->affected_rows == 0 )
					throw new RegistrationException("Did not delete User", 500);
				if( $delete->affected_rows > 1 )
					error_log("WARNING Deleted multiple users with ident: $user_id");
				return "User $user_id removed from System";
				$delete->close();
			}
		}
		throw new AuthenticationException("Deregistration refused. Incorrect Credentials", 403);
	}

}

?>