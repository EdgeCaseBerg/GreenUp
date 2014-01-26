<?php
?>

<div id="debugContainer">
<div class="debug debug1">
<?
$confText = json_decode(file_get_contents("/etc/conf/local.conf"), 1);
echo("config loaded: <b>GOOD</b><br />");
$con = mysqli_connect($confText['host'],$confText['mysql-user'],$confText['mysql-password'],$confText['db-name']) or die("db connection: <b>BAD</b>" . mysqli_connect_error());
echo("db connection: <b>GOOD</b><br />");
echo("db name: ".$confText["db-name"]."<br />");
// Check connection
?>
</div>

<div class="debug debug2"

</div>

</div>

<script>

</script>
