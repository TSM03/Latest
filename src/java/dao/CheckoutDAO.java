package dao;

import model.CheckoutDetail;
import java.sql.*;

public class CheckoutDAO {

    private static final String JDBC_URL = "jdbc:derby://localhost:1527/GlowyDaysDB"; 
    private static final String USERNAME = "nbuser";
    private static final String PASSWORD = "nbuser";

    public CheckoutDetail getCheckoutDetailByUserId(int userId) {
        CheckoutDetail checkoutDetail = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(JDBC_URL, USERNAME, PASSWORD);

            String sql = "SELECT * FROM CHECKOUTDETAILS WHERE USERID = ? ORDER BY CHECKOUTDATE DESC FETCH FIRST 1 ROWS ONLY";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                checkoutDetail = new CheckoutDetail();
                checkoutDetail.setCheckoutId(rs.getInt("CHECKOUTID"));
                checkoutDetail.setUserId(rs.getInt("USERID"));
                checkoutDetail.setSubtotal(rs.getBigDecimal("SUBTOTAL"));
                checkoutDetail.setTaxAmount(rs.getBigDecimal("TAXAMOUNT"));
                checkoutDetail.setDeliveryFee(rs.getBigDecimal("DELIVERYFEE"));
                checkoutDetail.setTotalAmount(rs.getBigDecimal("TOTALAMOUNT"));
                checkoutDetail.setCheckoutDate(rs.getTimestamp("CHECKOUTDATE"));
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return checkoutDetail;
    }
}
