package dao;

import java.sql.*;
import java.util.*;
import model.ViewOrderItem;
import java.time.LocalDate;
import java.sql.Date;
import model.ShippingInfo;

public class ViewUserOrderDAO {

    public Map<String, List<ViewOrderItem>> getOrdersByUserId(Connection conn, int userId) throws SQLException {
        Map<String, List<ViewOrderItem>> ordersByOrderId = new HashMap<>();

        String sql = "SELECT o.ORDERID, p.PRODUCTNAME, p.PRICE, p.IMAGE_URL, oi.QUANTITY "
                + "FROM ORDERS o "
                + "JOIN ORDERITEMS oi ON o.ORDERID = oi.ORDERID "
                + "JOIN PRODUCTS p ON oi.PRODUCTID = p.PRODUCT_ID "
                + "WHERE o.USERID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String orderId = rs.getString("ORDERID");
                String productName = rs.getString("PRODUCTNAME");
                double price = rs.getDouble("PRICE");
                String imageUrl = rs.getString("IMAGE_URL");
                int quantity = rs.getInt("QUANTITY");

                ViewOrderItem item = new ViewOrderItem(productName, quantity, price, imageUrl);

                ordersByOrderId.computeIfAbsent(orderId, k -> new ArrayList<>()).add(item);
            }
        }

        return ordersByOrderId;
    }

    public Map<String, Map<String, String>> getOrderStatus(Connection conn, int userId) throws SQLException {
        Map<String, Map<String, String>> orderStatusMap = new HashMap<>();
        String sql = "SELECT o.ORDERID, o.SHIPPEDSTATUS, t.TRACKINGNO, t.UPDATEDATE "
                + "FROM ORDERS o "
                + "LEFT JOIN TRACKING t ON o.ORDERID = t.ORDERID "
                + "WHERE o.USERID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String orderId = rs.getString("ORDERID");
                boolean shippedStatus = rs.getBoolean("SHIPPEDSTATUS");
                String trackingNo = rs.getString("TRACKINGNO");
                Date updateDate = rs.getDate("UPDATEDATE");
                String status;

                if (!shippedStatus) {
                    status = "To Ship";
                } else {
                    LocalDate today = LocalDate.now();
                    if (updateDate != null) {
                        LocalDate updateLocalDate = updateDate.toLocalDate();
                        if (today.isAfter(updateLocalDate) || today.isEqual(updateLocalDate)) {
                            status = "Delivered";
                        } else {
                            status = "In Transit";
                        }
                    } else {
                        status = "In Transit"; // fallback if no updateDate
                    }
                }
                Map<String, String> statusAndTracking = new HashMap<>();
                statusAndTracking.put("status", status);
                statusAndTracking.put("TRACKINGNO", (trackingNo != null) ? trackingNo : "-");

                orderStatusMap.put(orderId, statusAndTracking);
            }
        }
        return orderStatusMap;
    }

    public Map<String, ShippingInfo> getShippingInfo(Connection conn, int userId) throws SQLException {
        Map<String, ShippingInfo> shippingInfoMap = new HashMap<>();

        String sql = "SELECT o.ORDERID, b.FULLNAME, b.EMAIL, b.MOBILE, "
                + "a.ADDRESS, a.CITY, a.STATE, a.POSTCODE, "
                + "pm.METHODNAME "
                + "FROM ORDERS o "
                + "JOIN SHIPPINGDETAIL sd ON o.SHIPPINGID = sd.SHIPPINGID "
                + "JOIN BUYERDETAIL b ON sd.BUYERID = b.BUYERID "
                + "JOIN ADDRESS a ON sd.ADDRESSID = a.ADDRESSID "
                + "JOIN PAYMENT p ON o.PAYMENTID = p.PAYMENTID "
                + "JOIN PAYMENTMETHOD pm ON p.METHODID = pm.METHODID "
                + "WHERE o.USERID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String orderId = rs.getString("ORDERID");
                String fullName = rs.getString("FULLNAME");
                String email = rs.getString("EMAIL");
                String mobile = rs.getString("MOBILE");
                String address = rs.getString("ADDRESS") + ", "
                        + rs.getString("CITY") + ", "
                        + rs.getString("STATE") + ", "
                        + rs.getString("POSTCODE");
                String paymentMethod = rs.getString("METHODNAME");

                ShippingInfo shippingInfo = new ShippingInfo(fullName, email, mobile, address, paymentMethod);
                shippingInfoMap.put(orderId, shippingInfo);
            }
        }
        return shippingInfoMap;
    }

}
