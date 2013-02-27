<?php

/**
 *  README for sample service
 *
 *  This generated sample service contains functions that illustrate typical service operations.
 *  Use these functions as a starting point for creating your own service implementation. Modify the
 *  function signatures, references to the database, and implementation according to your needs.
 *  Delete the functions that you do not use.
 *
 *  Save your changes and return to Flash Builder. In Flash Builder Data/Services View, refresh
 *  the service. Then drag service operations onto user interface components in Design View. For
 *  example, drag the getAllItems() operation onto a DataGrid.
 *
 *  This code is for prototyping only.
 *
 *  Authenticate the user prior to allowing them to call these methods. You can find more
 *  information at http://www.adobe.com/go/flex_security
 *
 */
class TuserService {

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
		$this -> connection = mysqli_connect($this -> server, $this -> username, $this -> password, $this -> databasename, $this -> port);

		$this -> throwExceptionOnError($this -> connection);
	}

	/**
	 * Returns all the rows from the table.
	 *
	 * Add authroization or any logical checks for secure access to your data
	 *
	 * @return array
	 */
	public function getAllT_user() {

		$stmt = mysqli_prepare($this -> connection, "SELECT * FROM $this->tablename");
		$this -> throwExceptionOnError();

		mysqli_stmt_execute($stmt);
		$this -> throwExceptionOnError();

		$rows = array();

		mysqli_stmt_bind_result($stmt, $row -> P_User_ID, $row -> Username, $row -> Mail, $row -> Password, $row -> Instrument);

		while (mysqli_stmt_fetch($stmt)) {
			$rows[] = $row;
			$row = new stdClass();
			mysqli_stmt_bind_result($stmt, $row -> P_User_ID, $row -> Username, $row -> Mail, $row -> Password, $row -> Instrument);
		}

		mysqli_stmt_free_result($stmt);
		mysqli_close($this -> connection);

		return $rows;
	}

	/**
	 * Returns the item corresponding to the value specified for the primary key.
	 *
	 * Add authorization or any logical checks for secure access to your data
	 *
	 *
	 * @return stdClass
	 */
	public function getT_userByID($itemID) {

		$stmt = mysqli_prepare($this -> connection, "SELECT * FROM $this->tablename where P_User_ID=?");
		$this -> throwExceptionOnError();

		mysqli_stmt_bind_param($stmt, 'i', $itemID);
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

	/**
	 * Updates the passed item in the table.
	 *
	 * Add authorization or any logical checks for secure access to your data
	 *
	 * @param stdClass $item
	 * @return void
	 */
	public function updateT_user($item) {

		$stmt = mysqli_prepare($this -> connection, "UPDATE $this->tablename SET Username=?, Mail=?, Password=?, Instrument=? WHERE P_User_ID=?");
		$this -> throwExceptionOnError();

		mysqli_stmt_bind_param($stmt, 'ssssi', $item -> Username, $item -> Mail, $item -> Password, $item -> Instrument, $item -> P_User_ID);
		$this -> throwExceptionOnError();

		mysqli_stmt_execute($stmt);
		$this -> throwExceptionOnError();

		mysqli_stmt_free_result($stmt);
		mysqli_close($this -> connection);
	}

	/**
	 * Deletes the item corresponding to the passed primary key value from
	 * the table.
	 *
	 * Add authorization or any logical checks for secure access to your data
	 *
	 *
	 * @return void
	 */
	public function deleteT_user($itemID) {

		$stmt = mysqli_prepare($this -> connection, "DELETE FROM $this->tablename WHERE P_User_ID = ?");
		$this -> throwExceptionOnError();

		mysqli_stmt_bind_param($stmt, 'i', $itemID);
		mysqli_stmt_execute($stmt);
		$this -> throwExceptionOnError();

		mysqli_stmt_free_result($stmt);
		mysqli_close($this -> connection);
	}

	/**
	 * Returns the number of rows in the table.
	 *
	 * Add authorization or any logical checks for secure access to your data
	 *
	 *
	 */
	public function count() {
		$stmt = mysqli_prepare($this -> connection, "SELECT COUNT(*) AS COUNT FROM $this->tablename");
		$this -> throwExceptionOnError();

		mysqli_stmt_execute($stmt);
		$this -> throwExceptionOnError();

		mysqli_stmt_bind_result($stmt, $rec_count);
		$this -> throwExceptionOnError();

		mysqli_stmt_fetch($stmt);
		$this -> throwExceptionOnError();

		mysqli_stmt_free_result($stmt);
		mysqli_close($this -> connection);

		return $rec_count;
	}

	/**
	 * Returns $numItems rows starting from the $startIndex row from the
	 * table.
	 *
	 * Add authorization or any logical checks for secure access to your data
	 *
	 *
	 *
	 * @return array
	 */
	public function getT_user_paged($startIndex, $numItems) {

		$stmt = mysqli_prepare($this -> connection, "SELECT * FROM $this->tablename LIMIT ?, ?");
		$this -> throwExceptionOnError();

		mysqli_stmt_bind_param($stmt, 'ii', $startIndex, $numItems);
		mysqli_stmt_execute($stmt);
		$this -> throwExceptionOnError();

		$rows = array();

		mysqli_stmt_bind_result($stmt, $row -> P_User_ID, $row -> Username, $row -> Mail, $row -> Password, $row -> Instrument);

		while (mysqli_stmt_fetch($stmt)) {
			$rows[] = $row;
			$row = new stdClass();
			mysqli_stmt_bind_result($stmt, $row -> P_User_ID, $row -> Username, $row -> Mail, $row -> Password, $row -> Instrument);
		}

		mysqli_stmt_free_result($stmt);
		mysqli_close($this -> connection);

		return $rows;
	}

	/**
	 * Utility function to throw an exception if an error occurs
	 * while running a mysql command.
	 */
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
