package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.TopProduct;

public class TopProductDAO {

    public List<TopProduct> getTopSellingProducts(int limit) {
    List<TopProduct> topProducts = new ArrayList<>();
        String sql = "SELECT p.PRODUCT_ID, p.PRODUCTNAME, p.DESCRIPTION, p.IMAGE_URL, sales.totalSold "
                + "FROM ( "
                + "    SELECT oi.PRODUCTID, SUM(oi.QUANTITY) AS totalSold "
                + "    FROM ORDERITEMS oi "
                + "    GROUP BY oi.PRODUCTID "
                + "    ORDER BY totalSold DESC FETCH FIRST " + limit + " ROWS ONLY "
                + ") sales "
                + "JOIN PRODUCTS p ON sales.PRODUCTID = p.PRODUCT_ID";
    
    try (Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GlowyDaysDB", "nbuser", "nbuser");
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            TopProduct product = new TopProduct();
            product.setProductId(rs.getInt("PRODUCT_ID"));
            product.setProductName(rs.getString("PRODUCTNAME"));
            product.setDescription(rs.getString("DESCRIPTION"));
            product.setImageUrl(rs.getString("IMAGE_URL"));
            product.setQuantitySold(rs.getInt("totalSold"));

            // ✅ Add the product to the list!
            topProducts.add(product);
        }

    } catch (SQLException e) {
        e.printStackTrace(); // Consider logging it
    }

    return topProducts;
}
}

