<?php
/* Read in each migration file and execute them in User Defined Order
 * 
 * Migration files are given an array by this migration scripe here
 * that they add themselves to, then we can check the status of the 
 * database 
*/

require_once __DIR__.'/../conf.php';

$migrations = array(); 
$files = array();
/* Setup Migration Table if it doesn't exist */

$connection = mysql_connect(DB_HOST, DB_USER, DB_PASS);
if($connection === false)
	die("Could Not Connect to database! Have you created it? " . mysql_error());

if(false === mysql_select_db(DB_NAME, $connection) ) {
	/* Database has not been created yet */
	if(false === mysql_query("CREATE DATABASE simple-auth;"))
		die("Could not create database, please do so manually " . mysql_error() ) ;
	
}

$tableCreated = False;
if( mysql_num_rows( mysql_query ( "SHOW TABLES LIKE 'migrations' ") ) != 1 ){
	/* Create the Migrations Table if it doesn't exist */
	if( false === mysql_query(
		" CREATE TABLE migrations (
        	id INT(10) NOT NULL auto_increment PRIMARY KEY, 
        	name VARCHAR(32),
        	ran BOOL
    	) ENGINE InnoDB;") )
		die("Could not create migrations table " . mysql_error());
	else
		$tableCreated = true;
}

/* Retrieve each migration */
$migrationsFolder = dirname(__FILE__) . '/migrations';

if($handle = opendir($migrationsFolder)) {
	while( false !== ($file = readdir($handle) ) )
		if($file != "." && $file != ".."){
			$time =filectime($migrationsFolder . "/" . $file); 
			while(array_key_exists($time, $files))
				$time = $time + 1; //Not the best strat, but a strat
			$files[$time] = $file;		
		}
	ksort($files);
	closedir($handle);

	require_once "Migration.php";
	foreach ($files as $file) {
		include $migrationsFolder . "/" . $file;
	}

	/* Perform Migrations if neccesary */
	if(isset($_POST['migrate']) && $_POST['migrate'] == "go"){
		unset($_POST['migrate']);
		if( isset($_POST['migrations']) ){
			$to_migrate = array_values($_POST['migrations']);
			foreach ($migrations as $migration) {
				if( in_array($migration->getName(), $to_migrate)  ){
					if( ! $migration->migrate() )
						echo "Failed To Migrate: " . $migration->getName();
				}
				else
					if( ! $migration->revert() )
						echo "Failed To Revert: " . $migration->getName();
			}
			unset($_POST);
			header('Location: '.$_SERVER['REQUEST_URI']);
		}else{
			/* No migrations at all. Down em all! */
			foreach ($migrations as $migration) {
				if( ! $migration->revert() )
					echo "Failed to Revert: " . $migration->getName();
			}
		}
	}
}


?>
<?php
			
		?>
<html>
	<head>
		<title>Migrations</title>
		<style type="text/css">
		.ran{
			background-color: green;
		}
		.not-ran{
			background-color: red;
		}
		</style>
	</head>
	<body>
		<h1>Migration Management</h1>
		<p>
			Make sure to have setup the Initial Database User and created
			the database itself via the SQL defined in the DataSchema Wiki
			page!
		</p>
		<p>
			Migration Information Pulled from:
			<em><?php echo $migrationsFolder; ?></em>
		</p>
		<form method="POST">
		<table>
			<thead>
				<tr>
					<th>Ran</th>
					<th>Name</th>
				</tr>
			</thead>
			<tbody>
				<?php
				foreach ($migrations as $migration) {
					$migration->toTR();
				}
				?>
			</tbody>
		</table>
		<input type="submit" value="Apply Migrations" />
		<input type="hidden" value="go" name="migrate" />
		</form>
		<script type="text/javascript">
			/* Javascript to force incremental changes 
			 * If checkbox 1,2, 5 are checked then all
			 * migrations 1,2,3,4,5 should be applied.
			 * If checkbox 3 is unchecked, all checkboxes
			 * after 3 should be unchecked as well.
			*/
			var inputs = document.getElementsByName("migrations[]");
			for (var i = inputs.length - 1; i >= 0; i--) {
				inputs[i].onclick = function(evt){
					var parentTr = this.parentNode.parentNode.parentNode;
					if( this.checked ){
						/* Find and set the previous children to true*/
						while(parentTr){
							parentTr.firstChild.firstChild.firstChild.checked = true;
							parentTr = parentTr.previousElementSibling;
						}
					}else{
						/* Find and set the future children to false */
						while(parentTr){
							parentTr.firstChild.firstChild.firstChild.checked = false;
							parentTr = parentTr.nextElementSibling;
						}
					}
				}
			};
		</script>
	</body>
</html>