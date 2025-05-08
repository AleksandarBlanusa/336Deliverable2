package cs336.pkg;

public class Aircraft {
    private int aircraftId;
    private String model;
    private int capacity;

	public Aircraft(int aircraftId, String model, int capacity) {
		this.aircraftId = aircraftId;
        this.model = model;
        this.capacity = capacity;
	}


	public int getAircraftId() {
        return aircraftId;
    }

    public String getModel() {
        return model;
    }

    public int getCapacity() {
        return capacity;
    }

    // Optional alias used in add/edit
    public String getAircraftType() {
        return model;
    }

    @Override
    public String toString() {
        return "Aircraft{id=" + aircraftId + ", model=" + model + ", capacity=" + capacity + "}";
    }
}
