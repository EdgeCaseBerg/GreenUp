<html>
<head>
    <link rel="shortcut icon" type="image/x-icon" href="favicon.ico" />
    <link href='https://fonts.googleapis.com/css?family=Source+Code+Pro:400,900' rel='stylesheet' type='text/css'>
    <style type="text/css">
        body{
            background: #fff;
        }

        #descriptionContainer{
            position:relative;
            vertical-align: top;
            display:inline-block;
            width:49%;
            height:100%;
            text-align:center;
        }

        #descriptionNest{
            width:80%;
            margin-left:15%;
        }

        #greenup_logo{
            width:200px;
            display:block;
            margin:auto;
        }
        .contentHeader{
            font-family: 'Source Code Pro', sans-serif;
            font-size:0.9em;
            text-align: left;
            border:solid 1px #aaa;
            background:#fff;
            padding:2em;
        }
        #phoneContainer{
            position:relative;
            vertical-align: top;
            display:inline-block;
            width:49%;
            min-width:500px;
            margin:auto;
        }

        #iphoneImage{
            background-image: url('img/iphone_black.png');
            background-size: 100% 100%;
            position:absolute;
            top:8px;
            left:5px;
            width:448px;
            height:782px;
        }


        #phoneFrame{
            position:absolute;
            top: -10px;
            border-top:solid 1px #fff;
            vertical-align: top;
            margin:auto;
            width:430px;
            height:770px;
            background-size: auto 100%;
            background-repeat: no-repeat;
            text-align:center;
            z-index:1000;
        }

        #phoneScreen{
            width: 79.1%;
            height: 70.3%;
            margin:auto;
            margin-top:29%;
        }

        #iframe{
            position:relative;
            z-index:100;
            width:100%;
            height:100%;
        }
        a{
            text-decoration: none;
            color:purple;
        }
        h3{
            font-family: 'Source Code Pro', sans-serif;
        }
    </style>

    <script src="../dash/js/lib/jquery/jquery.js"></script>

    <script>
        <?php
            echo "window.IP = '".$_SERVER['SERVER_ADDR']."'";
        ?>

        $(document).ready(function(){
            $('#iframe').attr("src", "http://greenup.xenonapps.com/client/index.php?frame=true");
        });


        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

        ga('create', 'UA-44570622-1', 'greenupapp.appspot.com');
        ga('send', 'pageview');


    </script>


</head>
<body>
<div id="descriptionContainer">
    <div id="descriptionNest">
        <p class="contentHeader">
            <img src="img/greenup_logo.png" id="greenup_logo"/><br />
            &nbsp;&nbsp;&nbsp;The GreenUp-VT app available for iOS, Android, and mobile web browsers, is a not-for-profit project developed by <a href="http://xenonapps.com">XenonApps.com</a> for the Green Up Vermont organization, meant to make the annual Green-Up day more efficient and better organized, while providing valuable data to help coordinate future Green-Up days. <br /><br />&nbsp;&nbsp;&nbsp;<a href="http://www.greenupvermont.org/">Green Up Vermont</a> is a nonprofit organization with 501(c)(3) status. Green Up's mission is to promote the stewardship of our state's natural landscape and waterways and the livability of our communities by involving people in Green Up Day and raising public awareness about the benefits of a litter-free environment.
            <br /><br />
            &nbsp;&nbsp;&nbsp;The app anonymously gathers GPS data from your mobile device while you work, which, when compiled with the data of other participants, is plotted as a heat map, providing all participants with a comprehensive overview of the areas that have already been cleaned and the areas that require more attention. Furthermore, the app allows participants to comment on the needs of specific locations with geocoded messages aggregated in our comments section.
        <h3>Click on the app to begin a tour</h3>

        </p>
    </div>
</div>
<div id="phoneContainer">
    <div id="phoneFrame">
        <div id="phoneScreen">
            <!-- <img src="iphone_black.png" id="iphoneImage"/> -->
            <div id="iphoneImage">
            </div>
            <!-- <iframe id="iframe" src="https://dev.xenonapps.com/green-web/client/index.php?frame=true"></iframe> -->
            <!-- <iframe id="iframe" src="http://greenupapp.appspot.com?agent=frame"></iframe>  -->
            <iframe id="iframe" src="http://localhost/client/index.php?frame=true"></iframe>

            <!-- // app content here -->
        </div>
    </div>
</div>
</body>
</html>