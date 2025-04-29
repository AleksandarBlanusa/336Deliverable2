package cs336.pkg;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerRep {

    // Make a flight reservation
    public boolean makeReservation(Connection conn, int flightId, int userId, String seatClass) throws SQLException {
        // Check confirmed reservations count
        String countQuery = "SELECT COUNT(*) FROM reservations WHERE flight_id = ? AND status = 'reserved'";
        try (PreparedStatement countStmt = conn.prepareStatement(countQuery)) {
            countStmt.setInt(1, flightId);
            ResultSet rs = countStmt.executeQuery();
            rs.next();
            int reservedCount = rs.getInt(1);

            // Get total seats
            String seatQuery = "SELECT total_seats FROM flights WHERE flight_id = ?";
            try (PreparedStatement seatStmt = conn.prepareStatement(seatQuery)) {
                seatStmt.setInt(1, flightId);
                ResultSet seatRs = seatStmt.executeQuery();
                seatRs.next();
                int totalSeats = seatRs.getInt(1);

                if (reservedCount < totalSeats) {
                    // Reserve seat
                    String reserveQuery = "INSERT INTO reservations (user_id, flight_id, seat_class, status) VALUES (?, ?, ?, 'reserved')";
                    try (PreparedStatement reserveStmt = conn.prepareStatement(reserveQuery)) {
                        reserveStmt.setInt(1, userId);
                        reserveStmt.setInt(2, flightId);
                        reserveStmt.setString(3, seatClass);
                        reserveStmt.executeUpdate();
                        System.out.println("Reservation made for user_id=" + userId);
                        return true;
                    }
                } else {
                    // Add to waiting list
                    String waitQuery = "INSERT INTO waiting_list (user_id, flight_id) VALUES (?, ?)";
                    try (PreparedStatement waitStmt = conn.prepareStatement(waitQuery)) {
                        waitStmt.setInt(1, userId);
                        waitStmt.setInt(2, flightId);
                        waitStmt.executeUpdate();
                        System.out.println("Flight full. User added to waiting list: user_id=" + userId);
                        return false;
                    }
                }
            }
        }
    }

    // Cancel a reservation
    public void cancelReservation(Connection conn, int flightId, int userId) throws SQLException {
        String cancelQuery = "UPDATE reservations SET status = 'cancelled' WHERE flight_id = ? AND user_id = ?";
        try (PreparedStatement cancelStmt = conn.prepareStatement(cancelQuery)) {
            cancelStmt.setInt(1, flightId);
            cancelStmt.setInt(2, userId);
            int rowsUpdated = cancelStmt.executeUpdate();

            if (rowsUpdated > 0) {
                System.out.println("Reservation cancelled for user_id=" + userId);

                // Promote next waiting list user
                promoteFromWaitingList(conn, flightId);
            } else {
                System.out.println("No reservation found for cancellation.");
            }
        }
    }

    // Promote first user from waiting list to reservation
    private void promoteFromWaitingList(Connection conn, int flightId) throws SQLException {
        String nextUserQuery = "SELECT user_id FROM waiting_list WHERE flight_id = ? ORDER BY added_date ASC LIMIT 1";
        try (PreparedStatement nextStmt = conn.prepareStatement(nextUserQuery)) {
            nextStmt.setInt(1, flightId);
            ResultSet rs = nextStmt.executeQuery();
            if (rs.next()) {
                int nextUserId = rs.getInt("user_id");

                // Insert into reservations
                String insertReservation = "INSERT INTO reservations (user_id, flight_id, seat_class, status) VALUES (?, ?, 'economy', 'reserved')";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertReservation)) {
                    insertStmt.setInt(1, nextUserId);
                    insertStmt.setInt(2, flightId);
                    insertStmt.executeUpdate();
                }

                // Remove from waiting list
                String deleteWaitlist = "DELETE FROM waiting_list WHERE user_id = ? AND flight_id = ?";
                try (PreparedStatement deleteStmt = conn.prepareStatement(deleteWaitlist)) {
                    deleteStmt.setInt(1, nextUserId);
                    deleteStmt.setInt(2, flightId);
                    deleteStmt.executeUpdate();
                }

                System.out.println("Promoted user_id=" + nextUserId + " from waiting list.");
            }
        }
    }

    // Edit an existing reservation to a different user
    public void editReservation(Connection conn, int flightId, int oldUserId, int newUserId) throws SQLException {
        String updateQuery = "UPDATE reservations SET user_id = ? WHERE flight_id = ? AND user_id = ? AND status = 'reserved'";
        try (PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
            stmt.setInt(1, newUserId);
            stmt.setInt(2, flightId);
            stmt.setInt(3, oldUserId);
            int updatedRows = stmt.executeUpdate();
            if (updatedRows > 0) {
                System.out.println("Reservation updated: old_user_id=" + oldUserId + " -> new_user_id=" + newUserId);
            } else {
                System.out.println("No reservation found to update.");
            }
        }
    }

    // Reply to a user question
    public void replyToUser(Connection conn, int questionId, String answerText) throws SQLException {
        String replyQuery = "UPDATE questions SET answer_text = ?, answered = 1 WHERE question_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(replyQuery)) {
            stmt.setString(1, answerText);
            stmt.setInt(2, questionId);
            int updated = stmt.executeUpdate();
            if (updated > 0) {
                System.out.println("Answered question_id=" + questionId);
            } else {
                System.out.println("Question not found to answer.");
            }
        }
    }

    // Get list of flights by airport code
    public List<Integer> getFlightsByAirport(Connection conn, String airportCode) throws SQLException {
        List<Integer> flightIds = new ArrayList<>();
        String query = "SELECT flight_id FROM flights WHERE origin_airport_code = ? OR destination_airport_code = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, airportCode);
            stmt.setString(2, airportCode);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                flightIds.add(rs.getInt("flight_id"));
            }
        }
        return flightIds;
    }

    // Get users currently on the waiting list for a flight
    public List<Integer> getWaitingList(Connection conn, int flightId) throws SQLException {
        List<Integer> waitingUsers = new ArrayList<>();
        String query = "SELECT user_id FROM waiting_list WHERE flight_id = ? ORDER BY added_date ASC";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, flightId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                waitingUsers.add(rs.getInt("user_id"));
            }
        }
        return waitingUsers;
    }
}
