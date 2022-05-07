# Oracle Database XE

### db and ords images: https://container-registry.oracle.com/

### Oracle Enterprise Manager

5500 port

### Oracle SQL developer

https://docs.oracle.com/en/database/oracle/sql-developer-web/22.1/sdweb/accessing-sql-developer-web.html

### Can your login in em by remote?

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

从12c开始引入cdb的概念，可以理解cdb是系统数据库，pdb都是它下面的数据业务数据库，可以有多个。同一个用户可以连接系统库cdb，也可以连接pdb，但一次登陆只能连接一个。

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

### Oracle 用户信息保存在哪里

保存在sys下的user$表里面
```
select * from sys.user$;
```
![image](https://user-images.githubusercontent.com/43192516/167233114-29da9925-4014-48db-bb7d-204cb399dad4.png)

### Oracle 用户，表空间，数据文件的关系，查询数据是如何找到相应的数据表的？

 - 数据文件是存储的物理文件，不多做解释
 - 表空间相当于文件夹，里面可以存放多个物理文件；一个物理文件不能同时放入两个文件夹，所以一个dbf文件只能属于一个表空间
 - 创建用户会指定表空间，不指定时会默认在user表空间，这个是数据库实例启动就创建好了的；表空间和用户是多对多的关系，一个用户可以创建多个文件夹，一个文件夹也可以存放多个用户的文件
 
 那通过select查询来分析如何找到表的
用户是通过user名+表名来定位一个表，如果查询自己的表，就省略了用户名；那为什么不用文件夹（表空间）+表名来确定呢？按照oracle的目前的架构设计，逻辑上行不通。
一个文件夹下多个用户都可以放东西，不同的用户还可以放相同名字的东西。导致无法能确定到表
