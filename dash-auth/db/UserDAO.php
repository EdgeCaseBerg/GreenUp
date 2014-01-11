<?php
/* User Data Access Object
 * This class provides functionality to retrieve values and
 * pieces of data that are specifically involved with the
 * user objects. 
 *
*/
require_once __DIR__.'./../conf.php';
require_once __DIR__.'/Database.php';
require_once BASE_INCLUDE . '/models/User.php';

class UserDAO extends Database{
	public $user = NULL;

	/* Might throw a UnknownUserException */
	public function __load_user( $user_id ){
		$this->user = $this->user_exist($user_id);	
	}

}


?>