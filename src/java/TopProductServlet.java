
import dao.TopProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.TopProduct;

@WebServlet("/TopProductServlet")
public class TopProductServlet extends HttpServlet {

    private TopProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new TopProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<TopProduct> topProducts = productDAO.getTopSellingProducts(4);
        System.out.println("Top products size: " + topProducts.size());

        request.setAttribute("topProducts", topProducts);
        
        String role = (String) request.getSession().getAttribute("role"); // Get role from session
        String targetPage;

        if (role == null) {
            targetPage = "/JSP/GuestHome.jsp"; // Case: session has no role (guest)
        } else {
            switch (role) {
                case "customer":
                    targetPage = "/JSP/UserHome.jsp";
                    break;
                default:
                    targetPage = "/JSP/GuestHome.jsp"; // Unknown roles treated as guest
                    break;
            }
        }
        
        request.getRequestDispatcher(targetPage).forward(request, response);

    }
}
