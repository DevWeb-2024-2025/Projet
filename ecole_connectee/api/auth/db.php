<?php
$host = "localhost";
$dbname = "ecoleconnectee";
$username = "root";
$password = "amine123";

try {
    echo "DEBUG DB.PHP<br>";
    $conn = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Erreur connexion : " . $e->getMessage());
}