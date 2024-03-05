import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.Statement;
import java.util.Properties;
//OracleDataSource
import oracle.jdbc.OracleConnection;
import oracle.jdbc.replay.OracleDataSourceFactory;
import oracle.jdbc.replay.OracleDataSource;
public class TAC1 {
public static void main(String[] args) {
useOracleDataSource();
}
public static void useOracleDataSource() {
try {
OracleDataSource rds = OracleDataSourceFactory.getOracleDataSource();
//load properties
String PROP_FILE = "C:\\Users\\SPETRUS\\Documents\\spetrus\\development\\java\\ACproject\\src\\config.properties";
InputStream propInput = new FileInputStream(PROP_FILE);
Properties prop = new Properties();
prop.load(propInput);
//set properties 
System.setProperty("oracle.net.tns_admin", prop.getProperty("tns_admin"));
rds.setUser(prop.getProperty("db_user"));
rds.setPassword(prop.getProperty("db_password"));
rds.setURL("jdbc:oracle:thin:@"+prop.getProperty("tns_alias"));
//disable auto-commit
rds.setConnectionProperty(OracleConnection.CONNECTION_PROPERTY_AUTOCOMMIT, "false");
rds.setConnectionProperty(OracleConnection.CONNECTION_PROPERTY_IMPLICIT_STATEMENT_CACHE_SIZE, "100");
//get connection
Connection conn = rds.getConnection();
conn.beginRequest(); //Explicit request begin -- without this when using AC, as this does not use UCP (only replay JDBC driver): java.sql.SQLRecoverableException: No more data to read from socket
//do not use conn.beginRequest(); for testing with TAC, as TAC should discover the request boundaries automatically
conn.setAutoCommit(false);
//execute query
Statement stmt = conn.createStatement();
String insert = "insert into tacusr.tactab values ('Using Transparent Application Continuity - OracleDataSource')";
int result = stmt.executeUpdate(insert);
System.out.println("insert result is: " + result);
//stop here in bedug mode & (relocate | switchover | terminate the session)
conn.commit();
conn.endRequest(); //Explicit request end
conn.close();
conn=null;
}
catch (Exception e) {
e.printStackTrace();
}
}
}
