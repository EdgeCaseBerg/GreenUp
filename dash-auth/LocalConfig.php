<?PHP
// @author phelan.vendeville@gmail.com
// A script used to import server configuration from the /etc/conf directory into the project.
// JSON string in the following format:
// { "host" : "dev.xenonapps.com", "mysql-user" : "mysql" , "mysql-password" : "some password", "db-name": "green_up_vt"}
class LocalConfig
{
    public $DB_USER = null;
    public $HOST = null;
    public $DB_PASS = null;
    public $DB_NAME = null;
	// class used to create a configuration object from a configuration file.
	public function __construct(){
		$conf = json_decode(file_get_contents("/etc/conf/local.conf"));

		// setup named constants
		$this->DB_USER = $conf['mysql-user'];
		$this->DB_HOST = $conf['host'];
		$this->DB_PASS = $conf['mysql-password'];
		$this->DB_NAME = $conf['db-name'];
	}
}
//$conf_obj = new ConfObject;
?>