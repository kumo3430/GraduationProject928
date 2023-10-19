<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

$uid = $_SESSION['uid'];

$todo_id = $data['id'];
$checkDate = date("Y-m-d");
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

$TodoSELSql = "SELECT * FROM `RecurringInstance` WHERE todo_id = '$todo_id' && `RecurringEndDate` = '$RecurringEndDate' && `RecurringStartDate` = '$RecurringStartDate';";

$result = $conn->query($TodoSELSql);
if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $Instance_id = $row['id'];
    $completeValueOld = $row['completeValue'];
    $completeValueNew = $completeValueOld + $completeValue;

    $CheckSql = "INSERT INTO `RecurringCheck` (`Instance_id`, `checkDate`, `completeValue`) VALUES ('$Instance_id', '$checkDate', '$completeValue');";

    if($conn->query($CheckSql) === TRUE) {
        $message = "User New RecurringCheck successfully";

        $TodoSql = "UPDATE RecurringInstance 
        SET `completeValue` = '$completeValueNew'WHERE `todo_id` = '$todo_id' && `RecurringEndDate` = '$RecurringEndDate' && `RecurringStartDate` = '$RecurringStartDate' ;";
        
        if ($conn->query($TodoSql) === TRUE) {
                $message = "User upDateCompleteValue successfully";
        } else {
            $message = $message . 'User upDateCompleteValue - Error: ' . $sql . '<br>' . $conn->error;
            $conn->error;
        }
    } else {
        $message = "New RecurringCheck - Error: " . $InstanceSql . '<br>' . $conn->error; 
        if ($conn->connect_error) {
            $message =  die("Connection failed: " . $conn->connect_error);
        }
    }
} else {
    $message = "No results found";
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