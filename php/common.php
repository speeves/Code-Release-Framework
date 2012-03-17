<?php
        function check_error_messages($err_msg) {
           switch ($err_msg) {
            case "Login aborted":
                $str = "Login failure";
                break;
            case "Too many login failures":
                $str = "Please enable IMAP on account";
           }
            
            return $str;
        }
 
?>