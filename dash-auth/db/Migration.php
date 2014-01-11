<?php
/**
*  Migration Class. Simple wrapper for an up or down
* for a migration in order to apply changes or not. 
*/
abstract class Migration {
	abstract protected function up();
	abstract protected function down();
	protected $name; 
	protected $ran; 

	function __construct($name, $ran = false, $connection) {
		$this->name = $name;
		$this->ran = $ran;
		$this->connection = $connection;
	}

	public function migrate(){
		if( Migration::isRan($this->name, $this->connection) )
			return True;
		$migrated = $this->up();
		if( $migrated )
			$this->updateRan(1);
		return $migrated;
	}

	public function revert(){
		if( ! Migration::isRan($this->name, $this->connection) )
			return True;
		$reverted = $this->down();
		if( $reverted )
			$this->updateRan(0);
		return $reverted;
	}

	protected function updateRan($ran) {
		$res = mysql_query("UPDATE migrations SET ran = $ran WHERE name = '" . $this->name . "';", $this->connection);
		if( false === $res )
			die("Failed to update ran status of migration " . $this->name);
		return $res;
	}

	public function toTR() {
		echo "<tr class=\"". ($this->ran ? "ran" : "not-ran") ."\">";
			echo "<td>";
				echo "<label>";
				echo "<input name=\"migrations[]\" value=\"".$this->name."\" type=\"checkbox\" " . ($this->ran ? "checked " : '') . " />";
				echo $this->ran ? "Y" : "N";
				echo "</label>";
			echo "</td>";
			echo "<td>";
				echo $this->name;
			echo "</td>";
		echo "</tr>";
	}

	public static function isRan($name, $connection) {
		$res = mysql_query("SELECT ran FROM migrations WHERE name=\"$name\"", $connection);
		if($res === false)
			die("Query for migration's ran failed");
		if( is_null($res) || mysql_num_rows($res) == 0) {
			$res = mysql_query("INSERT INTO migrations (name, ran) VALUES ('" . $name. "', 0);");
			if(false === $res)
				die("Failed to insert migration row");
			if(mysql_affected_rows($connection))
				return False;
		}

		$assoc = mysql_fetch_assoc($res);
		return $assoc['ran'] == "1";
	}

	public function getName() {
		return $this->name;
	}

}

?>