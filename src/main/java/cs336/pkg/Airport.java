package cs336.pkg;

public class Airport {
    private int airportId;
    private String airportCode;
    private String city;
    private String state;

    public Airport() {}

    public Airport(int airportId, String airportCode, String city, String state) {
        this.airportId = airportId;
        this.airportCode = airportCode;
        this.city = city;
        this.state = state;
    }

    public int getAirportId() { return airportId; }
    public void setAirportId(int airportId) { this.airportId = airportId; }

    public String getAirportCode() { return airportCode; }
    public void setAirportCode(String airportCode) { this.airportCode = airportCode; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    @Override
    public String toString() {
        return "Airport{" +
                "airportId=" + airportId +
                ", airportCode='" + airportCode + '\'' +
                ", city='" + city + '\'' +
                ", state='" + state + '\'' +
                '}';
    }
}
