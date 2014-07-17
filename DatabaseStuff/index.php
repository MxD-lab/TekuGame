<?php
	#Written by Maxwell Perlman
	#Database connection and global variables
	include('includes/includes.php');
	/*Query  database for all phones and their nearest beacon location*/
	$query = "SELECT * FROM Phones_and_Beacons";
	/*Result of query*/
	$result = mysqli_query($DBC, $query);
?>
<head>
	<title>Tekupeco Databases</title>
</head>
<body>
	<div class="row">
		<div class="col-md-2 col-md-offset-5">PhoneID</div>
		<div class="col-md-2">BeaconID</div>
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
					echo "<div class='col-md-2 col-md-offset-5'>" . $row['PhoneID'] . "</div>";
					echo "<div class='col-md-2'>" . $row['BeaconID'] . "</div>";
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