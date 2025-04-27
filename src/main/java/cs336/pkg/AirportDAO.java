import cs336.pkg.Airport;
import cs336.pkg.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AirportDAO {
    
    public Airport getById(int airportId) throws SQLException {
        String sql = "SELECT * FROM airports WHERE airport_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, airportId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Airport airport = new Airport();
                    airport.setAirportId(rs.getInt("airport_id"));
                    airport.setAirportCode(rs.getString("airport_code"));
                    airport.setAirportName(rs.getString("airport_name"));
                    airport.setCity(rs.getString("city"));
                    airport.setCountry(rs.getString("country"));
                    return airport;
                }
            }
        }
        return null;
    }
    
    public Airport getByCode(String airportCode) throws SQLException {
        String sql = "SELECT * FROM airports WHERE airport_code = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, airportCode);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Airport airport = new Airport();
                    airport.setAirportId(rs.getInt("airport_id"));
                    airport.setAirportCode(rs.getString("airport_code"));
                    airport.setAirportName(rs.getString("airport_name"));
                    airport.setCity(rs.getString("city"));
                    airport.setCountry(rs.getString("country"));
                    return airport;
                }
            }
        }
        return null;
    }
    
    public List<Airport> getAll() throws SQLException {
        List<Airport> airports = new ArrayList<>();
        String sql = "SELECT * FROM airports ORDER BY country, city";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Airport airport = new Airport();
                airport.setAirportId(rs.getInt("airport_id"));
                airport.setAirportCode(rs.getString("airport_code"));
                airport.setAirportName(rs.getString("airport_name"));
                airport.setCity(rs.getString("city"));
                airport.setCountry(rs.getString("country"));
                airports.add(airport);
            }
        }
        return airports;
    }
    
    public int save(Airport airport) throws SQLException {
        if (airport.getAirportId() > 0) {
            return update(airport);
        } else {
            return insert(airport);
        }
    }
    
    private int insert(Airport airport) throws SQLException {
        String sql = "INSERT INTO airports (airport_code, airport_name, city, country) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, airport.getAirportCode());
            stmt.setString(2, airport.getAirportName());
            stmt.setString(3, airport.getCity());
            stmt.setString(4, airport.getCountry());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating airport failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    airport.setAirportId(generatedKeys.getInt(1));
                    return airport.getAirportId();
                } else {
                    throw new SQLException("Creating airport failed, no ID obtained.");
                }
            }
        }
    }
    
    private int update(Airport airport) throws SQLException {
        String sql = "UPDATE airports SET airport_code = ?, airport_name = ?, city = ?, country = ? WHERE airport_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, airport.getAirportCode());
            stmt.setString(2, airport.getAirportName());
            stmt.setString(3, airport.getCity());
            stmt.setString(4, airport.getCountry());
            stmt.setInt(5, airport.getAirportId());
            
            return stmt.executeUpdate();
        }
    }
    
    public boolean delete(int airportId) throws SQLException {
        String sql = "DELETE FROM airports WHERE airport_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, airportId);
            
            return stmt.executeUpdate() > 0;
        }
    }
}
