<?php
$saveLocation = "./tracks/";
$uploadPath = $saveLocation . basename($_FILES['Filedata']['name']);
if (move_uploaded_file($_FILES['Filedata']['tmp_name'], $uploadPath))
{
     echo "OK";
}
else
{
     echo "ERROR";
}
?>