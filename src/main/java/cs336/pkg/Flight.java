package cs336.pkg;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Flight {
    private int flightId;
    private String flightNumber;
    private int airlineId;
    private int departureAirportId;
    private int arrivalAirportId;
    private int aircraftId;
    private LocalDateTime departureTime;
    private LocalDateTime arrivalTime;
    private BigDecimal basePrice;
    private int availableSeats;
    private String status;
    
    private Airline airline;
    private Airport departureAirport;
    private Airport arrivalAirport;
    private Aircraft aircraft;
    
    private List<Customer> customers;  // List to store customers (passengers) on the flight

    public Flight() {
        this.customers = new ArrayList<>();  // Initialize the customer list
    }

    public Flight(int flightId, String flightNumber, int airlineId, int departureAirportId, 
                 int arrivalAirportId, int aircraftId, LocalDateTime departureTime, LocalDateTime arrivalTime, 
                 BigDecimal basePrice, int availableSeats, String status) {
        this.flightId = flightId;
        this.flightNumber = flightNumber;
        this.airlineId = airlineId;
        this.departureAirportId = departureAirportId;
        this.arrivalAirportId = arrivalAirportId;
        this.aircraftId = aircraftId;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.basePrice = basePrice;
        this.availableSeats = availableSeats;
        this.status = status;
        this.customers = new ArrayList<>();  // Initialize the customer list
    }

    // Getter and Setter for customers
    public List<Customer> getCustomers() {
        return customers;
    }

    public void setCustomers(List<Customer> customers) {
        this.customers = customers;
    }

    // Getter and Setter methods for other fields
    public int getFlightId() { return flightId; }
    public void setFlightId(int flightId) { this.flightId = flightId; }
    
    public String getFlightNumber() { return flightNumber; }
    public void setFlightNumber(String flightNumber) { this.flightNumber = flightNumber; }
    
    public int getAirlineId() { return airlineId; }
    public void setAirlineId(int airlineId) { this.airlineId = airlineId; }
    
    public int getDepartureAirportId() { return departureAirportId; }
    public void setDepartureAirportId(int departureAirportId) { this.departureAirportId = departureAirportId; }
    
    public int getArrivalAirportId() { return arrivalAirportId; }
    public void setArrivalAirportId(int arrivalAirportId) { this.arrivalAirportId = arrivalAirportId; }
    
    public int getAircraftId() { return aircraftId; }
    public void setAircraftId(int aircraftId) { this.aircraftId = aircraftId; }
    
    public LocalDateTime getDepartureTime() { return departureTime; }
    public void setDepartureTime(LocalDateTime departureTime) { this.departureTime = departureTime; }
    
    public LocalDateTime getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(LocalDateTime arrivalTime) { this.arrivalTime = arrivalTime; }
    
    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }
    
    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }
    
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

    // Helper method to check if a customer can be added to the flight
    public boolean addCustomer(Customer customer) {
        if (customers.size() < availableSeats) {
            customers.add(customer);
            availableSeats--;  // Decrease the number of available seats
            return true;
        } else {
            return false;  // Flight is full
        }
    }

    @Override
    public String toString() {
        return "Flight{" +
                "flightId=" + flightId +
                ", flightNumber='" + flightNumber + '\'' +
                ", departureAirport=" + (departureAirport != null ? departureAirport.getAirportCode() : "N/A") +
                ", arrivalAirport=" + (arrivalAirport != null ? arrivalAirport.getAirportCode() : "N/A") +
                ", departureTime=" + departureTime +
                ", arrivalTime=" + arrivalTime +
                ", basePrice=" + basePrice +
                ", availableSeats=" + availableSeats +
                ", status='" + status + '\'' +
                '}';
    }
}
