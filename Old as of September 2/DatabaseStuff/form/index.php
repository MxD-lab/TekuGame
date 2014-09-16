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
<!-- OUTPUT ALL TABLES TO JSON -->
<?php
	/*Query  database for all phones and their nearest beacon location*/
	$query = "SELECT * FROM playerandlocation";
	/*Result of query*/
	$result = mysqli_query($DBC, $query);
	/*Creating an associative array to hold our database values*/
	$player_arr = array();
	/*For each row in the database's table: print the phone's ID and it's beacon ID*/
	$returnarray = array();
	if(mysqli_num_rows($result) != 0)
	{
		while ($row = mysqli_fetch_assoc($result))
		{
			$player_arr["phoneid"] = $row['phoneid'];
			$player_arr["beaconid"] = $row['beaconid'];
			$player_arr["longitude"] = $row['longitude'];
			$player_arr["latitude"] = $row['latitude'];
			array_push($returnarray, $player_arr);
		}
	}
	$fp = fopen('../json/playerandlocation.json', 'w+');
	fwrite($fp, json_encode($returnarray));
	fclose($fp);
?>
<?php
	/*Query  database for all phones and their nearest beacon location*/
	$query = "SELECT * FROM playerabilities";
	/*Result of query*/
	$result = mysqli_query($DBC, $query);
	/*Creating an associative array to hold our database values*/
	$player_ability_arr = array();
	/*For each row in the database's table: print the phone's ID and it's beacon ID*/
	$returnarray = array();
	if(mysqli_num_rows($result) != 0)
	{
		while ($row = mysqli_fetch_assoc($result))
		{
			$player_ability_arr["playerid"] = $row['playerid'];
			$player_ability_arr["physicalabilities"] = $row['physicalabilities'];
			$player_ability_arr["magicalabilities"] = $row['magicalabilities'];
			array_push($returnarray, $player_ability_arr);
		}
	}
	$fp = fopen('../json/playerabilities.json', 'w+');
	fwrite($fp, json_encode($returnarray));
	fclose($fp);
?>
<?php
	/*Query  database for all phones and their nearest beacon location*/
	$query = "SELECT * FROM beacon";
	/*Result of query*/
	$result = mysqli_query($DBC, $query);
	/*Creating an associative array to hold our database values*/
	$beacon_arr = array();
	/*For each row in the database's table: print the phone's ID and it's beacon ID*/
	$returnarray = array();
	if(mysqli_num_rows($result) != 0)
	{
		while ($row = mysqli_fetch_assoc($result))
		{
			$beacon_arr["ID"] = $row['ID'];
			$beacon_arr["longitude"] = $row['longitude'];
			$beacon_arr["latitude"] = $row['latitude'];
			array_push($returnarray, $beacon_arr);
		}
	}
	$fp = fopen('../json/beacons.json', 'w+');
	fwrite($fp, json_encode($returnarray));
	fclose($fp);
?>