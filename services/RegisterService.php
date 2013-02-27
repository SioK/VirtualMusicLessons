<?php
class RegisterService {
	var $dbusername = "root";
	var $dbpassword = "";
	var $server = "localhost";
	var $port = "3306";
	var $databasename = "virtualmusiclessons";
	var $tablename = "t_user";

	var $connection;

	public function __construct() {
		$this -> connection = mysqli_connect($this -> server, $this -> dbusername, $this -> dbpassword, $this -> databasename, $this -> port);

	}

	public function registerUser($user) {

		$stmt = mysqli_prepare($this -> connection, "INSERT INTO $this->tablename (Username, Mail, Password, Instrument) VALUES (?, ?, ?, ?)");

		mysqli_stmt_bind_param($stmt, 'ssss', $user -> Username, $user -> Mail, $user -> Password, $user -> Instrument);


		mysqli_stmt_execute($stmt);


		mysqli_stmt_free_result($stmt);
		mysqli_close($this -> connection);
	}

}
?>