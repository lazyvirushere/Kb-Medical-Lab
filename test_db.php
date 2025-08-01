<?php
require_once 'php/config.php';
echo "Connected successfully to: " . DB_NAME;
$result = $conn->query("SHOW TABLES");
while ($row = $result->fetch_array()) {
    echo "<br>" . $row[0];
}
?>