package cs336.pkg;

public class Aircraft {
    private int aircraftId;
    private String aircraftType;
    private int capacity;
    private int airlineId;
    
    // Constructors
    public Aircraft() {}
    
    public Aircraft(int aircraftId, String aircraftType, int capacity, int airlineId) {
        this.aircraftId = aircraftId;
        this.aircraftType = aircraftType;
        this.capacity = capacity;
        this.airlineId = airlineId;
    }
    
    // Getters and Setters
    public int getAircraftId() { return aircraftId; }
    public void setAircraftId(int aircraftId) { this.aircraftId = aircraftId; }
    
    public String getAircraftType() { return aircraftType; }
    public void setAircraftType(String aircraftType) { this.aircraftType = aircraftType; }
    
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    
    public int getAirlineId() { return airlineId; }
    public void setAirlineId(int airlineId) { this.airlineId = airlineId; }
    
    @Override
    public String toString() {
        return "Aircraft{" +
                "aircraftId=" + aircraftId +
                ", aircraftType='" + aircraftType + '\'' +
                ", capacity=" + capacity +
                ", airlineId=" + airlineId +
                '}';
    }
}
