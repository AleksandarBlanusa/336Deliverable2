package cs336.pkg;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Reservation {
    private int reservationId;
    private int userID;
    private int flightId;
    private LocalDateTime bookingDate;
    private String seatNumber;
    private BigDecimal ticketPrice;
    private String status;
    private int createdBy;
    
    // References
    private User user;
    private Flight flight;
    private User createdByUser;
    
   
    // Constructors
    public Reservation() {}
    
    public Reservation(int reservationId, int userID, int flightId, LocalDateTime bookingDate, 
                     String seatNumber, BigDecimal ticketPrice, String status, int createdBy) {
        this.reservationId = reservationId;
        this.userID = userID;
        this.flightId = flightId;
        this.bookingDate = bookingDate;
        this.seatNumber = seatNumber;
        this.ticketPrice = ticketPrice;
        this.status = status;
        this.createdBy = createdBy;
    }
    
    // Getters and Setters
    public int getReservationId() { return reservationId; }
    public void setReservationId(int reservationId) { this.reservationId = reservationId; }
    
    public int getUserId() { return userID; }
    public void setUserId(int userID) { this.userID = userID; }
    
    public int getFlightId() { return flightId; }
    public void setFlightId(int flightId) { this.flightId = flightId; }
    
    public LocalDateTime getBookingDate() { return bookingDate; }
    public void setBookingDate(LocalDateTime bookingDate) { this.bookingDate = bookingDate; }
    
    public String getSeatNumber() { return seatNumber; }
    public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }
    
    public BigDecimal getTicketPrice() { return ticketPrice; }
    public void setTicketPrice(BigDecimal ticketPrice) { this.ticketPrice = ticketPrice; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    public Flight getFlight() { return flight; }
    public void setFlight(Flight flight) { this.flight = flight; }
    
    public User getCreatedByUser() { return createdByUser; }
    public void setCreatedByUser(User createdByUser) { this.createdByUser = createdByUser; }
    
    @Override
    public String toString() {
        return "Reservation{" +
                "reservationId=" + reservationId +
                ", user=" + (user != null ? user.getFullName() : "N/A") +
                ", flight=" + (flight != null ? flight.getFlightNumber() : "N/A") +
                ", bookingDate=" + bookingDate +
                ", seatNumber='" + seatNumber + '\'' +
                ", ticketPrice=" + ticketPrice +
                ", status='" + status + '\'' +
                '}';
    }
}
