package cs336.pkg;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AircraftOps {

    // Add new aircraft
    public void addAircraft(Connection conn, Aircraft aircraft) throws SQLException {
        if (aircraft == null) {
            System.out.println("Cannot add null aircraft.");
            return;
        }

        String query = "INSERT INTO aircrafts (model, capacity) VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, aircraft.getAircraftType());
            stmt.setInt(2, aircraft.getCapacity());
            stmt.executeUpdate();
            System.out.println("Aircraft added: " + aircraft);
        }
    }

    // Edit existing aircraft
    public void editAircraft(Connection conn, int aircraftId, Aircraft newAircraft) throws SQLException {
        if (newAircraft == null) {
            System.out.println("Invalid aircraft provided.");
            return;
        }

        String query = "UPDATE aircrafts SET model = ?, capacity = ? WHERE aircraft_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, newAircraft.getAircraftType());
            stmt.setInt(2, newAircraft.getCapacity());
            stmt.setInt(3, aircraftId);
            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Aircraft updated: " + newAircraft);
            } else {
                System.out.println("Aircraft not found with ID: " + aircraftId);
            }
        }
    }

    // Delete aircraft
    public void deleteAircraft(Connection conn, int aircraftId) throws SQLException {
        String query = "DELETE FROM aircrafts WHERE aircraft_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, aircraftId);
            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted > 0) {
                System.out.println("Aircraft deleted with ID: " + aircraftId);
            } else {
                System.out.println("Aircraft not found with ID: " + aircraftId);
            }
        }
    }

    // Get all aircrafts
    public List<Aircraft> getAllAircrafts(Connection conn) throws SQLException {
        List<Aircraft> aircraftList = new ArrayList<>();
        String query = "SELECT aircraft_id, model, capacity FROM aircrafts";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("aircraft_id");
                String model = rs.getString("model");
                int capacity = rs.getInt("capacity");
                Aircraft aircraft = new Aircraft(id, model, capacity);
                aircraftList.add(aircraft);
            }
        }

        return aircraftList;
    }

    // Add new airport
    public void addAirport(Connection conn, Airport airport) throws SQLException {
        if (airport == null) {
            System.out.println("Cannot add null airport.");
            return;
        }

        String query = "INSERT INTO airports (airport_code, city, state) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, airport.getAirportCode());
            stmt.setString(2, airport.getCity());
            stmt.setString(3, airport.getState());
            stmt.executeUpdate();
            System.out.println("Airport added: " + airport);
        }
    }

    // Edit existing airport
    public void editAirport(Connection conn, String oldAirportCode, Airport newAirport) throws SQLException {
        if (newAirport == null) {
            System.out.println("Invalid airport provided.");
            return;
        }

        String query = "UPDATE airports SET city = ?, state = ? WHERE airport_code = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, newAirport.getCity());
            stmt.setString(2, newAirport.getState());
            stmt.setString(3, oldAirportCode);
            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Airport updated: " + newAirport);
            } else {
                System.out.println("Airport not found with code: " + oldAirportCode);
            }
        }
    }

    // Delete airport
    public void deleteAirport(Connection conn, String airportCode) throws SQLException {
        String query = "DELETE FROM airports WHERE airport_code = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, airportCode);
            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted > 0) {
                System.out.println("Airport deleted with code: " + airportCode);
            } else {
                System.out.println("Airport not found with code: " + airportCode);
            }
        }
    }
    
    public List<Airport> getAllAirports(Connection conn) throws SQLException {
        List<Airport> airportList = new ArrayList<>();
        String query = "SELECT airport_code, city, state FROM airports";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String code = rs.getString("airport_code");
                String city = rs.getString("city");
                String state = rs.getString("state");
                Airport airport = new Airport(0, code, city, state);
                airportList.add(airport);
            }
        }

        return airportList;
    }


    // Add new flight
    public void addFlight(Connection conn, Flight flight) throws SQLException {
        if (flight == null) {
            System.out.println("Cannot add null flight.");
            return;
        }

        String query = "INSERT INTO flights (airline_id, stops, takeoff_time, landing_time, duration, origin_airport_code, destination_airport_code, available_seats, total_seats, price) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, flight.getAirlineCode());
            stmt.setInt(2, flight.getStops());
            stmt.setTimestamp(3, Timestamp.valueOf(flight.getDepartureTime()));
            stmt.setTimestamp(4, Timestamp.valueOf(flight.getArrivalTime()));
            stmt.setInt(5, flight.getDuration());
            stmt.setString(6, flight.getDepartureAirportCode());
            stmt.setString(7, flight.getArrivalAirportCode());
            stmt.setInt(8, flight.getAvailableSeats());
            stmt.setInt(9, flight.getTotalSeats());
            stmt.setBigDecimal(10, flight.getBasePrice());
            stmt.executeUpdate();
            System.out.println("Flight added: " + flight);
        }
    }

    // Edit existing flight
    public void editFlight(Connection conn, int flightId, Flight newFlight, Aircraft newAircraft) throws SQLException {
        if (newFlight == null || newAircraft == null) {
            System.out.println("Invalid flight or aircraft provided.");
            return;
        }

        String query = "UPDATE flights SET airline_id = ?, stops = ?, takeoff_time = ?, landing_time = ?, duration = ?, origin_airport_code = ?, destination_airport_code = ?, available_seats = ?, total_seats = ?, price = ? WHERE flight_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, newFlight.getAirlineCode());
            stmt.setInt(2, newFlight.getStops());
            stmt.setTimestamp(3, Timestamp.valueOf(newFlight.getDepartureTime()));
            stmt.setTimestamp(4, Timestamp.valueOf(newFlight.getArrivalTime()));
            stmt.setInt(5, newFlight.getDuration());
            stmt.setString(6, newFlight.getDepartureAirportCode());
            stmt.setString(7, newFlight.getArrivalAirportCode());
            stmt.setInt(8, newFlight.getAvailableSeats());
            stmt.setInt(9, newAircraft.getCapacity());
            stmt.setBigDecimal(10, newFlight.getBasePrice());
            stmt.setInt(11, flightId);
            
            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Flight updated successfully: " + newFlight);
            } else {
                System.out.println("Flight not found with ID: " + flightId);
            }
        }
    }

    // Delete flight
    public void deleteFlight(Connection conn, int flightId) throws SQLException {
        String query = "DELETE FROM flights WHERE flight_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, flightId);
            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted > 0) {
                System.out.println("Flight deleted with ID: " + flightId);
            } else {
                System.out.println("Flight not found with ID: " + flightId);
            }
        }
    }
    
    public List<Flight> getAllFlights(Connection conn) throws SQLException {
        List<Flight> flightList = new ArrayList<>();
        String query = "SELECT * FROM flights";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Flight f = new Flight();
                f.setFlightId(rs.getInt("flight_id"));
                f.setAirlineCode(rs.getString("airline_id"));
                f.setStops(rs.getInt("stops"));
                f.setDepartureTime(rs.getTimestamp("takeoff_time").toLocalDateTime());
                f.setArrivalTime(rs.getTimestamp("landing_time").toLocalDateTime());
                f.setDuration(rs.getInt("duration"));
                f.setDepartureAirportCode(rs.getString("origin_airport_code"));
                f.setArrivalAirportCode(rs.getString("destination_airport_code"));
                f.setAvailableSeats(rs.getInt("available_seats"));
                f.setTotalSeats(rs.getInt("total_seats"));
                f.setBasePrice(rs.getBigDecimal("price"));
                flightList.add(f);
            }
        }

        return flightList;
    }
    
    public List<Flight> getDepartingFlights(Connection conn, String airportCode) throws SQLException {
        List<Flight> flights = new ArrayList<>();
        String query = "SELECT * FROM flights WHERE origin_airport_code = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, airportCode);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Flight f = new Flight();
                    f.setFlightId(rs.getInt("flight_id"));
                    f.setAirlineCode(rs.getString("airline_id"));
                    f.setDepartureAirportCode(rs.getString("origin_airport_code"));
                    f.setArrivalAirportCode(rs.getString("destination_airport_code"));
                    f.setDepartureTime(rs.getTimestamp("takeoff_time").toLocalDateTime());
                    f.setArrivalTime(rs.getTimestamp("landing_time").toLocalDateTime());
                    f.setDuration(rs.getInt("duration"));
                    f.setStops(rs.getInt("stops"));
                    flights.add(f);
                }
            }
        }

        return flights;
    }

    public List<Flight> getArrivingFlights(Connection conn, String airportCode) throws SQLException {
        List<Flight> flights = new ArrayList<>();
        String query = "SELECT * FROM flights WHERE destination_airport_code = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, airportCode);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Flight f = new Flight();
                    f.setFlightId(rs.getInt("flight_id"));
                    f.setAirlineCode(rs.getString("airline_id"));
                    f.setDepartureAirportCode(rs.getString("origin_airport_code"));
                    f.setArrivalAirportCode(rs.getString("destination_airport_code"));
                    f.setDepartureTime(rs.getTimestamp("takeoff_time").toLocalDateTime());
                    f.setArrivalTime(rs.getTimestamp("landing_time").toLocalDateTime());
                    f.setDuration(rs.getInt("duration"));
                    f.setStops(rs.getInt("stops"));
                    flights.add(f);
                }
            }
        }

        return flights;
    }


}
