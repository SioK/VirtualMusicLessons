<?php
	$filename = $_POST['filename'].".xml";
	$saveLocation = "./tracks/". $filename;
	//$filename = "testi.xml";
	$xmlContent =  $_POST['filedata'];

	$fp = fopen($saveLocation, 'w+');
	fwrite($fp, $xmlContent);
	fclose($fp); 
	
?>