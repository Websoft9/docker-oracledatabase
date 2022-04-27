# Oracle Database XE

### db and ords images: https://container-registry.oracle.com/

### Can your access em by public ip?

```
[root@VM-0-11-centos docker-oracledatabase]# docker exec -it oracledb sqlplus / as sysdba

SQL*Plus: Release 21.0.0.0.0 - Production on Wed Apr 27 01:38:44 2022
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.


Connected to:
Oracle Database 21c Express Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0

SQL> EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);

PL/SQL procedure successfully completed.

SQL> 
```

### What is cdb, pdb?

![image](https://user-images.githubusercontent.com/43192516/165426190-d895ea76-1b7e-4630-b420-c2adaec98a20.png)

从12c开始引入cdb的概念，可以理解cdb是系统数据库，pdb都是它下面的数据业务数据库，可以有多个。

如果要通过系统用户sys创建用户，sys用户登陆时默认连接在cdb上就是创建的系统公共用户，必须以c##开头
```
[root@VM-0-11-centos docker-oracledatabase]# docker exec -it oracledb sqlplus / as sysdba

SQL*Plus: Release 21.0.0.0.0 - Production on Wed Apr 27 02:52:16 2022
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.


Connected to:
Oracle Database 21c Express Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0

SQL> create user websoft9 IDENTIFIED by 123456;
create user websoft9 IDENTIFIED by 123456
            *
ERROR at line 1:
ORA-65096: invalid common user or role na
```


我们想创建一个业务相关的数据库用户，需要用sys登陆时连接在具体的某个pdb上，如下列的XEPDB1：

```
[root@VM-0-11-centos docker-oracledatabase]# docker exec -it oracledb sqlplus sys/123456@XEPDB1 as sysdba

SQL*Plus: Release 21.0.0.0.0 - Production on Wed Apr 27 02:18:48 2022
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.


Connected to:
Oracle Database 21c Express Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0

SQL> create user websoft9 IDENTIFIED by 123456;

User created.

SQL> 
```


