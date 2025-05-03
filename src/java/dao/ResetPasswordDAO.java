package dao;
import java.sql.*;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ResetPasswordDAO {

    private final String jdbcURL = "jdbc:derby://localhost:1527/GlowyDaysDB";
    private final String jdbcUsername = "nbuser";
    private final String jdbcPassword = "nbuser";

    public boolean updatePasswordByEmail(String email, String password) {
        String sql = "UPDATE USERS SET PASSWORD = ? WHERE EMAIL = ?";
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
            PreparedStatement statement = connection.prepareStatement(sql);

            statement.setString(1, password);
            statement.setString(2, email);

            int result = statement.executeUpdate();

            statement.close();
            connection.close();

            return result > 0;

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}