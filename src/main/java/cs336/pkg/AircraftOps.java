package cs336.pkg;
import cs336.pkg.Airport;
import cs336.pkg.Aircraft;
import cs336.pkg.Flight;

import java.util.List;

public class AircraftOps {

    // Add a new aircraft
    public void addAircraft(List<Aircraft> aircraftList, Aircraft aircraft) {
        aircraftList.add(aircraft);
        System.out.println("Aircraft added: " + aircraft);
    }

    // Edit an existing aircraft
    public void editAircraft(List<Aircraft> aircraftList, Aircraft oldAircraft, Aircraft newAircraft) {
        int index = aircraftList.indexOf(oldAircraft);
        if (index != -1) {
            aircraftList.set(index, newAircraft);
            System.out.println("Aircraft updated: " + newAircraft);
        } else {
            System.out.println("Aircraft not found.");
        }
    }

    // Delete an aircraft
    public void deleteAircraft(List<Aircraft> aircraftList, Aircraft aircraft) {
        if (aircraftList.remove(aircraft)) {
            System.out.println("Aircraft removed: " + aircraft);
        } else {
            System.out.println("Aircraft not found.");
        }
    }

    // Add an airport
    public void addAirport(List<Airport> airportList, Airport airport) {
        airportList.add(airport);
        System.out.println("Airport added: " + airport);
    }

    // Edit an airport
    public void editAirport(List<Airport> airportList, Airport oldAirport, Airport newAirport) {
        int index = airportList.indexOf(oldAirport);
        if (index != -1) {
            airportList.set(index, newAirport);
            System.out.println("Airport updated: " + newAirport);
        } else {
            System.out.println("Airport not found.");
        }
    }

    // Delete an airport
    public void deleteAirport(List<Airport> airportList, Airport airport) {
        if (airportList.remove(airport)) {
            System.out.println("Airport removed: " + airport);
        } else {
            System.out.println("Airport not found.");
        }
    }

    // Add a flight
    public void addFlight(List<Flight> flightList, Flight flight) {
        flightList.add(flight);
        System.out.println("Flight added: " + flight);
    }

    // Edit a flight
    public void editFlight(List<Flight> flightList, Flight oldFlight, Flight newFlight) {
        int index = flightList.indexOf(oldFlight);
        if (index != -1) {
            flightList.set(index, newFlight);
            System.out.println("Flight updated: " + newFlight);
        } else {
            System.out.println("Flight not found.");
        }
    }

    // Delete a flight
    public void deleteFlight(List<Flight> flightList, Flight flight) {
        if (flightList.remove(flight)) {
            System.out.println("Flight removed: " + flight);
        } else {
            System.out.println("Flight not found.");
        }
    }
}
