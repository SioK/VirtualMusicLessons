<?php

$saveLocation = "files/videos/";
$ffmpegpath = "ffmpeg.exe";
$filename = basename($_FILES['Filedata']['name']);
$filewithoutextension = preg_replace("/\\.[^.]*$/", "",$filename);
$output = "files/thumbnails/". $filewithoutextension . ".jpg";
$uploadPath = $saveLocation . $filename;
if (move_uploaded_file($_FILES['Filedata']['tmp_name'], $uploadPath)) {
	make_jpg($uploadPath, $output);
}

function make_jpg($input, $output, $fromdurasec="00") {
Global $ffmpegpath;

$command = "$ffmpegpath -i $input -an -ss 00:00:$fromdurasec -r 1 -vframes 1 -f mjpeg -y $output";

@exec( $command, $ret );
}
?>