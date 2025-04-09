<?php
require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/../db.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$token = str_replace('Bearer ', '', $authHeader);

$secretKey = "super_secret_key_123";

$user = null;

if ($token) {
    try {
        $decoded = JWT::decode($token, new Key($secretKey, 'HS256'));
        $user = $decoded;
    } catch (Exception $e) {
        $user = null;
    }
}