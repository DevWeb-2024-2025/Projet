<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

require_once '../auth/db.php';
require_once '../auth/vendor/autoload.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

// Récupération du token
$headers = getallheaders();
$authHeader = isset($headers['Authorization']) ? $headers['Authorization'] : '';

if (!$authHeader || !str_starts_with($authHeader, 'Bearer ')) {
    echo json_encode(['success' => false, 'message' => 'Token manquant']);
    exit;
}

$token = substr($authHeader, 7);
$secretKey = 'super_secret_key_123';

try {
    $decoded = JWT::decode($token, new Key($secretKey, 'HS256'));
    $userId = $decoded->user_id;
} catch (Exception $e) {
    echo json_encode(['success' => false, 'message' => 'Token invalide']);
    exit;
}

// Récupération des réservations
try {
    $stmt = $conn->prepare("SELECT * FROM reservation WHERE utilisateur_id = ?");
    $stmt->execute([$userId]);
    $reservations = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode(['success' => true, 'reservations' => $reservations]);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Erreur : ' . $e->getMessage()]);
}



