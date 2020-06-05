makebin-auto.sh - creates a self-extracting installer
#prepare
```
mkdir ./import
cp -a your_porject ./import
```
if your_porject is a directory, rename your script.sh to your_project.sh
#run 
```
bash exec.sh
```
#binary
find your binary in exec/your_time/ directory 
#log
look for your logs in logs directory

#attention
Please make sure that your script will not generate any files in your current directory
Please make sure that your environment variables are clearly written in your script


