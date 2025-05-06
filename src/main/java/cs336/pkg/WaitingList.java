package cs336.pkg;
import java.time.LocalDateTime;

public class WaitingList {
    private int waitlistId;
    private int flightId;
    private int userId;
    private LocalDateTime requestDate;
    private String status;
    
    // References
    private Flight flight;
    private User user;
    
    // Constructors
    public WaitingList() {}
    
    public WaitingList(int waitlistId, int flightId, int userId, LocalDateTime requestDate, String status) {
        this.waitlistId = waitlistId;
        this.flightId = flightId;
        this.userId = userId;
        this.requestDate = requestDate;
        this.status = status;
    }
    
    // Getters and Setters
    public int getWaitlistId() { return waitlistId; }
    public void setWaitlistId(int waitlistId) { this.waitlistId = waitlistId; }
    
    public int getFlightId() { return flightId; }
    public void setFlightId(int flightId) { this.flightId = flightId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public LocalDateTime getRequestDate() { return requestDate; }
    public void setRequestDate(LocalDateTime requestDate) { this.requestDate = requestDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Flight getFlight() { return flight; }
    public void setFlight(Flight flight) { this.flight = flight; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    @Override
    public String toString() {
        return "WaitingList{" +
                "waitlistId=" + waitlistId +
                ", flight=" + (flight != null ? flight.getFlightNumber() : "N/A") +
                ", user=" + (user != null ? user.getFullName() : "N/A") +
                ", requestDate=" + requestDate +
                ", status='" + status + '\'' +
                '}';
    }
}
