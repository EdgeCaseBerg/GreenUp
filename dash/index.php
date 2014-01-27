<?php

$errorMsg = "";

$base = str_replace( basename($_SERVER['REQUEST_URI'], "") , "" , $_SERVER['REQUEST_URI']);

if(!isset($_SESSION["userid"]) || !isset($_SESSION["hashword"])){
    session_start();
}

if(isset($_GET['errorno'])){
    if($_GET['errorno'] == 1){
        $errorMsg = "Username and/or password incorrect.";
    }else if($_GET['errorno'] == 2){
        $errorMsg = "Username and/or password incorrect.";
    }
}

if(isset($_GET['logout'])){
    $_SESSION = null;
    session_destroy();
}




//    echo(file_get_contents("/etc/conf/local.conf"));
?>

<html>
<head>
    <link href="bootstrap-3.0.0/dist/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <style type="text/css">

        .errorMessage{
            color: #b50000;
            font-size: 0.8em;
        }

        #loginButton{
            margin-top: 10px;
            margin-right: 10px;
        }

        .spacer100{
            height: 100px;
        }

        .main_left{
            padding-left: 50px;
        }



        #loginNest{
            font-size: 1.5em;
            width: 350px;
            padding: 20px;
            background: #eee;
        }

        #submitButton{
            margin-top: 5px;
        }

        #loginCancelButton{
            margin-top: 5px;
        }

        #mainContainer{
            position relative;
            z-index: 1;
            height: 100%;
            width: 100%;
            background: url('images/backgrounds/norwegian_rose/norwegian_rose.png');
        }

        #headerNav{
            position: relative;
            z-index: 1000;
            margin-bottom: 0px;
            -webkit-box-shadow: 2px 2px 7px 2px #3B3B3B;
            box-shadow: 2px 2px 7px 2px #3B3B3B;

        }

        .inputLabel{
            text-align: right
        }

        .loginInput{
            margin-left: 10px;
        }

        .col-md-6{
            /*border:solid 2px #fff;*/
        }
    </style>

    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script src="js/lib/jquery.cookie.js"></script>

    <script>
        $(document).ready(function(){


            <?
            if($_SERVER['HTTPS'] != null){
                echo("var base = 'https://" . $_SERVER['SERVER_NAME'] . $base . "';");
            }else{
                echo("var base = 'http://" . $_SERVER['SERVER_NAME'] . $base . "';");
            }

            echo "console.log(base);";

            ?>


//            $('#loginForm').attr("action", base+"home.php");

            $('#loginCancelButton').click(function(){
                $('#username').val("");
                $('#password').val("");

            });
        });
    </script>
</head>
<body>
<nav class="navbar navbar-default" role="navigation" id="headerNav">
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
<div id="mainContainer">
    <div class="row spacer100">

    </div>
    <div class="row">
        <div class="col-md-6 main_left">
            <h2>
                Welcome to the Green-Up VT<br />Administrative Dashboard.
            </h2>
            <h4>
                Please log in to continue.
            </h4>
        </div>

        <div class="col-md-6 main_right">
            <div id="loginNest">
                <div class="errorMessage">
                    <? echo $errorMsg; ?>
                </div>
                <form method="POST" name="login" id="loginForm" action="home.php">
                    <table>
                        <tr>
                            <td class="inputLabel">email:</td><td><input type="email" name= "username" id="username" class="loginInput"/></td>
                        </tr>

                        <tr>
                            <td class="inputLabel">password:</td><td><input type="password" name="password" id="password" class="loginInput"/></td>
                        </tr>

                        <tr>
                            <td></td>
                            <td>
                                <input type="submit" value="submit" id="submitButton" class="btn btn-default btn-md" style="margin-left: 10px;"/>
                                <input type="button" value="cancel" id="loginCancelButton" class="btn btn-default btn-md"/>
                            </td>
                        </tr>
                    </table>
                    <br /><a href="forgotPassword.php" style="font-size: 0.9em;">forgot password</a>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
