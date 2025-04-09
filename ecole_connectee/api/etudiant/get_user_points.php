<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Authorization, Content-Type");
header("Content-Type: application/json");

require_once '../auth/auth.php'; // Assure-toi que ce fichier existe
require_once __DIR__ . '/../db.php';

if (!$user || !isset($user->user_id)) {
    echo json_encode(["success" => false, "message" => "Token manquant ou invalide"]);
    exit;
}

try {
    $stmt = $conn->prepare("SELECT points FROM utilisateur WHERE id = ?");
    $stmt->execute([$user->user_id]);
    $points = $stmt->fetchColumn();

    echo json_encode(["success" => true, "points" => intval($points)]);
} catch (Exception $e) {
    echo json_encode(["success" => false, "message" => "Erreur serveur : " . $e->getMessage()]);
}