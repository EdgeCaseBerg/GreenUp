<?php
    $base = str_replace( basename($_SERVER['REQUEST_URI'], "") , "" , $_SERVER['REQUEST_URI']);
    echo "<br />";
    var_dump($_SERVER['REQUEST_URI']);
    var_dump($_SERVER['HTTPS']);
    var_dump($_SERVER['SERVER_NAME']);

    echo $_SERVER['SERVER_NAME'] . $base;

    if(!isset($_SESSION["userid"]) || !isset($_SESSION["hashword"])){
        session_start();
    }

?>

<html>
<head>
    <link href="bootstrap-3.0.0/dist/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <style type="text/css">
        #loginButton{
            margin-top: 10px;
            margin-right: 10px;
        }

        #loginContainer{
           display: none;
           height: 90%;
           margin-top: -20px;
           background: url('images/backgrounds/80_percent_black.png');
           padding: 10px;
        }

        #loginNest{
            font-size: 1.5em;
            width: 300px;
            padding: 20px;
            background: #eee;
            margin: auto;
            margin-top: 60px;
        }

        #submitButton{
            margin-top: 5px;
        }

        #loginCancelButton{
            margin-top: 5px;
        }
    </style>

    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script src="js/lib/jquery.cookie.js"></script>

    <script>
        <?
        if($_SERVER['HTTPS'] != null){
            echo("var base = 'https://" . $_SERVER['SERVER_NAME'] . $base . "';");
        }else{
            echo("var base = 'http://" . $_SERVER['SERVER_NAME'] . $base . "';");
        }

        echo "console.log(base);";

        ?>

        $(document).ready(function(){
//            $('#loginForm').attr("action", base+"home.php");

            $('#loginButton').click(function(){
                $('#loginContainer').show();
            });

            $('#loginCancelButton').click(function(){
                $('#username').val("");
                $('#password').val("");
                $('#loginContainer').hide();

            });
        });
    </script>
</head>
<body>
    <nav class="navbar navbar-default" role="navigation">
    <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#"><img src="images/greenup-logo-redux.png" height="50" id="navLogo" /></a>
        </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse navbar-ex1-collapse">
        <ul class="nav navbar-nav">
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <li><button type="button"  id="loginButton" class="btn btn-default btn-md">Admin Login</button></li>
        </ul>
    </div><!-- /.navbar-collapse -->
  </nav>
    <div id="loginContainer">
        <div id="loginNest">
            <form method="POST" name="login" id="loginForm" action="home.php">
                email:<input type="email" name= "username" id="username"/><br />
                password:<input type="password" name="password" id="password"/><br />
                <input type="submit" value="submit" id="submitButton" class="btn btn-default btn-md"/>
                <input type="button" value="cancel" id="loginCancelButton" class="btn btn-default btn-md"/>
            </form>
        </div>
    </div>
</body>
