import com.336Entities.Flight;
import com.flightreservation.model.Airline;
import com.flightreservation.model.Airport;
import com.flightreservation.model.Aircraft;
import com.flightreservation.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class FlightDAO {
    
    public Flight getById(int flightId) throws SQLException {
        String sql = "SELECT f.*, " +
                     "a1.airport_code as departure_code, a1.airport_name as departure_name, a1.city as departure_city, a1.country as departure_country, " +
                     "a2.airport_code as arrival_code, a2.airport_name as arrival_name, a2.city as arrival_city, a2.country as arrival_country, " +
                     "al.airline_name, al.airline_code, " +
                     "ac.aircraft_type, ac.capacity " +
                     "FROM flights f " +
                     "JOIN airports a1 ON f.departure_airport_id = a1.airport_id " +
                     "JOIN airports a2 ON f.arrival_airport_id = a2.airport_id " +
                     "JOIN airlines al ON f.airline_id = al.airline_id " +
                     "JOIN aircrafts ac ON f.aircraft_id = ac.aircraft_id " +
                     "WHERE f.flight_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, flightId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractFlightFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    public Flight getByFlightNumber(String flightNumber) throws SQLException {
        String sql = "SELECT f.*, " +
                     "a1.airport_code as departure_code, a1.airport_name as departure_name, a1.city as departure_city, a1.country as departure_country, " +
                     "a2.airport_code as arrival_code, a2.airport_name as arrival_name, a2.city as arrival_city, a2.country as arrival_country, " +
                     "al.airline_name, al.airline_code, " +
                     "ac.aircraft_type, ac.capacity " +
                     "FROM flights f " +
                     "JOIN airports a1 ON f.departure_airport_id = a1.airport_id " +
                     "JOIN airports a2 ON f.arrival_airport_id = a2.airport_id " +
                     "JOIN airlines al ON f.airline_id = al.airline_id " +
                     "JOIN aircrafts ac ON f.aircraft_id = ac.aircraft_id " +
                     "WHERE f.flight_number = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, flightNumber);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractFlightFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    public List<Flight> getAll() throws SQLException {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT f.*, " +
                     "a1.airport_code as departure_code, a1.airport_name as departure_name, a1.city as departure_city, a1.country as departure_country, " +
                     "a2.airport_code as arrival_code, a2.airport_name as arrival_name, a2.city as arrival_city, a2.country as arrival_country, " +
                     "al.airline_name, al.airline_code, " +
                     "ac.aircraft_type, ac.capacity " +
                     "FROM flights f " +
                     "JOIN airports a1 ON f.departure_airport_id = a1.airport_id " +
                     "JOIN airports a2 ON f.arrival_airport_id = a2.airport_id " +
                     "JOIN airlines al ON f.airline_id = al.airline_id " +
                     "JOIN aircrafts ac ON f.aircraft_id = ac.aircraft_id";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                flights.add(extractFlightFromResultSet(rs));
            }
        }
        return flights;
    }
    
    public List<Flight> getFlightsByAirport(int airportId, boolean isDeparture) throws SQLException {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT f.*, " +
                     "a1.airport_code as departure_code, a1.airport_name as departure_name, a1.city as departure_city, a1.country as departure_country, " +
                     "a2.airport_code as arrival_code, a2.airport_name as arrival_name, a2.city as arrival_city, a2.country as arrival_country, " +
                     "al.airline_name, al.airline_code, " +
                     "ac.aircraft_type, ac.capacity " +
                     "FROM flights f " +
                     "JOIN airports a1 ON f.departure_airport_id = a1.airport_id " +
                     "JOIN airports a2 ON f.arrival_airport_id = a2.airport_id " +
                     "JOIN airlines al ON f.airline_id = al.airline_id " +
                     "JOIN aircrafts ac ON f.aircraft_id = ac.aircraft_id " +
                     "WHERE " + (isDeparture ? "f.departure_airport_id" : "f.arrival_airport_id") + " = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, airportId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    flights.add(extractFlightFromResultSet(rs));
                }
            }
        }
        return flights;
    }
    
    public List<Flight> getMostActiveFlights(int limit) throws SQLException {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT f.*, " +
                     "a1.airport_code as departure_code, a1.airport_name as departure_name, a1.city as departure_city, a1.country as departure_country, " +
                     "a2.airport_code as arrival_code, a2.airport_name as arrival_name, a2.city as arrival_city, a2.country as arrival_country, " +
                     "al.airline_name, al.airline_code, " +
                     "ac.aircraft_type, ac.capacity, " +
                     "COUNT(r.reservation_id) as ticket_count " +
                     "FROM flights f " +
                     "JOIN airports a1 ON f.departure_airport_id = a1.airport_id " +
                     "JOIN airports a2 ON f.arrival_airport_id = a2.airport_id " +
                     "JOIN airlines al ON f.airline_id = al.airline_id " +
                     "JOIN aircrafts ac ON f.aircraft_id = ac.aircraft_id " +
                     "LEFT JOIN reservations r ON f.flight_id = r.flight_id " +
                     "GROUP BY f.flight_id " +
                     "ORDER BY ticket_count DESC " +
                     "LIMIT ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    flights.add(extractFlightFromResultSet(rs));
                }
            }
        }
        return flights;
    }
    
    public int save(Flight flight) throws SQLException {
        if (flight.getFlightId() > 0) {
            return update(flight);
        } else {
            return insert(flight);
        }
    }
    
    private int insert(Flight flight) throws SQLException {
        String sql = "INSERT INTO flights (flight_number, airline_id, departure_airport_id, arrival_airport_id, " +
                     "aircraft_id, departure_time, arrival_time, base_price, available_seats, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, flight.getFlightNumber());
            stmt.setInt(2, flight.getAirlineId());
            stmt.setInt(3, flight.getDepartureAirportId());
            stmt.setInt(4, flight.getArrivalAirportId());
            stmt.setInt(5, flight.getAircraftId());
            stmt.setTimestamp(6, Timestamp.valueOf(flight.getDepartureTime()));
            stmt.setTimestamp(7, Timestamp.valueOf(flight.getArrivalTime()));
            stmt.setBigDecimal(8, flight.getBasePrice());
            stmt.setInt(9, flight.getAvailableSeats());
            stmt.setString(10, flight.getStatus());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating flight failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    flight.setFlightId(generatedKeys.getInt(1));
                    return flight.getFlightId();
                } else {
                    throw new SQLException("Creating flight failed, no ID obtained.");
                }
            }
        }
    }
    
    private int update(Flight flight) throws SQLException {
        String sql = "UPDATE flights SET flight_number = ?, airline_id = ?, departure_airport_id = ?, " +
                     "arrival_airport_id = ?, aircraft_id = ?, departure_time = ?, arrival_time = ?, " +
                     "base_price = ?, available_seats = ?, status = ? WHERE flight_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, flight.getFlightNumber());
            stmt.setInt(2, flight.getAirlineId());
            stmt.setInt(3, flight.getDepartureAirportId());
            stmt.setInt(4, flight.getArrivalAirportId());
            stmt.setInt(5, flight.getAircraftId());
            stmt.setTimestamp(6, Timestamp.valueOf(flight.getDepartureTime()));
            stmt.setTimestamp(7, Timestamp.valueOf(flight.getArrivalTime()));
            stmt.setBigDecimal(8, flight.getBasePrice());
            stmt.setInt(9, flight.getAvailableSeats());
            stmt.setString(10, flight.getStatus());
            stmt.setInt(11, flight.getFlightId());
            
            return stmt.executeUpdate();
        }
    }
    
    public boolean updateAvailableSeats(int flightId, int availableSeats) throws SQLException {
        String sql = "UPDATE flights SET available_seats = ? WHERE flight_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, availableSeats);
            stmt.setInt(2, flightId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean delete(int flightId) throws SQLException {
        String sql = "DELETE FROM flights WHERE flight_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, flightId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    private Flight extractFlightFromResultSet(ResultSet rs) throws SQLException {
        Flight flight = new Flight();
        flight.setFlightId(rs.getInt("flight_id"));
        flight.setFlightNumber(rs.getString("flight_number"));
        flight.setAirlineId(rs.getInt("airline_id"));
        flight.setDepartureAirportId(rs.getInt("departure_airport_id"));
        flight.setArrivalAirportId(rs.getInt("arrival_airport_id"));
        flight.setAircraftId(rs.getInt("aircraft_id"));
        flight.setDepartureTime(rs.getTimestamp("departure_time").toLocalDateTime());
        flight.setArrivalTime(rs.getTimestamp("arrival_time").toLocalDateTime());
        flight.setBasePrice(rs.getBigDecimal("base_price"));
        flight.setAvailableSeats(rs.getInt("available_seats"));
        flight.setStatus(rs.getString("status"));
        
        // Set referenced objects
        Airline airline = new Airline();
        airline.setAirlineId(rs.getInt("airline_id"));
        airline.setAirlineName(rs.getString("airline_name"));
        airline.setAirlineCode(rs.getString("airline_code"));
        flight.setAirline(airline);
        
        Airport departureAirport = new Airport();
        departureAirport.setAirportId(rs.getInt("departure_airport_id"));
        departureAirport.setAirportCode(rs.getString("departure_code"));
        departureAirport.setAirportName(rs.getString("departure_name"));
        departureAirport.setCity(rs.getString("departure_city"));
        departureAirport.setCountry(rs.getString("departure_country"));
        flight.setDepartureAirport(departureAirport);
        
        Airport arrivalAirport = new Airport();
        arrivalAirport.setAirportId(rs.getInt("arrival_airport_id"));
        arrivalAirport.setAirportCode(rs.getString("arrival_code"));
        arrivalAirport.setAirportName(rs.getString("arrival_name"));
        arrivalAirport.setCity(rs.getString("arrival_city"));
        arrivalAirport.setCountry(rs.getString("arrival_country"));
        flight.setArrivalAirport(arrivalAirport);
        
        Aircraft aircraft = new Aircraft();
        aircraft.setAircraftId(rs.getInt("aircraft_id"));
        aircraft.setAircraftType(rs.getString("aircraft_type"));
        aircraft.setCapacity(rs.getInt("capacity"));
        aircraft.setAirlineId(rs.getInt("airline_id"));
        flight.setAircraft(aircraft);
        
        return flight;
    }
}
