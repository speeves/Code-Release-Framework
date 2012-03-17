<?php 
    $err_string = "";

    // let's handle any errors in $_SESSION[accountone_error]   
    // do some form validation
    if (isset($_POST["environment"]))
    {
      $environment = $_POST["environment"];
    }

    // now we use a case statement to set $dbname appropriately
    switch($environment)
      {
        case "Dev":
          $dbname = "Sven (MySQL)";
	  break;
	case "QA":
          $dbname = "Lena (Postgresql)";
	  break;
	case "Prod":
          $dbname = "Thor (Oracle)";
	  break;
	default:
	  $dbname = "Ole (MySQL)";
	  $environment = "Dev";
	  break;
      }
?>

<h2 id="header_title"><a href="http://<?php echo $http_host; ?>"><?php echo $GLOBALS['apptitle_long']; ?></a></h2>
<div id="header_infotext">
  <ul>
    <li>This web application will help you to verify the hostname and database server type for a given environment.</li>
    <li>Enter <strong>Dev, QA, or Prod</strong> in the field below, and click Submit</li>
  </ul>
</div>
<span id="error_text"><?php if($err_string != '') {echo $err_string . "<br /><br />"; } ?></span>
<form action="index.php?hat=home" method="post" name="home">
  <label>Database: </label>
  <?php if(isset($environment)) {echo '<strong> ' . $dbname . '</strong>'; } else {echo '<strong> Not Defined</strong>';} ?> 
  <br />
  <label for="from_username" <?php if($usernameerror == 1) { echo "style=' color: red'"; }?>>Environment</label>
  <select name="environment" id="environment">
    <option value="Dev" <?php  if(isset($environment)) { if ($environment == 'Dev') {echo 'selected="selected"';}} ?>>Dev</option>
    <option value="QA" <?php  if(isset($environment)) { if ($environment == 'QA') {echo 'selected="selected"';}} ?>>QA</option>
    <option value="Prod" <?php  if(isset($environment)) { if ($environment == 'Prod') {echo 'selected="selected"';}} ?>>Prod</option>
  </select>
<input type="submit" name="submitbutton" id="submitbutton" value="Submit" />

		</form>
		
