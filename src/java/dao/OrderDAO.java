package dao;

import java.sql.*;
import java.util.*;
import model.Order;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import model.ShippingDetail;
import model.BuyerDetail;
import model.CartItem;
import model.CheckoutDetail;
import model.PaymentMethod;

public class OrderDAO {

    private Connection conn;

    public OrderDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        try {
            // Corrected with "" for attributes
            String sql = "SELECT o.ORDERID, o.ORDERDATE, o.SHIPPEDSTATUS, "
                    + "s.TRACKINGNO "
                    + "FROM ORDERS o "
                    + "LEFT JOIN TRACKING s ON o.ORDERID = s.ORDERID "
                    + "ORDER BY o.ORDERDATE DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String id = rs.getString("ORDERID");
                Timestamp orderDateTs = rs.getTimestamp("ORDERDATE");
                String date = (orderDateTs != null) ? orderDateTs.toLocalDateTime().toString() : null;
                boolean shipped = rs.getBoolean("SHIPPEDSTATUS");
                String tracking = rs.getString("TRACKINGNO"); // can be null

                orders.add(new Order(id, date, shipped, tracking));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public boolean insertShipping(String shippingId, String orderId, String trackingNo) throws SQLException {
        // Correct with double quotes
        String insertSQL = "INSERT INTO TRACKING (TRACKINGID, ORDERID, TRACKINGNO, SHIPPINGDATE, SHIPPINGTIME, UPDATEDATE) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement insertShippingStmt = conn.prepareStatement(insertSQL)) {
            insertShippingStmt.setString(1, shippingId);
            insertShippingStmt.setString(2, orderId);
            insertShippingStmt.setString(3, trackingNo);
            insertShippingStmt.setDate(4, Date.valueOf(LocalDate.now()));
            insertShippingStmt.setTime(5, Time.valueOf(LocalTime.now()));
            insertShippingStmt.setDate(6, Date.valueOf(LocalDate.now().plusDays(7)));
            return insertShippingStmt.executeUpdate() > 0;
        }
    }

    public boolean updateOrderStatus(String orderId) throws SQLException {
        String updateSQL = "UPDATE ORDERS SET SHIPPEDSTATUS = TRUE WHERE ORDERID = ?";
        try (PreparedStatement updateOrderStmt = conn.prepareStatement(updateSQL)) {
            updateOrderStmt.setString(1, orderId);
            return updateOrderStmt.executeUpdate() > 0;
        }
    }

    public boolean isTrackingNumberExists(String trackingNo) throws SQLException {
        String sql = "SELECT COUNT(*) FROM TRACKING WHERE TRACKINGNO = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, trackingNo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public String getNextShippingId() throws SQLException {
        String sql = "SELECT TRACKINGID FROM TRACKING ORDER BY TRACKINGID DESC FETCH FIRST ROW ONLY";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String lastId = rs.getString("TRACKINGID"); // e.g., "SID5"
                int num = Integer.parseInt(lastId.substring(3)); // extract numeric part
                return "SID" + (num + 1); // increment and return
            }
        }
        return "SID1"; // default if no shipping IDs exist yet
    }

    public String generateOrderId() throws SQLException {
        String sql = "SELECT MAX(ORDERID) AS maxId FROM ORDERS";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next() && rs.getString("maxId") != null) {
                String maxId = rs.getString("maxId");
                int num = Integer.parseInt(maxId.substring(4));
                return String.format("OID-%04d", num + 1);
            } else {
                return "OID-0001";
            }
        }

    }

    public boolean saveOrder(String orderId, int userid, int cartid, ShippingDetail shippingDetail, PaymentMethod paymentMethod, List<CartItem> cartItems, CheckoutDetail checkoutDetail, String paymentId) throws Exception {

        Connection conn = null;
        PreparedStatement ps = null;

        boolean success = false;
        String insertOrderSQL = "INSERT INTO ORDERS (ORDERID, USERID, ORDERDATE, PAYMENTID, SHIPPINGID, SUBTOTAL, TAXAMOUNT, DELIVERYFEE, TOTALAMOUNT) "
                + "VALUES (?, ?, CURRENT_TIMESTAMP, ?, ?, ?, ?, ?, ?)";
        String insertItemSQL = "INSERT INTO ORDERITEMS (ORDERID, PRODUCTID, QUANTITY) VALUES (?, ?, ?)";
        String clearCartItemsSQL = "DELETE FROM CARTDETAILS WHERE CARTID =  ? ";
        String updateStockSQL = "UPDATE PRODUCTS SET STOCK_QUANTITY = STOCK_QUANTITY - ? WHERE PRODUCT_ID = ?";

        Class.forName("org.apache.derby.jdbc.ClientDriver");
        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GlowyDaysDB", "nbuser", "nbuser");

        try (
                PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL); PreparedStatement psItem = conn.prepareStatement(insertItemSQL); PreparedStatement psClearCart = conn.prepareStatement(clearCartItemsSQL); PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSQL)) {

            // Insert order
            psOrder.setString(1, orderId);
            psOrder.setInt(2, userid);
            psOrder.setString(3, paymentId);
            psOrder.setString(4, shippingDetail.getShippingId());
            psOrder.setBigDecimal(5, checkoutDetail.getSubtotal());
            psOrder.setBigDecimal(6, checkoutDetail.getTaxAmount());
            psOrder.setBigDecimal(7, checkoutDetail.getDeliveryFee());
            psOrder.setBigDecimal(8, checkoutDetail.getTotalAmount());

            int orderInserted = psOrder.executeUpdate();
            if (orderInserted != 1) {
                return false;
            }

            // Insert items
            for (CartItem item : cartItems) {
                psItem.setString(1, orderId);
                psItem.setInt(2, item.getId());
                psItem.setInt(3, item.getQuantity());
                psItem.addBatch();
            }

            int[] itemResults = psItem.executeBatch();
            success = Arrays.stream(itemResults).allMatch(result -> result >= 0);

            // Clear the cart
            psClearCart.setInt(1, cartid); // assuming userid == cartid
            psClearCart.executeUpdate();

            // Update product stock
            for (CartItem item : cartItems) {
                psUpdateStock.setInt(1, item.getQuantity());
                psUpdateStock.setInt(2, item.getId());
                psUpdateStock.addBatch();
            }
            
            int[] stockResults = psUpdateStock.executeBatch();
            boolean stockUpdated = Arrays.stream(stockResults).allMatch(result -> result >= 0);
            if (!stockUpdated) {
                conn.rollback();
                return false;
            }

            success = true;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return success;

//        try {
//
//            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GlowyDaysDB", "nbuser", "nbuser");
//
//            // 1. Insert into ORDERS table
//            String orderSql = "INSERT INTO ORDERS (ORDERID, TOTALAMOUNT, PAYMENTID, SHIPPINGID, ORDERDATE) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";
//            ps = conn.prepareStatement(orderSql, PreparedStatement.RETURN_GENERATED_KEYS);
//
//            ps.setString(1, orderId);
//            ps.setBigDecimal(2, checkoutDetail.getTotalAmount());
//            ps.setString(3, paymentMethod.getMethodId());
//            ps.setString(4, shippingDetail.getShippingId());  // Assuming Address already has ID
//
//            int rows = ps.executeUpdate();
//
//            if (rows == 0) {
//                throw new SQLException("Failed to insert order.");
//            }
//
//            // 2. Get generated order_id
//            int orderId = 0;
//            try (var rs = ps.getGeneratedKeys()) {
//                if (rs.next()) {
//                    orderId = rs.getInt(1);
//                } else {
//                    throw new SQLException("Failed to retrieve order ID.");
//                }
//            }
//
//            // 3. Insert each CartItem into ORDER_ITEMS
//            // String itemSql = "INSERT INTO ORDERITEMS (ORDERID, PRODUCTID, QUANTITY, PRICE) VALUES (?, ?, ?, ?)";
//            String itemSql = "INSERT INTO ORDERITEMS (ORDERID, PRODUCTID, QUANTITY) VALUES (?, ?, ?)";
//            PreparedStatement itemPs = conn.prepareStatement(itemSql);
//
//            for (CartItem item : cartItems) {
//                itemPs.setInt(1, orderId);
//                itemPs.setString(2, item.getProduct().getProductId());
//                itemPs.setInt(3, item.getQuantity());
//                // itemPs.setDouble(4, item.getProduct().getPrice());
//                itemPs.addBatch();
//            }
//
//            itemPs.executeBatch();
//            itemPs.close();
//
//            return true;
//
//        } finally {
//            if (ps != null) {
//                ps.close();
//            }
//            if (conn != null) {
//                conn.close();
//            }
//        }
    }

}
