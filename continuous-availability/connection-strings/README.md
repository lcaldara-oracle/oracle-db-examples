# Full connection descriptors (recommended)

## Oracle Real Application Clusters without a standby database

The recommended connection descriptor for Oracle Real Application Clusters without a standby database is the following:

```
  (DESCRIPTION =
    (CONNECT_TIMEOUT= 90)(RETRY_COUNT=30)(RETRY_DELAY=2)
    (TRANSPORT_CONNECT_TIMEOUT=1000ms)
    (ADDRESS_LIST =
      (LOAD_BALANCE=on)
      (ADDRESS = (PROTOCOL = TCP)(HOST=<rac-scan-name>)(PORT=<port_number>)))
    (CONNECT_DATA=(SERVICE_NAME = <service_name>)))
```

## For Oracle Real Application Clusters with a standby database

The recommended connection descriptor for Oracle Real Application Clusters with a standby database is the following:

```
  (DESCRIPTION =
    (CONNECT_TIMEOUT= 90)(RETRY_COUNT=150)(RETRY_DELAY=2)
    (TRANSPORT_CONNECT_TIMEOUT=1000ms)
    (ADDRESS_LIST =
      (LOAD_BALANCE=on)
      (ADDRESS = (PROTOCOL = TCP)(HOST=clu_site1-scan)(PORT=1521)))
    (ADDRESS_LIST =
      (LOAD_BALANCE=on)
      (ADDRESS = (PROTOCOL = TCP)(HOST=clu_site2-scan)(PORT=1521)))
    (CONNECT_DATA=(SERVICE_NAME = my_service)))
```

For more information, read:
* [Net Services Administrator's Guide - Configuring Naming Methods](https://docs.oracle.com/en/database/oracle/oracle-database/19/netag/configuring-naming-methods.html#GUID-E5B6BEB9-70BB-46FA-9F6C-BE575CD41B21)
* [High Availability Overview and Best Practices - Configuring Continuous Availability for Applications](https://docs.oracle.com/en/database/oracle/oracle-database/19/haovw/configuring-continuous-availability-applicationsconfiguring-continuous-availability-applicatio.html#GUID-5EBF37EA-48AB-4508-A14E-86A2583A24BF)
* [High Availability Overview and Best Practices - Step 2: Configure the Connection String for High Availability](https://docs.oracle.com/en/database/oracle/oracle-database/19/haovw/configuring-level-1-basic-application-high-availability.html#GUID-526F4E44-1F2B-427B-A96F-3243CEF3DA17)

## Direct usage inside the code

You can use full connection descriptors directly inside your code, for example:

```
// Java
private final static String DEFAULT_URL =
  "jdbc:oracle:thin:@" +
  "(DESCRIPTION =" +
  "  (CONNECT_TIMEOUT= 90)(RETRY_COUNT=30)(RETRY_DELAY=2)" +
  "  (TRANSPORT_CONNECT_TIMEOUT=1000ms)" +
  "  (ADDRESS_LIST =" +
  "    (LOAD_BALANCE=on)" +
  "    (ADDRESS = (PROTOCOL = TCP)(HOST=<rac-scan-name>)(PORT=<port_number>)))" +
  "  (CONNECT_DATA=(SERVICE_NAME = <service_name>)))";
```

```
# Python
connect_string = """<user>/<password>@(DESCRIPTION =
    (CONNECT_TIMEOUT= 90)(RETRY_COUNT=30)(RETRY_DELAY=2)
    (TRANSPORT_CONNECT_TIMEOUT=1000ms)
    (ADDRESS_LIST =
      (LOAD_BALANCE=on)
      (ADDRESS = (PROTOCOL = TCP)(HOST=<rac-scan-name>)(PORT=<port_number>)))
    (CONNECT_DATA=(SERVICE_NAME = <service_name>)))
"""
```

## Using TNSNAMES resolution

A better and more maintainable approach is to use a file [tnsnames.ora](./tnsnames.ora) that declares aliases for the connection descriptors used by the application:

```
# definition in tnsnames.ora
<alias> = (DESCRIPTION =
    (CONNECT_TIMEOUT= 90)(RETRY_COUNT=30)(RETRY_DELAY=2)
    (TRANSPORT_CONNECT_TIMEOUT=1000ms)
    (ADDRESS_LIST =
      (LOAD_BALANCE=on)
      (ADDRESS = (PROTOCOL = TCP)(HOST=<rac-scan-name>)(PORT=<port_number>)))
    (CONNECT_DATA=(SERVICE_NAME = <service_name>)))
```

and reference the alias in the URL.

```
// Java
private final static String DEFAULT_URL = "jdbc:oracle:thin:@<alias>";"
```

```
# Python
connect_string = "<user>/<password>@<alias>"
```

Oracle recommends to maintain your connect strings or URL in a central location, such as LDAP or tnsnames.ora. Do not scatter the connect string or URL in property files or private locations, as doing so makes it extremely difficult to maintain. Using a centralized location helps you preserve standard format, tuning, and service settings. Oracle's solution for this is to use LDAP with the Oracle Unified Directory product.

Read more:
* [Example: tnsnames.ora](./tnsnames.ora)
* [Connection Time Estimates During Data Guard Switchover or Failover](https://docs.oracle.com/en/database/oracle/oracle-database/19/haovw/connection-time-estimates-data-guard-switchover-or-failover.html#GUID-5F352DAD-0326-494D-8B9F-A37EFAF0AE0D)
* [Oracle Net TNS String Parameters](https://docs.oracle.com/en/database/oracle/oracle-database/19/haovw/oracle-net-tns-string-parameters.html#GUID-E2003E3B-0316-4CD4-B153-37EF080F1858)
* [Oracle Unified Directory](https://docs.oracle.com/en/middleware/idm/unified-directory/12.2.1.4/oudag/introduction-oracle-unified-directory.html#GUID-53DE34B1-370C-4C09-93EB-F5FAE76CCA02)
* [Overview of Local Naming Parameters](https://docs.oracle.com/pls/topic/lookup?ctx=en/database/oracle/oracle-database/19/haovw&id=NETRF-GUID-12C94B15-2CE1-4B98-9D0C-8226A9DDF4CB)

# EZConnect and EZConnect Plus (not recommended for high availability)

It's common to see and use *EZConnect* as it is the simplest form of connection descriptor to connect to the Oracle Database:

```
//<host_name>:<port_number>/<service_name>
```

For example, many Java code samples in this repository set the descriptor (JDBC URL) as follows:

```
private final static String DEFAULT_URL = "jdbc:oracle:thin:@//myhost:myport/myservice";
```

This particular format is called *Easy Connect*, or *EZConnect*.

*EZConnect* has basic capabilities to specify highly available connection strings such as:

```
//host1,host2/my_service?CONNECT_TIMEOUT=240&RETRY_COUNT=150&RETRY_DELAY=2&TRANSPORT_CONNECT_TIMEOUT=3
```

You can read more about this format here:
https://download.oracle.com/ocomdocs/global/Oracle-Net-19c-Easy-Connect-Plus.pdf

**For the purpose of Continuous Application Availability, Oracle discourages using *EZConnect*.**

Instead, the recommendation is to use full-fledged descriptors.
