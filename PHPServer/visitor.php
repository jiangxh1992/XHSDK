<?php
/////////////////请求参数解析////////////////////
// 获取参数json字符串
$jsonstr = $_POST["param"];
// json字符串转json对象
$json = json_decode($jsonstr);
// 读取各个参数
$device = $json->device;

/////////////////链接数据库//////////////////////
// 数据库服务器名
$mysql_server_name = "localhost:/tmp/mysql.sock";
// mysql用户名
$myssql_username = "root";
// mysql用户密码
$mysql_password = "123456";
// 数据库名
$mysql_database = "argame";

// 连接数据库
$con = mysql_connect($mysql_server_name, $myssql_username, $mysql_password);

// 检测是否连接失败
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }

// 打开数据库
mysql_select_db($mysql_database);
// 获取已有uid最大值，并自增1作为新uid
$sql_max = "select max(uid) from visitor";
// 执行查找语句
$max_uid = mysql_query($sql_max, $con);
// 新uid
$new_id = mysql_fetch_array($max_uid)[0] + 1;
$new_username = "No.".$new_id." Visitor";
$new_password = strval($new_id);

// 插入新用户
$sql_update = "insert into visitor(uid,username,password) values(".$new_id.",'".$new_username."','".$new_password."');";
// 判断用户是否已存在

// 执行更新语句
$sql_update_res = mysql_query($sql_update, $con);

/////////////////验证结果并返回响应结果/////////////////
if ($sql_update_res) {
	$array = array('code' => 0, 'msg' => 'register sucesss!', 'data' => array('open_id' => strval($new_id),'username' => $new_username, 'password' => $new_password));
	exit(json_encode($array));
}
else {
	$array = array('code' => 1, 'msg' => 'register failure!');
	exit(json_encode($array));
}

// 关闭数据库
mysql_close($con);

?>