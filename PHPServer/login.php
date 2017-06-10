<?php
/////////////////请求参数解析////////////////////
// 获取参数json字符串
$jsonstr = $_POST["param"];
// json字符串转json对象
$json = json_decode($jsonstr);
// 读取各个参数
$username = $json->username;
$password = $json->password;
$isvisitor = $json->isvisitor;

/////////////////数据库数据读取//////////////////////
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
// 定义查找sql语句
$sql_table = $isvisitor ? "visitor" : "user";
$sql_query = "select uid,password from ".$sql_table." where username='".$username."';";
// 执行查找语句
$sql_result = mysql_query($sql_query, $con);
// 密码
$sql_password = mysql_fetch_object($sql_result)->password;
// 用户uid
$sql_uid = mysql_fetch_object($sql_result)->uid;

/////////////////验证结果并返回响应结果/////////////////
if ($password == $sql_password) {
	// 验证成功
	$array = array('code' => 0,'msg' => 'login success!', 'data' => array('open_id' => $sql_uid));
	exit(json_encode($array));
}else {
	$array = array('code' => 1, 'msg' => 'login failure!');
	exit(json_encode($array));
}

// 关闭数据库
mysql_close($con);

?>