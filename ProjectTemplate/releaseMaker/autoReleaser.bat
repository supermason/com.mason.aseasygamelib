rem ������Դ�汾�ļ�version.txt
call E:\OGZQ2_2014\OGZQ2\releaseMaker\resVersionCreator\AutoMD5.exe

rem ɾ��Ŀ���ļ��µ������ļ�
if not exist C:\Users\Administrator\Desktop\OG2Web\ (md C:\Users\Administrator\Desktop\OG2Web\) ^
else (rd /s /q C:\Users\Administrator\Desktop\OG2Web\)

rem ɾ��֮ǰ��ѹ����
if exist C:\Users\Administrator\Desktop\OG2Web.zip (del C:\Users\Administrator\Desktop\OG2Web.zip)

rem �����ļ���ָ��Ŀ¼
xcopy C:\inetpub\wwwroot\OGZQ2_web_root\*.* C:\Users\Administrator\Desktop\OG2Web\ /s /e

rem �������OpenPayQQ.js�ļ�����ɾ��֮
if exist C:\Users\Administrator\Desktop\OG2Web\OpenPayQQ.js (del C:\Users\Administrator\Desktop\OG2Web\OpenPayQQ.js)

rem �������gotoChargePage.js�ļ�����ɾ��֮
if exist C:\Users\Administrator\Desktop\OG2Web\gotoChargePage.js (del C:\Users\Administrator\Desktop\OG2Web\gotoChargePage.js)

rem �Զ���������ļ���������\data�ļ�����
call E:\OGZQ2_2014\OGZQ2\releaseMaker\dataZipper\dataCreator.bat

rem �����µ�Version.php
call E:\OGZQ2_2014\OGZQ2\releaseMaker\gameVersion\VersionMaker.exe

rem ����Version.php��ָ��Ŀ¼
xcopy E:\OGZQ2_2014\OGZQ2\releaseMaker\gameVersion\Version.php C:\Users\Administrator\Desktop\OG2Web\ /s /e

rem �Զ����������Ŀ�ļ�Ϊrar
"D:\Program Files\7-Zip\7z.exe" a -tzip "C:\Users\Administrator\Desktop\OG2Web.zip" "C:\Users\Administrator\Desktop\OG2Web\*" -r