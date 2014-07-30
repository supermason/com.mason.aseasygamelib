rem 生成资源版本文件version.txt
call E:\OGZQ2_2014\OGZQ2\releaseMaker\resVersionCreator\AutoMD5.exe

rem 删除目标文件下的所有文件
if not exist C:\Users\Administrator\Desktop\OG2Web\ (md C:\Users\Administrator\Desktop\OG2Web\) ^
else (rd /s /q C:\Users\Administrator\Desktop\OG2Web\)

rem 删除之前的压缩包
if exist C:\Users\Administrator\Desktop\OG2Web.zip (del C:\Users\Administrator\Desktop\OG2Web.zip)

rem 拷贝文件到指定目录
xcopy C:\inetpub\wwwroot\OGZQ2_web_root\*.* C:\Users\Administrator\Desktop\OG2Web\ /s /e

rem 如果包含OpenPayQQ.js文件，则删除之
if exist C:\Users\Administrator\Desktop\OG2Web\OpenPayQQ.js (del C:\Users\Administrator\Desktop\OG2Web\OpenPayQQ.js)

rem 如果包含gotoChargePage.js文件，则删除之
if exist C:\Users\Administrator\Desktop\OG2Web\gotoChargePage.js (del C:\Users\Administrator\Desktop\OG2Web\gotoChargePage.js)

rem 自动打包数据文件并拷贝到\data文件夹下
call E:\OGZQ2_2014\OGZQ2\releaseMaker\dataZipper\dataCreator.bat

rem 生成新的Version.php
call E:\OGZQ2_2014\OGZQ2\releaseMaker\gameVersion\VersionMaker.exe

rem 拷贝Version.php到指定目录
xcopy E:\OGZQ2_2014\OGZQ2\releaseMaker\gameVersion\Version.php C:\Users\Administrator\Desktop\OG2Web\ /s /e

rem 自动打包整个项目文件为rar
"D:\Program Files\7-Zip\7z.exe" a -tzip "C:\Users\Administrator\Desktop\OG2Web.zip" "C:\Users\Administrator\Desktop\OG2Web\*" -r