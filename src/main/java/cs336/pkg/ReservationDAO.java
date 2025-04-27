import com.flightreservation.model.Reservation;
import com.flightreservation.model.Customer;
import com.flightreservation.model.Flight;
import com.flightreservation.model.User;
import com.flightreservation.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.YearMonth;

public class ReservationDAO {
    
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final FlightDAO flightDAO = new FlightDAO();
    private final UserDAO userDAO = new UserDAO();
    
    public Reservation getById(int reservationId) throws SQLException {
        String sql = "SELECT * FROM reservations WHERE reservation_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reservationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractReservationFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    public List<Reservation> getByCustomerId(int customerId) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE customer_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(extractReservationFromResultSet(rs));
                }
            }
        }
        return reservations;
    }
    
    public List<Reservation> getByFlightId(int flightId) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE flight_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, flightId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(extractReservationFromResultSet(rs));
                }
            }
        }
        return reservations;
    }
    
    public List<Reservation> getByFlightNumber(String flightNumber) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.* FROM reservations r " +
                     "JOIN flights f ON r.flight_id = f.flight_id " +
                     "WHERE f.flight_number = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, flightNumber);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(extractReservationFromResultSet(rs));
                }
            }
        }
        return reservations;
    }
    
    public List<Reservation> getByCustomerName(String customerName) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.* FROM reservations r " +
                     "JOIN customers c ON r.customer_id = c.customer_id " +
                     "WHERE CONCAT(c.first_name, ' ', c.last_name) LIKE ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + customerName + "%");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(extractReservationFromResultSet(rs));
                }
            }
        }
        return reservations;
    }
    
    public BigDecimal getRevenueByFlight(int flightId) throws SQLException {
        String sql = "SELECT SUM(ticket_price) as total_revenue FROM reservations WHERE flight_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, flightId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("total_revenue");
                }
            }
        }
        return BigDecimal.ZERO;
    }
    
    public BigDecimal getRevenueByAirline(int airlineId) throws SQLException {
        String sql = "SELECT SUM(r.ticket_price) as total_revenue FROM reservations r " +
                     "JOIN flights f ON r.flight_id = f.flight_id " +
                     "WHERE f.airline_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, airlineId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("total_revenue");
                }
            }
        }
        return BigDecimal.ZERO;
    }
    
    public BigDecimal getRevenueByCustomer(int customerId) throws SQLException {
        String sql = "SELECT SUM(ticket_price) as total_revenue FROM reservations WHERE customer_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("total_revenue");
                }
            }
        }
        return BigDecimal.ZERO;
    }
    
    public List<Object[]> getMonthlySalesReport(int year, int month) throws SQLException {
        List<Object[]> salesReport = new ArrayList<>();
        String sql = "SELECT f.flight_number, al.airline_name, COUNT(r.reservation_id) as ticket_count, " +
                     "SUM(r.ticket_price) as total_revenue " +
                     "FROM reservations r " +
                     "JOIN flights f ON r.flight_id = f.flight_id " +
                     "JOIN airlines al ON f.airline_id = al.airline_id " +
                     "WHERE YEAR(r.booking_date) = ? AND MONTH(r.booking_date) = ? " +
                     "GROUP BY f.flight_id " +
                     "ORDER BY total_revenue DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, year);
            stmt.setInt(2, month);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Object[] reportRow = new Object[4];
                    reportRow[0] = rs.getString("flight_number");
                    reportRow[1] = rs.getString("airline_name");
                    reportRow[2] = rs.getInt("ticket_count");
                    reportRow[3] = rs.getBigDecimal("total_revenue");
                    salesReport.add(reportRow);
                }
            }
        }
        return salesReport;
    }
    
    public int save(Reservation reservation) throws SQLException {
        if (reservation.getReservationId() > 0) {
            return update(reservation);
        } else {
            return insert(reservation);
        }
    }
    
    private int insert(Reservation reservation) throws SQLException {
        String sql = "INSERT INTO reservations (customer_id, flight_id, booking_date, seat_number, ticket_price, status, created_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet generatedKeys = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Update available seats in flight
            Flight flight = flightDAO.getById(reservation.getFlightId());
            if (flight != null && flight.getAvailableSeats() > 0) {
                flightDAO.updateAvailableSeats(flight.getFlightId(), flight.getAvailableSeats() - 1);
            } else {
                throw new SQLException("No available seats for this flight.");
            }
            
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, reservation.getCustomerId());
            stmt.setInt(2, reservation.getFlightId());
            stmt.setTimestamp(3, Timestamp.valueOf(reservation.getBookingDate() != null ? 
                                                   reservation.
                                                   stmt.setTimestamp(3, Timestamp.valueOf(reservation.getBookingDate() != null ? 
                                                   reservation.getBookingDate() : LocalDateTime.now()));
            stmt.setString(4, reservation.getSeatNumber());
            stmt.setBigDecimal(5, reservation.getTicketPrice());
            stmt.setString(6, reservation.getStatus() != null ? reservation.getStatus() : "CONFIRMED");
            stmt.setInt(7, reservation.getCreatedBy());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                conn.rollback();
                throw new SQLException("Creating reservation failed, no rows affected.");
            }
            
            generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                reservation.setReservationId(generatedKeys.getInt(1));
                conn.commit();
                return reservation.getReservationId();
            } else {
                conn.rollback();
                throw new SQLException("Creating reservation failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e) {
                    throw new SQLException("Transaction rollback failed: " + e.getMessage());
                }
            }
            throw ex;
        } finally {
            if (generatedKeys != null) try { generatedKeys.close(); } catch (SQLException e) { /* ignore */ }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { /* ignore */ }
            if (conn != null) {
                try { 
                    conn.setAutoCommit(true);
                    conn.close(); 
                } catch (SQLException e) { /* ignore */ }
            }
        }
    }
    
    private int update(Reservation reservation) throws SQLException {
        String sql = "UPDATE reservations SET customer_id = ?, flight_id = ?, seat_number = ?, " +
                     "ticket_price = ?, status = ? WHERE reservation_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reservation.getCustomerId());
            stmt.setInt(2, reservation.getFlightId());
            stmt.setString(3, reservation.getSeatNumber());
            stmt.setBigDecimal(4, reservation.getTicketPrice());
            stmt.setString(5, reservation.getStatus());
            stmt.setInt(6, reservation.getReservationId());
            
            return stmt.executeUpdate();
        }
    }
    
    public boolean delete(int reservationId) throws SQLException {
        Reservation reservation = getById(reservationId);
        if (reservation == null) {
            return false;
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Update available seats in flight
            Flight flight = flightDAO.getById(reservation.getFlightId());
            if (flight != null) {
                flightDAO.updateAvailableSeats(flight.getFlightId(), flight.getAvailableSeats() + 1);
            }
            
            String sql = "DELETE FROM reservations WHERE reservation_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, reservationId);
            
            boolean result = stmt.executeUpdate() > 0;
            conn.commit();
            return result;
        } catch (SQLException ex) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e) {
                    throw new SQLException("Transaction rollback failed: " + e.getMessage());
                }
            }
            throw ex;
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { /* ignore */ }
            if (conn != null) {
                try { 
                    conn.setAutoCommit(true);
                    conn.close(); 
                } catch (SQLException e) { /* ignore */ }
            }
        }
    }
    
    private Reservation extractReservationFromResultSet(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        reservation.setReservationId(rs.getInt("reservation_id"));
        reservation.setCustomerId(rs.getInt("customer_id"));
        reservation.setFlightId(rs.getInt("flight_id"));
        reservation.setBookingDate(rs.getTimestamp("booking_date").toLocalDateTime());
        reservation.setSeatNumber(rs.getString("seat_number"));
        reservation.setTicketPrice(rs.getBigDecimal("ticket_price"));
        reservation.setStatus(rs.getString("status"));
        reservation.setCreatedBy(rs.getInt("created_by"));
        
        // Load related objects
        try {
            reservation.setCustomer(customerDAO.getById(reservation.getCustomerId()));
            reservation.setFlight(flightDAO.getById(reservation.getFlightId()));
            reservation.setCreatedByUser(userDAO.getById(reservation.getCreatedBy()));
        } catch (SQLException e) {
            // Log the error but continue with partial data
            System.err.println("Error loading related objects for reservation: " + e.getMessage());
        }
        
        return reservation;
    }
}
