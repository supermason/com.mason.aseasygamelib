<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 14-5-26
 * Time: 下午3:33
 */

//用于查询前台版本号的 每次上版本之前要改
$version="2.81";

if(isset($_GET["type"])){
    print($version);
}

