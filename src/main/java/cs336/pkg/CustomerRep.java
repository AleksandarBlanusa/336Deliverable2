package cs336.pkg;
import cs336.pkg.Airport;
import cs336.pkg.Customer;
import cs336.pkg.Flight;

import java.util.List;

public class CustomerRep{

    // Method to make a flight reservation
    public boolean makeReservation(Flight flight, Customer customer) {
        // Check if the flight has capacity
        if (flight.getCustomers().size() < flight.getAircraft().getCapacity()) {
            flight.getCustomers().add(customer);
            System.out.println("Reservation made for " + customer.getFirstName() + " on Flight ID: " + flight.getFlightId());
            return true;
        } else {
            System.out.println("Flight is fully booked. Adding to waiting list...");
            // Add customer to the waiting list (not implemented here but could be a list of waiting customers)
            addToWaitingList(customer);
            return false;
        }
    }

    // Add to waiting list when flight is fully booked
    private List<Customer> waitingList;

    public void addToWaitingList(Customer customer) {
        waitingList.add(customer);
    }

    // Method to edit a reservation (e.g., changing the customer's details)
    public void editReservation(Flight flight, Customer oldCustomer, Customer newCustomer) {
        List<Customer> customers = flight.getCustomers();
        
        // Find and update the customer
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
        flight.getCustomers().remove(customer);
        System.out.println("Reservation cancelled for Customer ID: " + customer.getCustomerId());
    }

    // Method to reply to a user's question
    public String replyToUser(String question) {
        // Implement logic based on questions
        if (question.equalsIgnoreCase("What are the available flights?")) {
            return "Please check the flight list.";
        } else if (question.equalsIgnoreCase("What is the status of my reservation?")) {
            return "Please provide your reservation details.";
        } else {
            return "Sorry, I don't have an answer for that question.";
        }
    }
}
