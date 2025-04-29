package cs336.pkg;
import java.time.LocalDateTime;

public class WaitingList {
    private int waitlistId;
    private int flightId;
    private int customerId;
    private LocalDateTime requestDate;
    private String status;
    
    // References
    private Flight flight;
    private Customer customer;
    
    // Constructors
    public WaitingList() {}
    
    public WaitingList(int waitlistId, int flightId, int customerId, LocalDateTime requestDate, String status) {
        this.waitlistId = waitlistId;
        this.flightId = flightId;
        this.customerId = customerId;
        this.requestDate = requestDate;
        this.status = status;
    }
    
    // Getters and Setters
    public int getWaitlistId() { return waitlistId; }
    public void setWaitlistId(int waitlistId) { this.waitlistId = waitlistId; }
    
    public int getFlightId() { return flightId; }
    public void setFlightId(int flightId) { this.flightId = flightId; }
    
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    
    public LocalDateTime getRequestDate() { return requestDate; }
    public void setRequestDate(LocalDateTime requestDate) { this.requestDate = requestDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Flight getFlight() { return flight; }
    public void setFlight(Flight flight) { this.flight = flight; }
    
    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }
    
    @Override
    public String toString() {
        return "WaitingList{" +
                "waitlistId=" + waitlistId +
                ", flight=" + (flight != null ? flight.getFlightNumber() : "N/A") +
                ", customer=" + (customer != null ? customer.getFullName() : "N/A") +
                ", requestDate=" + requestDate +
                ", status='" + status + '\'' +
                '}';
    }
}
