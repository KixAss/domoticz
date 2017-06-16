#!/usr/bin/php
<?php
/*
Script (C) KixAss 2013 - pebble_tv@kixass.net

For use with PebbleUPC - Controling your Horizonbox from your wrist.
*/

function makeBuffer($data)
{
    $data = str_replace(" ", "", $data);
    return hex2bin($data);
}

function makeBuffer2($data)
{
    $data = str_replace(" ", "", $data);
    return bin2hex($data);
}

$localip = $_GET["localip"];
$localip = "192.168.192.100";
if (empty($localip))
    exit("No local ip given");

$localport = $_GET["localport"];
$localport = 5900;
if (empty($localport))
    exit("No local port given");

$key = $_GET["key"];
$key = "E0 00";
if (empty($key))
    $key = "E0 00";

if ($sock = fsockopen($localip, $localport))
{
    $data = fgets($sock); // readVersionMsg
    echo "recv version: " . $data . "<br>";
    echo "recv version: " . makeBuffer2($data) . "<br>";

	echo "-----------------------------<br>";

    fwrite($sock, $data); //
//    usleep(500);

    $data = fgets($sock, 2);
    echo "recv: " . $data . "<br>";
    echo "recv: " . makeBuffer2($data) . "<br>";

	echo "-----------------------------<br>";

    fwrite($sock, makeBuffer("01")); // Send Ack
//    usleep(500);


    $data = fgets($sock, 4);
    echo "recv: " . $data . "<br>";
    echo "recv: " . makeBuffer2($data) . "<br>";

	echo "-----------------------------<br>";

//	fwrite($sock, makeBuffer("01")); // Send Ack
//    usleep(500);


    $data = fgets($sock, 24);
    echo "recv: " . $data . "<br>";
    echo "recv: " . makeBuffer2($data) . "<br>";

	echo "-----------------------------<br>";
	
//	fwrite($sock, makeBuffer("02 00 00 01 00 00 00 00")); // Send specifications
//    usleep(500);

	echo "-----------------------------<br>";

    fwrite($sock, makeBuffer("04 01 00 00 00 00 " . $key)); // Turn key on
    usleep(400);

	echo "-----------------------------<br>";

	fwrite($sock, makeBuffer("04 00 00 00 00 00 " . $key)); // Turn key off

    fclose($sock);
    
//    usleep(1000);
    
//    include("check_upc.php");
}
?>