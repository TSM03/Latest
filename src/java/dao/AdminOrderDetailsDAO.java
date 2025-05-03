package dao;

import model.AdminViewOrderDetails;
import java.sql.*;
import model.AdminViewOrderDetailsItem;
import java.util.ArrayList;
import java.util.List;

public class AdminOrderDetailsDAO {

    private String jdbcURL = "jdbc:derby://localhost:1527/GlowyDaysDB";
    private String jdbcUsername = "nbuser";
    private String jdbcPassword = "nbuser";

    private static final String SELECT_ORDER_BY_ID
            = "SELECT "
            + "o.ORDERID, "
            + "o.ORDERDATE, "
            + "o.USERID, "
            + "pm.METHODNAME, "
            + "a.ADDRESS, "
            + "o.SHIPPEDSTATUS, "
            + "t.TRACKINGNO, "
            + "t.SHIPPINGDATE, "
            + "t.SHIPPINGTIME, "
            + "CASE "
            + "    WHEN o.SHIPPEDSTATUS = false THEN 'To Ship' "
            + "    WHEN o.SHIPPEDSTATUS = true "
            + "         AND CURRENT_DATE < t.UPDATEDATE THEN 'In Transit' "
            + "    WHEN o.SHIPPEDSTATUS = true "
            + "         AND CURRENT_DATE >= t.UPDATEDATE THEN 'Delivered' "
            + "END AS ARRIVALSTATUS "
            + "FROM ORDERS o "
            + "JOIN PAYMENT p ON o.PAYMENTID = p.PAYMENTID "
            + "JOIN PAYMENTMETHOD pm ON p.METHODID = pm.METHODID "
            + "JOIN SHIPPINGDETAIL s ON o.SHIPPINGID = s.SHIPPINGID "
            + "JOIN ADDRESS a ON s.ADDRESSID = a.ADDRESSID "
            + "LEFT JOIN TRACKING t ON o.ORDERID = t.ORDERID "
            + "WHERE o.orderId = ?";

    private static final String SELECT_ORDER_ITEM
        = "SELECT p.PRODUCTNAME, p.PRICE, p.IMAGE_URL, oi.QUANTITY "
        + "FROM ORDERITEMS oi "
        + "JOIN PRODUCTS p ON oi.PRODUCTID = p.PRODUCT_ID "
        + "WHERE oi.ORDERID = ?";
    

    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public AdminViewOrderDetails getOrderDetailsById(String orderId) {
        AdminViewOrderDetails order = null;

        try (Connection connection = getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ORDER_BY_ID)) {

            preparedStatement.setString(1, orderId);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                order = new AdminViewOrderDetails();
                order.setOrderId(rs.getString("ORDERID"));
                order.setOrderDate(rs.getDate("ORDERDATE"));
                order.setUserId(rs.getInt("USERID"));
                order.setAddress(rs.getString("ADDRESS"));
                order.setPaymentMethod(rs.getString("METHODNAME"));
                order.setShippedStatus(rs.getString("SHIPPEDSTATUS"));
                order.setTrackingNo(rs.getString("TRACKINGNO"));
                order.setShipDate(rs.getDate("SHIPPINGDATE"));
                order.setShipTime(rs.getTime("SHIPPINGTIME"));
                order.setArrivalStatus(rs.getString("ARRIVALSTATUS"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    public List<AdminViewOrderDetailsItem> getOrderItemsByOrderId(String orderId) {
        List<AdminViewOrderDetailsItem> items = new ArrayList<>();

        try (Connection connection = getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ORDER_ITEM)) {

            preparedStatement.setString(1, orderId);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                String productName = rs.getString("PRODUCTNAME");
                double price = rs.getDouble("PRICE");
                String imageUrl = rs.getString("IMAGE_URL");
                int quantity = rs.getInt("QUANTITY");

                AdminViewOrderDetailsItem item = new AdminViewOrderDetailsItem(productName, price, imageUrl, quantity);
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return items;
    }
}