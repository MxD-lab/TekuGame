<?php
	#Database connection and global variables
	include('../connection.php');
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