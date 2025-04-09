<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Headers: Authorization");

require_once '../auth/db.php';
require_once '../../vendor/autoload.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

// Récupération du token depuis l'en-tête
$headers = apache_request_headers();
$authHeader = isset($headers['Authorization']) ? $headers['Authorization'] : '';

if (!$authHeader || !str_starts_with($authHeader, 'Bearer ')) {
    echo json_encode(['success' => false, 'message' => 'Token manquant']);
    exit;
}

$token = trim(str_replace('Bearer', '', $authHeader));
$secretKey = "super_secret_key_123"; // Même clé que dans login.php

try {
    $decoded = JWT::decode($token, new Key($secretKey, 'HS256'));
    $userId = $decoded->user_id;

    $stmt = $conn->prepare("SELECT id, nom, prenom, email, points FROM utilisateur WHERE id = ?");
    $stmt->execute([$userId]);
    $profil = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($profil) {
        echo json_encode(['success' => true, 'profil' => $profil]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Utilisateur non trouvé']);
    }

} catch (Exception $e) {
    echo json_encode(['success' => false, 'message' => 'Token invalide : ' . $e->getMessage()]);
}
?>
