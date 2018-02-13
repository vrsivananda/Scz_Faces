## Changes you need to do before testing on psiTurk:

### (1) config.txt
— Change the title and description to suit your own study<br/>
— Change <databaseLogin> and <databasePassword> to the database login username and password respectively (including the “<” and “>”)<br/>

<——In the templates folder——>

### (2) ad.html
— Change the amount of time and the compensation amount<br/>

### (3) consent.html
— Change the purpose of the study<br/>
— Change the Task<br/>
— Change the time it takes to complete the study<br/>
— Change the amount breaks and the time per break<br/>
— Change the compensation amount, the partial compensation amount, and the expected and maximum time the study should take<br/>

### (4) database_connect.php
— Change <databaseLogin> and <databasePassword> to the database login username and password respectively (including the “<” and “>”)<br/>

### (5) exp.html
— Add in the plugins in the <head> of the html file<br/>
— Add in the variables for username, tableName, and folderName<br/>
— Add your experiment into the space denoted by the comment “Your code below this line”<br/>
- Change the data switches accordingly<br/>
