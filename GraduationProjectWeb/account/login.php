<?php
// 獲取用戶提交的表單數據
session_unset();
session_destroy();
session_start();
$postData = file_get_contents("php://input");
$requestData = json_decode($postData, true);

$email = $requestData['email'];
$password = $requestData['password'];

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


$sql = "SELECT * FROM User WHERE email='$email' AND password='$password'";
// $sql = "SELECT * FROM User WHERE userName='7pp' AND password='7pp'";

// echo "userName:" . $userName;
// echo "password" . $password;
$result = mysqli_query($conn, $sql);

if (mysqli_num_rows($result) > 0) {
    // 登錄成功
    // echo "登錄成功";
    if ($result->num_rows > 0) {
        // 輸出每行數據
        while ($row = $result->fetch_assoc()) {
            $_SESSION['uid'] = $row['id'];
            $uid = $row['id'];
            $userData = array(
                'id' => $uid,
                'userName' => $row["userName"],
                'email' => $row["email"],
                'create_at' => $row["create_at"],
                'message' => 'User login successfully'
            );
            $jsonData = json_encode($userData);
            echo $jsonData;
        }

    } else {
        echo "0 個結果";
    }
} else {
    // 登錄失敗
    $userData = array(
        'id' => "null",
        'userName' => "null",
        'email' => "null",
        'create_at' => "null",
        'message' => "no such account"
    );
    // $userData = array('message' => "no such account");
    echo json_encode($userData);
}

// 關閉與 MySQL 的連接
$conn->close();
?>