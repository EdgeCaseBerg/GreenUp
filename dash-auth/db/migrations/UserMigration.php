<?php

if( ! isset($migrations) )
	die("Migrations Array Not found. This Script must run from migrate.php's scope");

if( ! isset($connection) )
	die("Connection to mysql database must already be established by migrate.php's scope");

/**
* 
*/
class UserMigration extends Migration {
	function __construct($name, $ran = false, $connection) {
		$this->name = $name;
		$this->ran = $ran;
		$this->connection = $connection;
	}

	protected function up(){
		$res = mysql_query(
			"CREATE TABLE users (
        		id INT(20) NOT NULL auto_increment PRIMARY KEY, -- association id for foreign relationships to other tables
        		ident CHAR(64), -- sha256 hashed identifier,
        		hash CHAR(255), -- salt to apply during creation of ident
        		nickname VARCHAR(32), 
        		last_seen TIMESTAMP 
    		) ENGINE InnoDB;", $this->connection
		);
		if(false === $res)
			die("Failed to migrate " . $this->name . " " . mysql_error());
		return $res;
	}

	protected function down(){
		$res = mysql_query("DROP TABLE users;");
		if(false === $res)
			die("Failed to revert migration " . $this->name . mysql_error());
		return $res;
	}
}


$mName = "UserMigration";
$m = new UserMigration($mName, Migration::isRan($mName, $connection), $connection);
$migrations[] = $m;

?>