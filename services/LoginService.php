<?php

class LoginService {

	var $username = "root";
	var $password = "";
	var $server = "localhost";
	var $port = "3306";
	var $databasename = "virtualmusiclessons";
	var $tablename = "t_user";

	var $connection;

	/**
	 * The constructor initializes the connection to database. Everytime a request is
	 * received by Zend AMF, an instance of the service class is created and then the
	 * requested method is invoked.
	 */
	public function __construct() {
		 // Datenbankverbindung aufbauen 
		
	}

	public function checkUserCredentials($item) {
		
		$connectionid = mysql_connect ($this->server, $this->username , $this->password);
		mysql_select_db ($this->databasename, $connectionid);

		$sql = "SELECT * FROM $this->tablename WHERE username= '$item->Username' and password='$item->Password'";
		$result = mysql_query ($sql);
	
		if (mysql_num_rows ($result) == 1) {
			return TRUE;
		}

		return FALSE;

	}
	
	public function getUserByUsername($item) {
		
		$this -> connection = mysqli_connect($this -> server, $this -> username, $this -> password, $this -> databasename, $this -> port);

		$this -> throwExceptionOnError($this -> connection);

		$stmt = mysqli_prepare($this -> connection, "SELECT * FROM $this->tablename where Username=?");
		$this -> throwExceptionOnError();

		mysqli_stmt_bind_param($stmt, 's', $item);
		$this -> throwExceptionOnError();

		mysqli_stmt_execute($stmt);
		$this -> throwExceptionOnError();

		mysqli_stmt_bind_result($stmt, $row -> P_User_ID, $row -> Username, $row -> Mail, $row -> Password, $row -> Instrument);

		if (mysqli_stmt_fetch($stmt)) {
			return $row;
		} else {
			return null;
		}
	}
	

	private function throwExceptionOnError($link = null) {
		if ($link == null) {
			$link = $this -> connection;
		}
		if (mysqli_error($link)) {
			$msg = mysqli_errno($link) . ": " . mysqli_error($link);
			throw new Exception('MySQL Error - ' . $msg);
		}
	}

}
?>
