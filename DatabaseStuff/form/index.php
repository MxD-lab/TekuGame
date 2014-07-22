<?php
	#Written by Maxwell Perlman
	#Database connection and global variables
	include('../includes/includes.php');
	/*Provided there is a connection to the database and properly formatted data baing submitted...*/
	if(isset($_POST['submit']))
	{
		/*set the phone ID and beacon ID accordingly*/
		$pid = $_POST['phone'];
		$bid = $_POST['beacon'];
		$lon = $_POST['longitude'];
		$lat = $_POST['latitude'];
		/*Run the insert query on the database*/
		$insert = 	"Insert INTO playerandlocation (phoneid, beaconid, longitude, latitude)
					VALUES ('$pid', '$bid' ,'$lon', '$lat')
					ON DUPLICATE KEY UPDATE beaconid='$bid', longitude='$lon', latitude='$lat'";
		$result = mysqli_query($DBC, $insert) or die(mysqli_connect_error());
		echo "Data inserted...";
	}
	else
	{
		echo "You seem to have taken a wrong turn...";
	}
?>
<form method="link" action="http://tekugame.mxd.media.ritsumei.ac.jp/">
	<input type="submit" value="go back...">
</form>

<?php
	/*Query  database for all phones and their nearest beacon location*/
	$query = "SELECT * FROM playerandlocation";
	/*Result of query*/
	$result = mysqli_query($DBC, $query);
	/*Creating an associative array to hold our database values*/
	$phonebeacon_arr = array();
	/*For each row in the database's table: print the phone's ID and it's beacon ID*/
	$returnarray = array();
	if(mysqli_num_rows($result) != 0)
	{
		while ($row = mysqli_fetch_assoc($result))
		{
			#$phonebeacon_arr[$row['PhoneID']] = $row['BeaconID'];
			//$phonebeacon_arr["twitterid"]["phoneid"] = $row['phoneid'];
			$phonebeacon_arr["phoneid"] = $row['phoneid'];
			$phonebeacon_arr["beaconid"] = $row['beaconid'];
			$phonebeacon_arr["longitude"] = $row['longitude'];
			$phonebeacon_arr["latitude"] = $row['latitude'];
			/*$phonebeacon_arr["level"] = $row['level'];
			$phonebeacon_arr["health"] = $row['health'];
			$phonebeacon_arr["currenthealth"] = $row['currenthealth'];
			$phonebeacon_arr["strength"] = $row['strength'];
			$phonebeacon_arr["magic"] = $row['magic'];
			$phonebeacon_arr["speed"] = $row['speed'];
			*/
			array_push($returnarray, $phonebeacon_arr);
		}
	}
	$fp = fopen('../results.json', 'w+');
	fwrite($fp, json_encode($returnarray));
	fclose($fp);
?>