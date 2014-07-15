<?php
	#Database connection and global variables
	include('connection.php');
	/*Query  database for all phones and their nearest beacon location*/
	$query = "SELECT * FROM Phones_and_Beacons";
	/*Result of query*/
	$result = mysqli_query($DBC, $query);
?>
<head>
	<title>Tekupeco D&D</title>
</head>
<body>
	<table style='width:300px'>
		<tr>
			<td>PhoneID</td>
			<td>BeaconID</td>
		</tr>
		<?php
			/*For each row in the database's table: print the phone's ID and it's beacon ID*/
			if(mysqli_num_rows($result) != 0)
			{
				while ($row = mysqli_fetch_assoc($result))
				{
					echo "<tr>";
					echo "<td>" . $row['PhoneID'] . "</td>";
					echo "<td>" . $row['BeaconID'] . "</td>";
					echo "</tr>";
				}
			}
		?>
	</table>
</body>