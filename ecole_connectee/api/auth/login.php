<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

require_once 'db.php';
require_once 'vendor/autoload.php';

use Firebase\JWT\JWT;

$input = json_decode(file_get_contents("php://input"), true);
$email = $input['email'] ?? '';
$password = $input['password'] ?? '';

if (!$email || !$password) {
    echo json_encode(["success" => false, "message" => "Champs manquants"]);
    exit;
}

try {
    $stmt = $conn->prepare("SELECT * FROM utilisateur WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user && password_verify($password, $user['mot_de_passe'])) {
        $secretKey = "super_secret_key_123";

        $payload = [
            "user_id" => $user["id"],
            "email" => $user["email"],
            "exp" => time() + (60 * 60)
        ];

        $jwt = JWT::encode($payload, $secretKey, 'HS256');

        echo json_encode(["success" => true, "token" => $jwt]);
    } else {
        echo json_encode(["success" => false, "message" => "Identifiants invalides"]);
    }
} catch (Exception $e) {
    echo json_encode(["success" => false, "message" => "Erreur serveur : " . $e->getMessage()]);
}

