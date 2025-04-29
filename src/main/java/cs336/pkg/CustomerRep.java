package cs336.pkg;

import cs336.pkg.Airport;
import cs336.pkg.User;
import cs336.pkg.Flight;

import java.util.ArrayList;
import java.util.List;

public class CustomerRep {

    private List<User> waitingList = new ArrayList<>();

    // Make flight reservation
    public boolean makeReservation(Flight flight, User user) {
        if (flight.addUser(user)) {
            System.out.println("Reservation made for " + user.getFirstName() + " on Flight ID: " + flight.getFlightId());
            return true;
        } else {
            System.out.println("Flight is fully booked. Adding to waiting list...");
            addToWaitingList(user);
            return false;
        }
    }

    // Add to waiting list if flight is fully booked
    public void addToWaitingList(User user) {
        waitingList.add(user);
    }

    // Edit reservation
    public void editReservation(Flight flight, User oldUser, User newUser) {
        List<User> users = flight.getUsers();
        
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUserId() == oldUser.getUserId()) {
                users.set(i, newUser);
                System.out.println("Reservation updated for User ID: " + oldUser.getUserId());
                return;
            }
        }
        System.out.println("User not found.");
    }

    // Cancel reservation
    public void cancelReservation(Flight flight, User user) {
        if (flight.getUsers().remove(user)) {
            System.out.println("Reservation cancelled for User ID: " + user.getUserId());
            // Check if any users are waiting and move one to the flight
            if (!waitingList.isEmpty()) {
                User nextUser = waitingList.remove(0); // Get the first user in the waiting list
                if (flight.addUser(nextUser)) {
                    System.out.println("User from waiting list added: " + nextUser.getFirstName());
                }
            }
        } else {
            System.out.println("User not found in flight.");
        }
    }

    // Reply to user questions
    public String replyToUser(String question) {
        if (question.equalsIgnoreCase("What are the available flights?")) {
            return "Please check the flight list.";
        } else if (question.equalsIgnoreCase("What is the status of my reservation?")) {
            return "Please provide your reservation details.";
        } else {
            return "Sorry, I don't have an answer for that question.";
        }
    }

    // Give list of flights for given airport
    public List<Flight> getFlightsByAirport(List<Flight> allFlights, String airportCode) {
        List<Flight> flightsForAirport = new ArrayList<>();

        for (Flight flight : allFlights) {
            if (flight.getDepartureAirport().getAirportCode().equalsIgnoreCase(airportCode) ||
                flight.getArrivalAirport().getAirportCode().equalsIgnoreCase(airportCode)) {
                flightsForAirport.add(flight);
            }
        }

        return flightsForAirport;
    }

    // Get waiting list for flights
    public List<User> getWaitingList() {
        return waitingList;
    }
}
