<?php

include "variables.php";

$saveLocation = "videos/";
$filename = basename($_FILES['Filedata']['name']);
$uploadPath = $saveLocation . $filename;

if (move_uploaded_file($_FILES['Filedata']['tmp_name'], $uploadPath)) {
	echo $currentDir . $saveLocation . $filename;
} else {
	echo "ERROR";
}
