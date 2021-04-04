function Create-Task{
#Credentials to run task as
$username = "$env:USERDOMAIN\$env:USERNAME" #current user
$password = "notmypass"

#Location of Scripts:
$psscript = "C:\test\helloWorld.ps1"
$Sourcedir ="C:\testsource\"
$destdir = "C:\testdest\"
$archivepassword = "notmypass"

####### Create New Scheduled Task
$action = New-ScheduledTaskAction -Execute "Powershell" -Argument "-WindowStyle Hidden '$EncryptSync' '$sourcedir' '$destdir' '$archivepassword'"
$trigger = New-ScheduledTaskTrigger -Once -At 7am -RepetitionDuration  (New-TimeSpan -Days 1)  -RepetitionInterval  (New-TimeSpan -Minutes 30)
$settings = New-ScheduledTaskSettingsSet -Hidden -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable
$ST = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings
Register-ScheduledTask "EncryptSyncTEST" -InputObject $ST -User $username -Password $password


[xml]$EncryptSyncST = Export-ScheduledTask "EncryptSyncTEST"
$UpdatedXML = [xml]'<CalendarTrigger xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"><Repetition><Interval>PT30M</Interval><Duration>P1D</Duration><StopAtDurationEnd>false</StopAtDurationEnd></Repetition><StartBoundary>2013-11-18T07:07:15</StartBoundary><Enabled>true</Enabled><ScheduleByDay><DaysInterval>1</DaysInterval></ScheduleByDay></CalendarTrigger>'
$EncryptSyncST.Task.Triggers.InnerXml = $UpdatedXML.InnerXML

Unregister-ScheduledTask "EncryptSyncTEST" -Confirm:$false
Register-ScheduledTask "EncryptSyncTEST" -Xml $EncryptSyncST.OuterXml -User $username -Password $password
}
function Change-TaskStatus{
}
function Get-AllTasks{
Get-ScheduledTask | Get-ScheduledTaskInfo -AsJob
}