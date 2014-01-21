<?PHP
// @author phelan.vendeville@gmail.com
// A script used to import server configuration from the /etc/conf directory into the project.
// JSON string in the following format:
// { "host" : "dev.xenonapps.com", "mysql-user" : "mysql" , "mysql-password" : "some password", "db-name": "green_up_vt"}

class ConfObject
{
	// class used to create a configuration object from a configuration file.
	function __construct(){
		$raw_conf = file_get_contents("/etc/conf/local.conf");
		$conf = json_decode($raw_conf, true);

		// setup named constants
		define("DB_USER", $conf['mysql-user']);
		define("DB_HOST", $conf['host']);
		define("DB_PASS", $conf['mysql-password']);
		define("DB_NAME", $conf['db-name']);
	}
}
$conf_obj = new ConfObject;
?>