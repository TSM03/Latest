
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import dao.OrderDAO;   // You need to create this DAO if you don't have one
import dao.PaymentDAO;
import dao.ShippingDAO;
import model.*;
import java.sql.Connection;
import java.sql.DriverManager;
import model.ShippingDetail;
import java.math.BigDecimal;
import model.CheckoutDetail;

@WebServlet("/ConfirmOrderServlet")
public class ConfirmOrderServlet extends HttpServlet {

    private Connection getConnection() throws Exception {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GlowyDaysDB", "nbuser", "nbuser");
            System.out.println("Connection established: " + (conn != null));
            return conn;
        } catch (Exception e) {
            System.err.println(" Failed to connect to DB:");
            e.printStackTrace();
            return null;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        CheckoutDetail checkoutDetail;

        try (Connection conn = getConnection()) {
            // 1. Get session attributes
            int userId = (Integer) session.getAttribute("user_id");
            int cartId = (Integer) session.getAttribute("cart_id");
            BuyerDetail buyer = (BuyerDetail) session.getAttribute("buyer");
            Address address = (Address) session.getAttribute("address");
            PaymentMethod paymentMethod = (PaymentMethod) session.getAttribute("paymentMethod");
            List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
            //CheckoutDetail checkoutDetail = (CheckoutDetail) session.getAttribute("checkoutDetail");
            ShippingDetail shippingDetail = (ShippingDetail) session.getAttribute("shippingDetail");

            Double subtotalVal = (Double) session.getAttribute("subtotal");
            Double taxAmountVal = (Double) session.getAttribute("taxAmount");
            Double deliveryFeeVal = (Double) session.getAttribute("deliveryFee");
            Double totalAmountVal = (Double) session.getAttribute("totalAmount");

            if (subtotalVal != null && taxAmountVal != null && deliveryFeeVal != null && totalAmountVal != null) {
                // Convert to BigDecimal
                BigDecimal subtotal = BigDecimal.valueOf(subtotalVal);
                BigDecimal taxAmount = BigDecimal.valueOf(taxAmountVal);
                BigDecimal deliveryFee = BigDecimal.valueOf(deliveryFeeVal);
                BigDecimal totalAmount = BigDecimal.valueOf(totalAmountVal);

                checkoutDetail = new CheckoutDetail(subtotal, taxAmount, deliveryFee, totalAmount);

            } else {
                // Handle missing session values
                throw new IllegalStateException("Missing subtotal/tax/delivery/total in session.");
            }

            if (buyer == null || address == null || paymentMethod == null || cartItems == null) {
                throw new IllegalStateException("Required checkout details are missing in session.");
            }
            
            OrderDAO orderDAO = new OrderDAO(conn);
            ShippingDAO shippingDAO = new ShippingDAO();

            String shippingId = shippingDAO.getLatestShippingId();

            PaymentDAO paymentDAO = new PaymentDAO();
            String paymentId = paymentDAO.generatePaymentId(conn); 

            String orderID = orderDAO.generateOrderId();

            boolean shippingSaved = shippingDAO.saveShipping(buyer, address);
            boolean paymentSaved = paymentDAO.savePayment(paymentMethod);
            boolean orderSaved = orderDAO.saveOrder(orderID, userId, cartId, shippingDetail, paymentMethod, cartItems, checkoutDetail, paymentId);

            if (!shippingSaved) {
                throw new Exception("Failed to save shipping information to database");
            }

            if (!paymentSaved) {
                throw new Exception("Failed to save payment information to database");
            }

            if (!orderSaved) {
                throw new Exception("Failed to save order information to database");
            }

            // 2. Create Order and save it
            //   OrderDAO orderDAO = new OrderDAO();
            //  boolean orderSaved = orderDAO.saveOrder(buyer, address, paymentMethod, cartItems, checkoutDetail);
            //  if (!orderSaved) {
            //    throw new Exception("Failed to save the order to the database.");
            //  }
            // 3. Clear cart after order confirmed (optional)
            session.removeAttribute("cartItems");

            // 4. Redirect to success page
            response.sendRedirect(request.getContextPath() + "/JSP/ThankYou.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            try (PrintWriter out = response.getWriter()) {
                out.println("<html><body>");
                out.println("<h2>Order Error</h2>");
                out.println("<p>" + e.getMessage() + "</p>");
                out.println("<a href='checkoutReview.jsp'>Back to Checkout</a>");
                out.println("</body></html>");
            }
        }
    }

    
}
