/*
  This is an example of script to create a trigger that
  stops and starts the application services depending on
  the pluggable database role.
  The trigger must be run as a pluggable database administrator
  inside the PDB, and it assumes that the services have already
  been created by the script "no-clusterware-create-service.sql".
  It takes into account the services for the PRIMARY and
  PHYSICAL STANDBY roles.
  Adapt it accordingly to your needs. For example, you might
  include more services with different high availability
  properties (Transparent Application Continuity, Application
  Continuity, or non-highly available service), or services
  for the SNAPSHOT STANDBY role.

  Oracle recommends using Oracle Clusterware to manage services
  and send Fast Application Notification events via the
  Oracle Notification Service to improve the application response
  to planned and unplanned failover.

  If you have Oracle Clusterware, use the examples in the README.md
  to create, start, stop, and relocate services.

  For more information, read:
  https://docs.oracle.com/en/database/oracle/oracle-database/19/haovw/configuring-continuous-availability-applicationsconfiguring-continuous-availability-applicatio.html#GUID-5EBF37EA-48AB-4508-A14E-86A2583A24BF
*/
create or replace trigger service_trigger after startup on database declare
  v_service_ro    varchar2(64) := rtrim(sys_context('userenv', 'db_name') || '_ro.' || sys_context('userenv', 'db_domain'), '.');
  v_service_rw    varchar2(64) := rtrim(sys_context('userenv', 'db_name') || '_rw.' || sys_context('userenv', 'db_domain'), '.');
  v_ro_service_count   number;
begin
  -- Get if the read-only service for the PHYSICAL STANDBY role is active.
  select count(*) into v_ro_service_count from v$active_services where name = v_service_ro;

  if sys_context('userenv', 'database_role') = 'PRIMARY' then
    -- Start the RW service if the database is PRIMARY.
    dbms_service.start_service(v_service_rw);

    -- Stop the RO service if the database transitioned to the PRIMARY role.
    if v_ro_service_count = 1 then
      dbms_service.stop_service(v_service_ro);
      dbms_service.disconnect_session(v_service_ro, dbms_service.immediate);
    end if;

  elsif v_ro_service_count = 0 then
    -- Start the RO service is the database is not primary.
    dbms_service.start_service(v_service_ro);
  end if;
end;
/
