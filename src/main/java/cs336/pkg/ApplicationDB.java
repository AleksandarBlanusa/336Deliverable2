package cs336.pkg;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ApplicationDB {
	
	public ApplicationDB(){
		
	}

	public Connection getConnection() {

	    String connectionUrl = "jdbc:mysql://localhost:3306/336project"; // change the "336project" in the url to the name of your database
	    Connection connection = null;

	    try {
	        // Updated driver class name for MySQL 8.x
	        Class.forName("com.mysql.cj.jdbc.Driver");

	        // Connect to DB
	        connection = DriverManager.getConnection(connectionUrl, "root", "cs336project"); //change root and cs336project to your username and password

	    } catch (ClassNotFoundException e) {
	        e.printStackTrace();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return connection;
	}

	
	public void closeConnection(Connection connection){
		try {
			connection.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	
	
	
	public static void main(String[] args) {
		ApplicationDB dao = new ApplicationDB();
		Connection connection = dao.getConnection();
		
		System.out.println(connection);		
		dao.closeConnection(connection);
	}
	
	

}