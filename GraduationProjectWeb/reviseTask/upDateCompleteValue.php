<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

$uid = $_SESSION['uid'];

$todo_id = $data['id'];
$RecurringStartDate = $data['RecurringStartDate'];
$RecurringEndDate = $data['RecurringEndDate'];
$completeValue = $data['completeValue'];
$message = "";

$servername = "localhost"; // 資料庫伺服器名稱
$user = "kumo"; // 資料庫使用者名稱
$pass = "coco3430"; // 資料庫使用者密碼
$dbname = "spaced"; // 資料庫名稱

// 建立與 MySQL 資料庫的連接
$conn = new mysqli($servername, $user, $pass, $dbname);
// 檢查連接是否成功
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$TodoSql = "UPDATE RecurringInstance 
SET `completeValue` = '$completeValue'WHERE `todo_id` = '$todo_id' && `RecurringEndDate` = '$RecurringEndDate' && `RecurringStartDate` = '$RecurringStartDate' ;";

if ($conn->query($TodoSql) === TRUE) {
        $message = "User upDateCompleteValue successfully";
} else {
    $message = $message . 'User upDateCompleteValue - Error: ' . $sql . '<br>' . $conn->error;
    $conn->error;
}

$userData = array(
    'todo_id' => $todo_id,
    'RecurringStartDate' => $RecurringStartDate,
    'RecurringEndDate' => $RecurringEndDate,
    'completeValue' => $completeValue,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>