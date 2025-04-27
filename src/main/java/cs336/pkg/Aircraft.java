package cs336.pkg;

public class Aircraft {
    private int aircraftId;
    private String aircraftType;
    private int capacity;
    private Airline airline;  // Reference to the Airline object
    
    // Constructors
    public Aircraft() {}

    // Constructor with Airline object instead of airlineId
    public Aircraft(int aircraftId, String aircraftType, int capacity, Airline airline) {
        this.aircraftId = aircraftId;
        this.aircraftType = aircraftType;
        this.capacity = capacity;
        this.airline = airline;  // Direct reference to Airline object
    }
    
    // Getters and Setters
    public int getAircraftId() { return aircraftId; }
    public void setAircraftId(int aircraftId) { this.aircraftId = aircraftId; }
    
    public String getAircraftType() { return aircraftType; }
    public void setAircraftType(String aircraftType) { this.aircraftType = aircraftType; }
    
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    
    public Airline getAirline() { return airline; }
    public void setAirline(Airline airline) { this.airline = airline; }
    
    @Override
    public String toString() {
        return "Aircraft{" +
                "aircraftId=" + aircraftId +
                ", aircraftType='" + aircraftType + '\'' +
                ", capacity=" + capacity +
                ", airline=" + airline.getName() +
                '}';
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Aircraft aircraft = (Aircraft) obj;
        return aircraftId == aircraft.aircraftId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(aircraftId);
    }
}
