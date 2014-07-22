<?php
	#Written by Maxwell Perlman
	#Database connection and global variables
	include('includes/includes.php');
	/*Query  database for all phones and their nearest beacon location*/
	$query = "SELECT * FROM playerandlocation";
	/*Result of query*/
	$result = mysqli_query($DBC, $query);
?>
<head>
	<title>Tekupeco Databases</title>
</head>
<body>
	<div class="row">
		<div class="col-md-1 col-md-offset-2">TwitterID</div>
		<div class="col-md-1">BeaconID</div> 
		<div class="col-md-1">Longitude</div> 
		<div class="col-md-1">Latitude</div> 
		<!--
		<div class="col-md-1">Level</div>
		<div class="col-md-1">Health</div>
		<div class="col-md-1">Current Health</div>
		<div class="col-md-1">Strength</div>
		<div class="col-md-1">Magic</div>
		<div class="col-md-1">Speed</div>
		-->
	</div>
	<?php
		/*Creating an associative array to hold our database values*/
		$phonebeacon_arr = array();
		/*For each row in the database's table: print the phone's ID and it's beacon ID*/
		if(mysqli_num_rows($result) != 0)
		{
			while ($row = mysqli_fetch_assoc($result))
			{
				$phonebeacon_arr[$row['PhoneID']] = $row['BeaconID'];
				echo "<div class='row'>";
					echo "<div class='col-md-1 col-md-offset-2'>" . $row['phoneid'] . "</div>";
					echo "<div class='col-md-1'>" . $row['beaconid'] . "</div>";
					echo "<div class='col-md-1'>" . $row['longitude'] . "</div>";
					echo "<div class='col-md-1'>" . $row['latitude'] . "</div>";
					/*
					echo "<div class='col-md-1'>" . $row['level'] . "</div>";
					echo "<div class='col-md-1'>" . $row['health'] . "</div>";
					echo "<div class='col-md-1'>" . $row['currenthealth'] . "</div>";
					echo "<div class='col-md-1'>" . $row['strength'] . "</div>";
					echo "<div class='col-md-1'>" . $row['magic'] . "</div>";
					echo "<div class='col-md-1'>" . $row['speed'] . "</div>";
					 */
				echo "</div>";
			}
		}
		else
		{
			echo "error";
		}
	?>
	</div>
</body>