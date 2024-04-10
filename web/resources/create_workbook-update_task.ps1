<#
Script Name: create_workbook-update_task.ps1

This script automates the execution of the WSL workbook-update.sh script.  That script can still be
run manually in WSL as needed.

This script creates two Windows Scheduled Tasks, one that runs five minutes after LogOn and the second that 
run every six shours with a random start time.

#>

$autoupdate_cmd     = "C:\Windows\system32\wsl.EXE"
$autoupdate_args    = "/mnt/c/SANS/workbook/resources/workbook-update.sh"
$task_name1         = "workbook_update1" # Fires 5 min after logon
$task_name2         = "workbook_update2" # Fires every six hours with a random start time
$task_desc1         = "Checks for EWB updates 5 min after LogOn."
$task_desc2         = "Checks for EWB updates every six hours with random start time."
$group_id           = "BUILTIN\Administrators" # security context the task will run with

$startup_delay      = (New-TimeSpan -Minutes 5)

##############################################

Get-ScheduledTask -TaskName $task_name1 -ErrorAction SilentlyContinue -OutVariable task1_exists

# If the workbook_update schedule task exists, unregister it
if ($task1_exists) {
    Unregister-ScheduledTask  -TaskName $task_name1 -Confirm:$false
}

# Action - What the task will execute.
$action = New-ScheduledTaskAction -Execute $autoupdate_cmd -Argument $autoupdate_args

$trigger1       = New-ScheduledTaskTrigger -AtLogOn
$trigger1.Delay = 'PT5M'

# Define the security context the task will execute with.
$STPrin = New-ScheduledTaskPrincipal -GroupId $group_id

# Create the scheduled task.
$Task1 = Register-ScheduledTask -Action $action -Trigger $trigger1 -TaskName $task_name1 -Description $task_desc1 -Principal $STPrin 

##############################################

Get-ScheduledTask -TaskName $task_name2 -ErrorAction SilentlyContinue -OutVariable task2_exists

# If the workbook_update schedule task exists, unregister it
if ($task2_exists) {
    Unregister-ScheduledTask  -TaskName $task_name2 -Confirm:$false
}

# Action - What the task will execute.
$action = New-ScheduledTaskAction -Execute $autoupdate_cmd -Argument $autoupdate_args

$trigger2 = New-ScheduledTaskTrigger -Once -At ((get-date) + $startup_delay)

# Define the security context the task will execute with.
$STPrin = New-ScheduledTaskPrincipal -GroupId $group_id

# Create the scheduled task.
$Task2 = Register-ScheduledTask -Action $action -Trigger $trigger2 -TaskName $task_name2 -Description $task_desc2 -Principal $STPrin 

# Manually set task duration settings that could not be set with the Register-ScheduledTask command.
$task2.Triggers.Repetition.Duration = "P10D" #Repeat for a duration of one day
$task2.Triggers.Repetition.Interval = "PT6H" #Repeat every 6 hours - for production
$task2 | Set-ScheduledTask
