package cs336.pkg;
import cs336.pkg.DatabaseUtil;
import cs336.pkg.Customer;
import cs336.pkg.Flight;
import cs336.pkg.WaitingList;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;

public class WaitingListDAO {
    
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final FlightDAO flightDAO = new FlightDAO();
    
    public List<WaitingList> getByFlightId(int flightId) throws SQLException {
        List<WaitingList> waitList = new ArrayList<>();
        String sql = "SELECT * FROM waiting_list WHERE flight_id = ? AND status = 'WAITING' ORDER BY request_date";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, flightId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    waitList.add(extractWaitingListFromResultSet(rs));
                }
            }
        }
        return waitList;
    }
    
    public List<WaitingList> getByCustomerId(int customerId) throws SQLException {
        List<WaitingList> waitList = new ArrayList<>();
        String sql = "SELECT * FROM waiting_list WHERE customer_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    waitList.add(extractWaitingListFromResultSet(rs));
                }
            }
        }
        return waitList;
    }
    
    public int addToWaitingList(WaitingList waitingList) throws SQLException {
        String sql = "INSERT INTO waiting_list (flight_id, customer_id, request_date, status) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, waitingList.getFlightId());
            stmt.setInt(2, waitingList.getCustomerId());
            stmt.setTimestamp(3, Timestamp.valueOf(waitingList.getRequestDate() != null ? 
                                                waitingList.getRequestDate() : LocalDateTime.now()));
            stmt.setString(4, waitingList.getStatus() != null ? waitingList.getStatus() : "WAITING");
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Adding to waiting list failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    waitingList.setWaitlistId(generatedKeys.getInt(1));
                    return waitingList.getWaitlistId();
                } else {
                    throw new SQLException("Adding to waiting list failed, no ID obtained.");
                }
            }
        }
    }
    
    public boolean updateStatus(int waitlistId, String status) throws SQLException {
        String sql = "UPDATE waiting_list SET status = ? WHERE waitlist_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, waitlistId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean removeFromWaitingList(int waitlistId) throws SQLException {
        String sql = "DELETE FROM waiting_list WHERE waitlist_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, waitlistId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    private WaitingList extractWaitingListFromResultSet(ResultSet rs) throws SQLException {
        WaitingList waitingList = new WaitingList();
        waitingList.setWaitlistId(rs.getInt("waitlist_id"));
        waitingList.setFlightId(rs.getInt("flight_id"));
        waitingList.setCustomerId(rs.getInt("customer_id"));
        waitingList.setRequestDate(rs.getTimestamp("request_date").toLocalDateTime());
        waitingList.setStatus(rs.getString("status"));
        
        // Load related objects
        try {
            waitingList.setFlight(flightDAO.getById(waitingList.getFlightId()));
            waitingList.setCustomer(customerDAO.getById(waitingList.getCustomerId()));
        } catch (SQLException e) {
            // Log the error but continue with partial data
            System.err.println("Error loading related objects for waiting list: " + e.getMessage());
        }
        
        return waitingList;
    }
}
