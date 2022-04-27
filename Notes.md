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

