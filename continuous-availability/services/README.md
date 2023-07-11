Oracle recommends using Oracle Clusterware to manage services and send Fast Application Notification events via the Oracle Notification Service to improve the application response to planned and unplanned failover.

If you have Oracle Clusterware, use the examples in this README to create, start, stop, and relocate database services.

For more information about continuous application availability, read:

https://docs.oracle.com/en/database/oracle/oracle-database/19/haovw/configuring-continuous-availability-applicationsconfiguring-continuous-availability-applicatio.html#GUID-5EBF37EA-48AB-4508-A14E-86A2583A24BF



# About the examples

The examples in this section use environment variables ready to integrate in `bash` scripts.
You can set such variables as follows:
```
DB_UNIQUE_NAME=mydb
PDB_NAME=mypdb
PRI_SERVICE_NAME=mypdb_rw
SBY_SERVICE_NAME=mypdb_ro
SID1=mydb1
SID2=mydb2
DRAIN_TIMEOUT=300
```

# Create services for high availability

1. Transparent Application Continuity singleton Real Application Clusters service

  ```
srvctl add service -db ${DB_UNIQUE_NAME} -service ${PRI_SERVICE_NAME} \
 -pdb ${PDB_NAME} -preferred ${SID1} -available ${SID2} \
 -commit_outcome TRUE -failovertype AUTO -notification TRUE \
 -drain_timeout ${DRAIN_TIMEOUT} -stopoption IMMEDIATE -role PRIMARY
```

2. Transparent Application Continuity multi-instance Real Application Clusters service

  ```
srvctl add service -db ${DB_UNIQUE_NAME} -service ${PRI_SERVICE_NAME} \
 -pdb ${PDB_NAME} -preferred ${SID1},${SID2} \
 -commit_outcome TRUE -failovertype AUTO -notification TRUE \
 -drain_timeout ${DRAIN_TIMEOUT} -stopoption IMMEDIATE -role PRIMARY
```

3. Service for the Oracle Active Data Guard standby role
  ```
srvctl add service -db ${DB_UNIQUE_NAME} -service ${SBY_SERVICE_NAME} \
 -pdb ${PDB_NAME} –preferred ${SID1} -available ${SID2} -notification TRUE \
 -drain_timeout ${DRAIN_TIMEOUT} -stopoption IMMEDIATE -role PHYSICAL_STANDBY
```

# Stop a database instance (primary or standby) and the services running on it

1. Stop one instance (inst1) with all associated services' configured -drain_timeout and -stopoption parameters

  ```
srvctl stop instance -db ${DB_UNIQUE_NAME} -instance ${SID1} \
 -force -failover -verbose
```

2. Stop an instance with explicit draining timeout and stop option, overriding the parameters configured for the associated services.

  ```
srvctl stop instance -db ${DB_UNIQUE_NAME} -instance ${SID1} \
 -stopoption IMMEDIATE -drain_timeout ${DRAIN_TIMEOUT} -force -failover -verbose
 ```

# Stop a service

1. Stop a service on an instance with explicit draining parameters.

  ```
srvctl stop service -db ${DB_UNIQUE_NAME} -service ${PRI_SERVICE_NAME} \
 -instance ${SID1} -drain_timeout ${DRAIN_TIMEOUT} -stopoption IMMEDIATE \
 -force -failover
```

# Relocate all the service from one instance to another

1. Relocate all the services of a specific PDB

  ```
srvctl relocate service -database ${DB_UNIQUE_NAME} \
  -pdb ${PDB_NAME} -oldinst ${SID1} -newinst ${SID2} \
  -drain_timeout ${DRAIN_TIMEOUT} -stopoption IMMEDIATE -force
```

2. Relocate all the services in all PDBs

  ```
srvctl relocate service -database ${DB_UNIQUE_NAME} \
 -oldinst ${SID1} -newinst ${SID2} \
 -drain_timeout ${DRAIN_TIMEOUT} -stopoption IMMEDIATE -force
```

# Switch over to a standby database

Always use the Data Guard broker to configure and manage your database for Data Guard.
The broker integrates with Oracle Clusterware for session draining, FAN notifications, and role changes in the Clusterware configuration.

1. Switch over overriding the configured service timeouts

  ```
SWITCHOVER TO <db_unique_name> WAIT 60
```

2. Switch over using the wait timeout configured for the services

  ```
SWITCHOVER TO <db_unique_name> WAIT
```

# Read more
* Real Application Clusters Administration and Deployment Guide -  SRVCTL Command Reference

  https://docs.oracle.com/en/database/oracle/oracle-database/19/racad/server-control-utility-reference.html#GUID-EC1BA6D7-D538-4E11-9B31-C59389FDF93B

* Oracle Data Guard Broker Switchover and Failover Operations

  https://docs.oracle.com/en/database/oracle/oracle-database/19/dgbkr/using-data-guard-broker-to-manage-switchovers-failovers.html
