import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.CartDAO;

import java.io.IOException;

// Adjust the URL pattern to whatever fits your project
@WebServlet("/ClearCartServlet")
public class ClearCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        cartDAO = new CartDAO(); // Initialize your DAO (you may adjust if you have dependency injection etc.)
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the session
        HttpSession session = request.getSession(false); // use false to avoid creating a new session if it doesn't exist

        if (session == null || session.getAttribute("user_id") == null) {
            // No session or user not logged in
            response.sendRedirect("/GlowyDaysProjectNew/JSP/Login.jsp"); // or wherever your login page is
            return;
        }

        try {
            // Get the user ID from session
            int userId = Integer.parseInt((String) request.getSession().getAttribute("user_id"));

            // Clear the cart using CartDAO
            boolean cleared = cartDAO.clearCart(userId);

            if (cleared) {
                // Cart cleared successfully
                session.setAttribute("message", "Cart cleared successfully!");
            } else {
                // Nothing was cleared, possibly because the cart was already empty
                session.setAttribute("message", "No items found in the cart to clear.");
            }

            // Redirect to cart page or wherever you want
            response.sendRedirect("/GlowyDaysProjectNew/JSP/Cart.jsp");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp"); // optional error page
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Optionally allow GET method to also clear cart (or just call doPost)
        doPost(request, response);
    }
}