package cs336.pkg;

import cs336.pkg.Airport;
import cs336.pkg.Customer;
import cs336.pkg.Flight;

import java.util.ArrayList;
import java.util.List;

public class CustomerRep {

    private List<Customer> waitingList = new ArrayList<>();

    // Make flight reservation
    public boolean makeReservation(Flight flight, Customer customer) {
        if (flight.addCustomer(customer)) {
            System.out.println("Reservation made for " + customer.getFirstName() + " on Flight ID: " + flight.getFlightId());
            return true;
        } else {
            System.out.println("Flight is fully booked. Adding to waiting list...");
            addToWaitingList(customer);
            return false;
        }
    }

    // Add to waiting list if flight is fully booked
    public void addToWaitingList(Customer customer) {
        waitingList.add(customer);
    }

    // Edit reservation
    public void editReservation(Flight flight, Customer oldCustomer, Customer newCustomer) {
        List<Customer> customers = flight.getCustomers();
        
        for (int i = 0; i < customers.size(); i++) {
            if (customers.get(i).getCustomerId() == oldCustomer.getCustomerId()) {
                customers.set(i, newCustomer);
                System.out.println("Reservation updated for Customer ID: " + oldCustomer.getCustomerId());
                return;
            }
        }
        System.out.println("Customer not found.");
    }

    // Cancel reservation
    public void cancelReservation(Flight flight, Customer customer) {
        if (flight.getCustomers().remove(customer)) {
            System.out.println("Reservation cancelled for Customer ID: " + customer.getCustomerId());
            // Check if any customers are waiting and move one to the flight
            if (!waitingList.isEmpty()) {
                Customer nextCustomer = waitingList.remove(0); // Get the first customer in the waiting list
                if (flight.addCustomer(nextCustomer)) {
                    System.out.println("Customer from waiting list added: " + nextCustomer.getFirstName());
                }
            }
        } else {
            System.out.println("Customer not found in flight.");
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
    public List<Customer> getWaitingList() {
        return waitingList;
    }
}
