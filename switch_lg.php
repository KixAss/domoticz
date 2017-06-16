#!/usr/bin/php
<?php
ini_set('error_reporting', E_ALL);

$localip = "192.168.192.188";
$localport = "8080";
$pairkey = "878905";
$a = 3;

function doRequest($url, $data)
{
	// create curl resource
	$ch = curl_init();

	// set url
	curl_setopt($ch, CURLOPT_URL, $url);

	//return the transfer as a string
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
												'Content-Type: text/xml; charset=utf-8',
												'User-agent: UDAP/2.0'
												));

	curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
	curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_HEADER, 1);

	// $output contains the output string
	$output = curl_exec($ch);

	// close curl resource to free up system resources
	curl_close($ch); 
}
/*
$data = '<?xml version="1.0" encoding="utf-8"?><envelope><api type="pairing"><name>showKey</name></api></envelope>';
$url = "http://" . $localip . ":" .  $localport . "/udap/api/pairing";

doRequest($url, $data);
*/

$data = '<?xml version="1.0" encoding="utf-8"?><envelope><api type="pairing"><name>hello</name><value>'.$pairkey.'</value><port>0</port></api></envelope>';
$url = "http://" . $localip . ":" .  $localport . "/udap/api/pairing";

doRequest($url, $data);

$data = '<?xml version="1.0" encoding="utf-8"?>';
$data.= '<envelope>';
$data.= '<api type="command">';
$data.= '<name>HandleKeyInput</name>';
$data.= '<value>1</value>';
$data.= '</api>';
$data.= '</envelope>';

$url = "http://" . $localip . ":" .  $localport . "/udap/api/command";
doRequest($url, $data);
?>