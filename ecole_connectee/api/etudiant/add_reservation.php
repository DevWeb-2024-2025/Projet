<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

require_once '../auth/db.php';
require_once '../auth/vendor/autoload.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Méthode non autorisée']);
    exit;
}

// Authentification via token
$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';

if (!$authHeader || !str_starts_with($authHeader, 'Bearer ')) {
    echo json_encode(['success' => false, 'message' => 'Token manquant']);
    exit;
}

$token = substr($authHeader, 7);
$secretKey = 'super_secret_key_123';

try {
    $decoded = JWT::decode($token, new Key($secretKey, 'HS256'));
    $userId = $decoded->user_id ?? null;

    if (!$userId) {
        echo json_encode(['success' => false, 'message' => 'Token invalide (user_id manquant)']);
        exit;
    }

} catch (Exception $e) {
    echo json_encode(['success' => false, 'message' => 'Token invalide']);
    exit;
}

// Lecture des données envoyées
$input = json_decode(file_get_contents("php://input"), true);
$type = $input['type'] ?? '';
$dateDebut = $input['date_debut'] ?? '';
$dateFin = $input['date_fin'] ?? '';

if (!$type || !$dateDebut || !$dateFin) {
    echo json_encode(['success' => false, 'message' => 'Champs manquants']);
    exit;
}

// Préparation des IDs
$salleId = $posteId = $materielId = null;

if ($type === 'salle') {
    $salleId = 1;
} elseif ($type === 'poste') {
    $posteId = 1;
} elseif ($type === 'materiel') {
    $materielId = 1;
} else {
    echo json_encode(['success' => false, 'message' => 'Type de réservation invalide']);
    exit;
}

// Insertion
try {
    $stmt = $conn->prepare("INSERT INTO reservation (utilisateur_id, type, salle_id, poste_id, materiel_id, date_debut, date_fin)
                            VALUES (?, ?, ?, ?, ?, ?, ?)");

    $stmt->execute([
        $userId,
        $type,
        $salleId,
        $posteId,
        $materielId,
        $dateDebut,
        $dateFin
    ]);

    echo json_encode(['success' => true, 'message' => 'Réservation enregistrée']);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Erreur BDD : ' . $e->getMessage()]);
}
