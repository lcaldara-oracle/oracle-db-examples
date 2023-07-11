/*
  This is an example of script to create an application service
  configured with Transparent Application Continuity.
  It must be executed as a pluggable database administrator,
  inside the pluggable database.

  Oracle recommends using Oracle Clusterware to manage services
  and send Fast Application Notification events via the
  Oracle Notification Service to improve the application response
  to planned and unplanned failover.

  If you have Oracle Clusterware, use the examples in the README.md
  to create, start, stop, and relocate services.

  For more information, read:
  https://docs.oracle.com/en/database/oracle/oracle-database/19/haovw/configuring-continuous-availability-applicationsconfiguring-continuous-availability-applicatio.html#GUID-5EBF37EA-48AB-4508-A14E-86A2583A24BF
*/


declare
  -- This exception is used in case the service already exists.
  e_service_error exception;
  pragma exception_init (e_service_error  , -44786);

  params dbms_service.svc_parameter_array;
  service_name v.name%type;
begin
  /*
     Parameters for Transparent Application Continuity:
     adjust delay, retries and timeouts according to your needs.
     For more information read:
     https://docs.oracle.com/en/database/oracle/oracle-database/19/arpls/DBMS_SERVICE.html#GUID-E790BE65-023F-4016-8A5F-DF43B324834C
  */
  params('failover_type')            :='AUTO';
  params('failover_restore')         :='AUTO';
  params('failover_delay')           :=2;
  params('failover_retries')         :=150;
  params('commit_outcome')           :='true';
  params('aq_ha_notifications')      :='true';
  params('replay_initiation_timeout'):=1800;
  params('retention_timeout')        :=86400;
  params('drain_timeout')            :=30;

  -- Create the service for the primary role (ending with _rw):
  service_name := rtrim(lower(sys_context('userenv', 'db_name'))||'_rw.'|| sys_context('userenv','db_domain'), '.');
  begin
    dbms_service.create_service ( service_name => service_name, network_name => service_name);
  exception
    when dbms_service.service_exists then  null;
  end;
  dbms_service.modify_service(service_name, params);

  -- Create the service for the primary role (ending with _ro):
  service_name := rtrim(lower(sys_context('userenv', 'db_name'))||'_ro.'|| sys_context('userenv','db_domain'), '.');
  begin
    dbms_service.create_service ( service_name => service_name, network_name => service_name);
  exception
    when dbms_service.service_exists then  null;
  end;
  dbms_service.modify_service(service_name, params);
end;
/
