<?php 
  require('globals.php');
  require('common.php');
  session_start();
  if (isset($_GET["hat"])) 
  {
    $hat = $_GET["hat"];
  }
  else
  {
    $hat = "home";	
  }
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <meta name="description" content="Your description goes here" />
  <meta name="keywords" content="your,keywords,goes,here" />
  <meta name="author" content="Your Name" />
  <link rel="stylesheet" type="text/css" href="css/andreas01.css" media="screen,projection" />
  <link rel="stylesheet" type="text/css" href="css/print.css" media="print" />
  <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
  <title><?php echo $GLOBALS['apptitle_title']; ?></title>
</head>

<body>
  <div id="wrap">
    <img id="frontphoto" src="img/mt_600_3.jpg" width="760" height="3" alt="" /> 

    <?php include("rightside.php");?>
    <div id="contentwide2">
      <!-- switch statement to handle page code -->
      <?php 
        switch($hat)
          {
            case "home":
              include("home.php");
              break;
            case "faq":
              include("faq.php");
              break;
            default:
              include("home.php");
          }
      ?>
    </div>

    <?php include("footer.php");?>

  </div>
</body>
</html>
