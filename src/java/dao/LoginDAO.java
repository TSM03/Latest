package dao;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.sql.*;
import model.Login;
import model.User;
import dao.CartDAO;

public class LoginDAO {

    public boolean loginUser(Login login, HttpServletRequest request) {
        boolean isLogin = false;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/GlowyDaysDB", "nbuser", "nbuser");

            String sql = "SELECT u.*, c.CARTID "
                    + "FROM USERS u "
                    + "LEFT JOIN CART c ON u.USER_ID = c.USERID "
                    + "WHERE u.EMAIL = ? "
                    + "AND u.PASSWORD = ? ";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, login.getEmail());
            pst.setString(2, login.getPassword());

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                isLogin = true;
                int userID = rs.getInt("USER_ID");
                String username = rs.getString("USERNAME");
                String name = rs.getString("NAME");
                Date birth = rs.getDate("BIRTH");
                String email = rs.getString("EMAIL");
                String mobileNo = rs.getString("MOBILENO");// 从数据库取出 username
                String password = rs.getString("PASSWORD");
                String role = rs.getString("ROLE");

                // New added for cart
                Integer cartID = rs.getInt("CARTID");
                boolean hasCart = !rs.wasNull();

                if (!hasCart) {
                    String insertCartSQL = "INSERT INTO CART (USERID) VALUES (?)";
                    PreparedStatement insertCartPst = con.prepareStatement(insertCartSQL, Statement.RETURN_GENERATED_KEYS);
                    insertCartPst.setInt(1, userID);
                    insertCartPst.executeUpdate();

                    ResultSet generatedKeys = insertCartPst.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        cartID = generatedKeys.getInt(1);
                    }

                    generatedKeys.close();
                    insertCartPst.close();
                }

                HttpSession session = request.getSession();
                session.setAttribute("user_id", userID);
                session.setAttribute("username", username);
                session.setAttribute("name", name);
                session.setAttribute("birth", birth != null ? birth.toString() : null);
                session.setAttribute("email", email);
                session.setAttribute("mobileNo", mobileNo);
                session.setAttribute("password", password);
                session.setAttribute("role", role);
                session.setAttribute("cart_id", cartID);
            }

            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return isLogin;
    }

    public boolean isEmailRegistered(String email) {
        boolean exists = false;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/GlowyDaysDB", "nbuser", "nbuser");

            String sql = "SELECT * FROM USERS WHERE EMAIL = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, email);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                exists = true;
            }

            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return exists;
    }

    public User getUserByLogin(Login login) {
        User user = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/GlowyDaysDB", "nbuser", "nbuser");

            String sql = "SELECT * FROM USERS WHERE EMAIL = ? AND PASSWORD = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, login.getEmail());
            pst.setString(2, login.getPassword());

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getLong("USER_ID"));
                user.setName(rs.getString("NAME"));
                user.setUsername(rs.getString("USERNAME"));
                user.setBirth(rs.getDate("BIRTH").toLocalDate()); // converting SQL Date to LocalDate
                user.setEmail(rs.getString("EMAIL"));
                user.setMobileNo(rs.getString("MOBILENO"));
                user.setPassword(rs.getString("PASSWORD"));
                user.setRole(rs.getString("ROLE"));
            }

            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

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
                System.out.println("⚠ No rows inserted!");
            }

            pst.close();
            con.close();
        } catch (Exception e) {
            System.out.println("❌ Exception during registration:");
            e.printStackTrace(System.out);

        }

        return isRegistered;
    }

    public User getUserByEmail(String email) {
        User user = null;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/GlowyDaysDB", "nbuser", "nbuser");

            String sql = "SELECT * FROM USERS WHERE EMAIL = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, email);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getLong("USER_ID"));
                user.setName(rs.getString("NAME"));
                user.setUsername(rs.getString("USERNAME"));
                user.setBirth(rs.getDate("BIRTH").toLocalDate());
                user.setEmail(rs.getString("EMAIL"));
                user.setMobileNo(rs.getString("MOBILENO"));
                user.setPassword(rs.getString("PASSWORD"));
                user.setRole(rs.getString("ROLE"));
            }

            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

}
