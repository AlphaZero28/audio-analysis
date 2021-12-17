@echo off
call git log -3 --oneline --reverse
set /p message=Message: 
call git add .
echo added to stack
call git commit -m "%message%"
echo commited!
call git push origin master
echo pushed to origin!!
pause