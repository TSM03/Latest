package dao;

import java.sql.*;
import model.User;
import java.util.List;
import java.util.ArrayList;

public class UserDAO {

    public boolean registerUser(User user) {
        boolean isRegistered = false;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/GlowyDaysDB", "nbuser", "nbuser");

            String sql = "INSERT INTO USERS (NAME, USERNAME, BIRTH, EMAIL, MOBILENO, PASSWORD, ROLE) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, user.getName());
            pst.setString(2, user.getUsername());
            pst.setDate(3, java.sql.Date.valueOf(user.getBirth()));
            pst.setString(4, user.getEmail());
            pst.setString(5, user.getMobileNo());
            pst.setString(6, user.getPassword());
            pst.setString(7, user.getRole()); // 👈 this should be "staff"

            int rowCount = pst.executeUpdate();
            if (rowCount > 0) {
                isRegistered = true;
                System.out.println("✅ Registered user with role: " + user.getRole());
            } else {
                System.out.println("⚠️ No rows inserted!");
            }

            pst.close();
            con.close();
        } catch (Exception e) {
            System.out.println("❌ Exception during registration:");
            e.printStackTrace(System.out);

        }

        return isRegistered;
    }

    public List<User> getAllStaff() {
        List<User> staffList = new ArrayList<>();
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/GlowyDaysDB", "nbuser", "nbuser");

            String sql = "SELECT * FROM USERS WHERE ROLE = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, "staff");
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getLong("USER_ID"));
                user.setName(rs.getString("NAME"));
                user.setPassword(rs.getString("USERNAME"));
                user.setBirth(rs.getDate("BIRTH").toLocalDate());
                user.setEmail(rs.getString("EMAIL"));
                user.setMobileNo(rs.getString("MOBILENO"));
                user.setPassword(rs.getString("PASSWORD"));
                user.setRole(rs.getString("ROLE"));

                staffList.add(user);
            }

            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return staffList;
    }

    public boolean editUser(User user) {
        boolean isSuccess = false;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/GlowyDaysDB", "nbuser", "nbuser");

            // String query = "UPDATE USERS SET NAME = ?, USERNAME = ?, BIRTH = ?, EMAIL = ?, MOBILENO = ? WHERE cust_id=?";
            String query = "UPDATE USERS SET NAME = ?, USERNAME = ?, BIRTH = ?, EMAIL = ?, MOBILENO = ? WHERE USERID=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, user.getName());
            pst.setString(2, user.getUsername());
            pst.setDate(3, Date.valueOf(user.getBirth()));
            pst.setString(4, user.getEmail());
            pst.setString(5, user.getName());
            pst.setLong(6, user.getId());

            int rowsAffected = pst.executeUpdate();
            if (rowsAffected > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }
}
