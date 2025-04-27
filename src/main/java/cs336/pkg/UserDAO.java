package cs336.pkg;
import cs336.pkg.User;
import cs336.pkg.ApplicationDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public User getById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setRole(rs.getString("role"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    return user;
                }
            }
        }
        return null;
    }
    
    public User getByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    return user;
                }
            }
        }
        return null;
    }
    
    public List<User> getAllCustomerReps() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'CUSTOMER_REP'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                users.add(user);
            }
        }
        return users;
    }
    
    public int save(User user) throws SQLException {
        if (user.getUserId() > 0) {
            return update(user);
        } else {
            return insert(user);
        }
    }
    
    private int insert(User user) throws SQLException {
        String sql = "INSERT INTO users (username, password, role, full_name, email) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getRole());
            stmt.setString(4, user.getFullName());
            stmt.setString(5, user.getEmail());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setUserId(generatedKeys.getInt(1));
                    return user.getUserId();
                } else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
        }
    }
    
    private int update(User user) throws SQLException {
        String sql = "UPDATE users SET username = ?, role = ?, full_name = ?, email = ? WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getRole());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getEmail());
            stmt.setInt(5, user.getUserId());
            
            return stmt.executeUpdate();
        }
    }
    
    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean delete(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean validateCredentials(String username, String password) throws SQLException {
        String sql = "SELECT password FROM users WHERE username = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    // In a real application, you would use password hashing
                    return storedPassword.equals(password);
                }
            }
        }
        return false;
    }
}
