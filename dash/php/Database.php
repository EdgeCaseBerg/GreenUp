<?php
/* Establish a connection to the database and
 * make a single-ton object available for use
 * as a database regulator.
*/

require_once __DIR__.'/../../dash-auth/conf.php';

class DatabaseException extends Exception{}

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
			if(self::$connection->connect_error || !isset(self::$connection)){
			    error_log("Unable to connect to the db");
				throw new DatabaseException("Error Connecting to Database", 503);
		    }
		}
		return True;
	}

	public function close(){
		if( ! is_null(self::$connection) ){
			self::$connection->close();
			self::$connection = NULL;
		}
	}
}

?>