<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

require_once 'db.php';

$input = json_decode(file_get_contents("php://input"), true);

$nom = $input['nom'] ?? '';
$prenom = $input['prenom'] ?? '';
$email = $input['email'] ?? '';
$password = $input['password'] ?? '';

if (!$nom || !$prenom || !$email || !$password) {
    echo json_encode(['success' => false, 'message' => 'Champs manquants']);
    exit;
}

$hashedPassword = password_hash($password, PASSWORD_BCRYPT);

try {
    $stmt = $conn->prepare("INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, role, points) VALUES (?, ?, ?, ?, 'etudiant', 0)");
    $stmt->execute([$nom, $prenom, $email, $hashedPassword]);

    echo json_encode(['success' => true]);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Erreur : ' . $e->getMessage()]);
}

