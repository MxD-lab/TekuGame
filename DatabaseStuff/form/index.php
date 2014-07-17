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
		/*Run the insert query on the database*/
		$insert = "Insert INTO Phones_and_Beacons (PhoneID, BeaconID) VALUES ('$pid', '$bid')";
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
	$query = "SELECT * FROM Phones_and_Beacons";
	/*Result of query*/
	$result = mysqli_query($DBC, $query);
	/*Creating an associative array to hold our database values*/
	$phonebeacon_arr = array();
	/*For each row in the database's table: print the phone's ID and it's beacon ID*/
	if(mysqli_num_rows($result) != 0)
	{
		while ($row = mysqli_fetch_assoc($result))
		{
			$phonebeacon_arr[$row['PhoneID']] = $row['BeaconID'];
		}
	}
	$fp = fopen('../results.json', 'w+');
	fwrite($fp, json_encode($phonebeacon_arr, JSON_FORCE_OBJECT));
	fclose($fp);
?>