package cs336.pkg;
import cs336.pkg.Airport;
import cs336.pkg.Aircraft;
import cs336.pkg.Flight;

import java.util.List;

public class AircraftOps {

    // Add new aircraft
    public void addAircraft(List<Aircraft> aircraftList, Aircraft aircraft) {
        if (aircraft == null) {
            System.out.println("Cannot add null aircraft.");
            return;
        }
        aircraftList.add(aircraft);
        System.out.println("Aircraft added: " + aircraft);
    }

    // Edit existing aircraft
    public void editAircraft(List<Aircraft> aircraftList, Aircraft oldAircraft, Aircraft newAircraft) {
        if (oldAircraft == null || newAircraft == null) {
            System.out.println("Invalid aircraft provided.");
            return;
        }

        int index = aircraftList.indexOf(oldAircraft);
        if (index != -1) {
            aircraftList.set(index, newAircraft);
            System.out.println("Aircraft updated: " + newAircraft);
        } else {
            System.out.println("Aircraft not found.");
        }
    }

    // Delete aircraft
    public void deleteAircraft(List<Aircraft> aircraftList, Aircraft aircraft) {
        if (aircraft == null) {
            System.out.println("Cannot remove null aircraft.");
            return;
        }

        if (aircraftList.remove(aircraft)) {
            System.out.println("Aircraft removed: " + aircraft);
        } else {
            System.out.println("Aircraft not found.");
        }
    }

    // Add airport
    public void addAirport(List<Airport> airportList, Airport airport) {
        if (airport == null) {
            System.out.println("Cannot add null airport.");
            return;
        }
        airportList.add(airport);
        System.out.println("Airport added: " + airport);
    }

    // Edit airport
    public void editAirport(List<Airport> airportList, Airport oldAirport, Airport newAirport) {
        if (oldAirport == null || newAirport == null) {
            System.out.println("Invalid airport provided.");
            return;
        }

        int index = airportList.indexOf(oldAirport);
        if (index != -1) {
            airportList.set(index, newAirport);
            System.out.println("Airport updated: " + newAirport);
        } else {
            System.out.println("Airport not found.");
        }
    }

    // Delete airport
    public void deleteAirport(List<Airport> airportList, Airport airport) {
        if (airport == null) {
            System.out.println("Cannot remove null airport.");
            return;
        }

        if (airportList.remove(airport)) {
            System.out.println("Airport removed: " + airport);
        } else {
            System.out.println("Airport not found.");
        }
    }

    // Add flight
    public void addFlight(List<Flight> flightList, Flight flight) {
        if (flight == null) {
            System.out.println("Cannot add null flight.");
            return;
        }
        flightList.add(flight);
        System.out.println("Flight added: " + flight);
    }

    // Edit flight
    public void editFlight(List<Flight> flightList, Flight oldFlight, Flight newFlight) {
        if (oldFlight == null || newFlight == null) {
            System.out.println("Invalid flight provided.");
            return;
        }

        int index = flightList.indexOf(oldFlight);
        if (index != -1) {
            flightList.set(index, newFlight);
            System.out.println("Flight updated: " + newFlight);
        } else {
            System.out.println("Flight not found.");
        }
    }

    // Delete flight
    public void deleteFlight(List<Flight> flightList, Flight flight) {
        if (flight == null) {
            System.out.println("Cannot remove null flight.");
            return;
        }

        if (flightList.remove(flight)) {
            System.out.println("Flight removed: " + flight);
        } else {
            System.out.println("Flight not found.");
        }
    }
}
