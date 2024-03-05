# Continuous Availability for Your Applications

For simplicity, most examples in this repository use the simplest form of connection descriptor to connect to the Oracle Database:

```
//<host_name>:<port_number>/<service_name>
```

While this is fine when starting to develop on small single-instance environments, critical production environments typically use high-availability solutions like Oracle Real Application Clusters and Oracle Data Guard to keep the service working uninterrupted through planned maintenance and outages.

Oracle provides the technologies to achieve end-to-end continuous availability so that your application users do not experience downtime or unexpected errors due to disconnection from the database.

To get this result, you must ensure that your applications are configured to quickly and automatically shift the workload to available Oracle RAC instances or standby databases.<br />
Implement Oracle recommendations for high availability at the earliest stage of your application lifecycle to avoid the burden of changing the configuration later.

For additional information, please read: [High Availability Overview and Best Practices: Continuous Availability for Applications](https://docs.oracle.com/en/database/oracle/oracle-database/19/haovw/configuring-continuous-availability-applicationsconfiguring-continuous-availability-applicatio.html#GUID-5EBF37EA-48AB-4508-A14E-86A2583A24BF)

## Application High Availability Levels

Depending on your application's high availability requirements, you can implement the level of high availability (HA) protection that you need.

### Level 1: Basic Application High Availability

Follow these steps to implement faster, automatic failover to an available database instance:

1. [Configure database services with high availability](./services/)
2. [Configure the connection strings for high availability](./connection-strings/)
3. [Ensure that FAN is used](https://docs.oracle.com/en/database/oracle/oracle-database/19/haovw/configuring-level-1-basic-application-high-availability.html#GUID-2EFA9025-50E7-4E0F-8EDE-B815973005A2)
4. Ensure Application Implements Reconnection Logic.<br />
   Find the examples for each language in their respective folders in the repository root directory.

### Level 2: Prepare Applications for Planned Maintenance

Gracefully move the workload across instances without errors during planned maintenance:

| Option | Examples |
| ----- | ------ |
| Recommended: use an Oracle Connection Pool | JAVA (JDBC): [java_connection_pools.md](./java_connection_pools.md) <br />Other Languages (OCI): [oci_connection_pool.md](./oci_connection_pool.md) |
| Alternate: use connection tests | Find the examples for each language in their respective sub-folders |

### Level 3: Mask Unplanned and Planned Failovers from Applications

Mask unplanned and planned fail overs from applications. In-flight uncommitted transactions are replayed; committed transactions are acknowledged and not replayed:

| Scenario | Examples |
| ----- | ------ |
| Java with Universal Connection Pool | {link}|
| Java with non-Oracle Connection Pools | {link} |
| Python | {link} |
| C | {link} |
| Pro*C | {link} |
| JavaScript | {link} |
| Ruby | {link} |
| ODP.NET | {link} |

## Read more

* [High Availability Overview and Best Practices: Continuous Availability for Applications](https://docs.oracle.com/en/database/oracle/oracle-database/19/haovw/configuring-continuous-availability-applicationsconfiguring-continuous-availability-applicatio.html#GUID-5EBF37EA-48AB-4508-A14E-86A2583A24BF)

### Additional links:

* [High Availability Overview and Best Practices](https://docs.oracle.com/en/database/oracle/oracle-database/19/haovw/index.html)
* [Net Services Administration Guide](https://docs.oracle.com/en/database/oracle/oracle-database/19/netag/index.html)
* [High Availability Reference Architectures](https://docs.oracle.com/en/database/oracle/oracle-database/19/haiad/index.html)
