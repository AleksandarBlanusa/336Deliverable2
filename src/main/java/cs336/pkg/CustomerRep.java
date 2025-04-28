package cs336.pkg;

import cs336.pkg.Airport;
import cs336.pkg.Customer;
import cs336.pkg.Flight;

import java.util.ArrayList;
import java.util.List;

public class CustomerRep {

    // Waiting list initialized properly
    private List<Customer> waitingList = new ArrayList<>();

    // Method to make a flight reservation
    public boolean makeReservation(Flight flight, Customer customer) {
        if (flight.getCustomers().size() < flight.getAircraft().getCapacity()) {
            flight.getCustomers().add(customer);
            System.out.println("Reservation made for " + customer.getFirstName() + " on Flight ID: " + flight.getFlightId());
            return true;
        } else {
            System.out.println("Flight is fully booked. Adding to waiting list...");
            addToWaitingList(customer);
            return false;
        }
    }

    // Add to waiting list when flight is fully booked
    public void addToWaitingList(Customer customer) {
        waitingList.add(customer);
    }

    // Method to edit a reservation
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

    // Method to cancel a reservation
    public void cancelReservation(Flight flight, Customer customer) {
        if (flight.getCustomers().remove(customer)) {
            System.out.println("Reservation cancelled for Customer ID: " + customer.getCustomerId());
        } else {
            System.out.println("Customer not found in flight.");
        }
    }

    // Method to reply to user's questions
    public String replyToUser(String question) {
        if (question.equalsIgnoreCase("What are the available flights?")) {
            return "Please check the flight list.";
        } else if (question.equalsIgnoreCase("What is the status of my reservation?")) {
            return "Please provide your reservation details.";
        } else {
            return "Sorry, I don't have an answer for that question.";
        }
    }

    // Optional: Get the waiting list for a flight (you might want this for checklist item #4)
    public List<Customer> getWaitingList() {
        return waitingList;
    }
}
