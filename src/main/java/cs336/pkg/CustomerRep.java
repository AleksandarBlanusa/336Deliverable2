package cs336.pkg;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerRep {

    private ApplicationDB db = new ApplicationDB();  // Reuse your ApplicationDB class

    // Make a flight reservation
    public boolean makeReservation(int flightId, int userId, String seatClass) {
        String checkSeatsQuery = "SELECT available_seats FROM flights WHERE flight_id = ?";
        String reserveQuery = "INSERT INTO reservations (user_id, flight_id, seat_class, status) VALUES (?, ?, ?, 'reserved')";
        String updateSeatsQuery = "UPDATE flights SET available_seats = available_seats - 1 WHERE flight_id = ?";
        String waitlistInsertQuery = "INSERT INTO waiting_list (user_id, flight_id) VALUES (?, ?)";

        try (Connection conn = db.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSeatsQuery)) {

            checkStmt.setInt(1, flightId);
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    int availableSeats = rs.getInt("available_seats");

                    if (availableSeats > 0) {
                        // Reserve the flight
                        try (PreparedStatement reserveStmt = conn.prepareStatement(reserveQuery);
                             PreparedStatement updateStmt = conn.prepareStatement(updateSeatsQuery)) {

                            reserveStmt.setInt(1, userId);
                            reserveStmt.setInt(2, flightId);
                            reserveStmt.setString(3, seatClass);
                            reserveStmt.executeUpdate();

                            updateStmt.setInt(1, flightId);
                            updateStmt.executeUpdate();
                        }

                        System.out.println("Reservation made successfully.");
                        return true;

                    } else {
                        // Add to waiting list
                        try (PreparedStatement waitlistStmt = conn.prepareStatement(waitlistInsertQuery)) {
                            waitlistStmt.setInt(1, userId);
                            waitlistStmt.setInt(2, flightId);
                            waitlistStmt.executeUpdate();
                        }

                        System.out.println("No seats available. Added to waiting list.");
                        return false;
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }


    // Cancel a reservation
    public void cancelReservation(int flightId, int userId) {
        String cancelQuery = "UPDATE reservations SET status = 'cancelled' WHERE flight_id = ? AND user_id = ? AND status = 'reserved'";
        String incrementSeatsQuery = "UPDATE flights SET available_seats = available_seats + 1 WHERE flight_id = ?";

        try (Connection conn = new ApplicationDB().getConnection()) {
            // Step 1: Cancel the reservation
            try (PreparedStatement cancelStmt = conn.prepareStatement(cancelQuery)) {
                cancelStmt.setInt(1, flightId);
                cancelStmt.setInt(2, userId);
                int rowsUpdated = cancelStmt.executeUpdate();

                if (rowsUpdated > 0) {
                    // Step 2: Increase available seats
                    try (PreparedStatement updateStmt = conn.prepareStatement(incrementSeatsQuery)) {
                        updateStmt.setInt(1, flightId);
                        updateStmt.executeUpdate();
                    }

                    System.out.println("Reservation cancelled and seat released for user_id=" + userId);

                    // Step 3: Promote a user from waiting list (optional)
                    promoteFromWaitingList(conn, flightId);

                } else {
                    System.out.println("No active reservation found to cancel.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
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

                String insertReservation = "INSERT INTO reservations (user_id, flight_id, seat_class, status) VALUES (?, ?, 'economy', 'reserved')";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertReservation)) {
                    insertStmt.setInt(1, nextUserId);
                    insertStmt.setInt(2, flightId);
                    insertStmt.executeUpdate();
                }

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
    public void editReservation(int flightId, int oldUserId, int newUserId) {
        Connection conn = db.getConnection();
        if (conn == null) return;
        try {
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
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.closeConnection(conn);
        }
    }

    // Reply to a user question
    public void replyToUser(int questionId, String answerText) {
        Connection conn = db.getConnection();
        if (conn == null) return;
        try {
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
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.closeConnection(conn);
        }
    }

    // Get list of flights by airport code
    public List<Integer> getFlightsByAirport(String airportCode) {
        Connection conn = db.getConnection();
        List<Integer> flightIds = new ArrayList<>();
        if (conn == null) return flightIds;
        try {
            String query = "SELECT flight_id FROM flights WHERE origin_airport_code = ? OR destination_airport_code = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, airportCode);
                stmt.setString(2, airportCode);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    flightIds.add(rs.getInt("flight_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.closeConnection(conn);
        }
        return flightIds;
    }

    
    
    // Get all unanswered user questions
    public List<Map<String, Object>> getPendingQuestions() {
        List<Map<String, Object>> result = new ArrayList<>();
        String query = "SELECT q.question_id, q.user_id, q.flight_id, q.question_text, q.answered, " +
                       "u.firstname, u.lastname, u.email " +
                       "FROM questions q " +
                       "JOIN users u ON q.user_id = u.user_id " +
                       "WHERE q.answered = 0";

        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("question_id", rs.getInt("question_id"));
                row.put("user_id", rs.getInt("user_id"));
                row.put("flight_id", rs.getInt("flight_id"));
                row.put("question_text", rs.getString("question_text"));
                row.put("answered", rs.getInt("answered"));
                row.put("firstname", rs.getString("firstname"));
                row.put("lastname", rs.getString("lastname"));
                row.put("email", rs.getString("email"));
                result.add(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }



    // Get full user info for users in waiting list (for display)
    public List<User> getWaitingList() {
        List<User> list = new ArrayList<>();
        String query = "SELECT u.user_id, u.firstname, u.lastname FROM users u " +
                       "JOIN waiting_list w ON u.user_id = w.user_id";

        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFirstname(rs.getString("firstname"));
                u.setLastname(rs.getString("lastname"));
                list.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    



}
