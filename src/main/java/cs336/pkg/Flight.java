// Updated Flight.java to embed full Airline object in addition to airlineCode
package cs336.pkg;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Flight {
    private int flightId;
    private String flightNumber;
    private String airlineCode;           // retained for direct use
    private String departureAirportCode;
    private String arrivalAirportCode;
    private LocalDateTime departureTime;
    private LocalDateTime arrivalTime;
    private BigDecimal basePrice;
    private int availableSeats;
    private int totalSeats;
    private int stops;
    private int duration;
    private String status;

    private Airline airline; // new embedded object
    private Airport departureAirport;
    private Airport arrivalAirport;
    private Aircraft aircraft;
    private List<User> users;

    public Flight() {
        this.users = new ArrayList<>();
    }

    // Getters and Setters
    public int getFlightId() { return flightId; }
    public void setFlightId(int flightId) { this.flightId = flightId; }

    public String getFlightNumber() { return flightNumber; }
    public void setFlightNumber(String flightNumber) { this.flightNumber = flightNumber; }

    public String getAirlineCode() { return airlineCode; }
    public void setAirlineCode(String airlineCode) { this.airlineCode = airlineCode; }

    public String getDepartureAirportCode() { return departureAirportCode; }
    public void setDepartureAirportCode(String departureAirportCode) { this.departureAirportCode = departureAirportCode; }

    public String getArrivalAirportCode() { return arrivalAirportCode; }
    public void setArrivalAirportCode(String arrivalAirportCode) { this.arrivalAirportCode = arrivalAirportCode; }

    public LocalDateTime getDepartureTime() { return departureTime; }
    public void setDepartureTime(LocalDateTime departureTime) { this.departureTime = departureTime; }

    public LocalDateTime getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(LocalDateTime arrivalTime) { this.arrivalTime = arrivalTime; }

    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }

    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }

    public int getTotalSeats() { return totalSeats; }
    public void setTotalSeats(int totalSeats) { this.totalSeats = totalSeats; }

    public int getStops() { return stops; }
    public void setStops(int stops) { this.stops = stops; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Airline getAirline() { return airline; }
    public void setAirline(Airline airline) { this.airline = airline; }

    public Airport getDepartureAirport() { return departureAirport; }
    public void setDepartureAirport(Airport departureAirport) { this.departureAirport = departureAirport; }

    public Airport getArrivalAirport() { return arrivalAirport; }
    public void setArrivalAirport(Airport arrivalAirport) { this.arrivalAirport = arrivalAirport; }

    public Aircraft getAircraft() { return aircraft; }
    public void setAircraft(Aircraft aircraft) { this.aircraft = aircraft; }

    public List<User> getUsers() { return users; }
    public void setUsers(List<User> users) { this.users = users; }

    public boolean addUser(User user) {
        if (users.size() < availableSeats) {
            users.add(user);
            availableSeats--;
            return true;
        } else {
            return false;
        }
    }

    @Override
    public String toString() {
        return "Flight{" +
                "flightId=" + flightId +
                ", airlineCode='" + airlineCode + '\'' +
                ", departureAirportCode='" + departureAirportCode + '\'' +
                ", arrivalAirportCode='" + arrivalAirportCode + '\'' +
                ", departureTime=" + departureTime +
                ", arrivalTime=" + arrivalTime +
                ", basePrice=" + basePrice +
                ", availableSeats=" + availableSeats +
                ", totalSeats=" + totalSeats +
                ", stops=" + stops +
                ", duration=" + duration +
                ", status='" + status + '\'' +
                '}';
    }
}
