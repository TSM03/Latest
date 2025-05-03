<%@ page import="model.CartItem" %>
<%@ page import="model.Product" %>
<%@ page import="model.CheckoutDetail" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<%@ page import="model.ShippingDetail" %>
<%@ page import="model.PaymentMethod" %>
<%@ page import="dao.*" %> 
<%@ page import="model.Address" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Payment Shipping Form</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../CSS/Checkout.css" rel="stylesheet" type="text/css">
    </head>
    <body>

        <h1>Review Your Order</h1>

        <h2>Purchased Items:</h2>

        <%
            List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
            CheckoutDetail checkoutDetail = (CheckoutDetail) session.getAttribute("checkoutDetail");

            if (cartItems != null && !cartItems.isEmpty()) {
        %>
        <table>
            <thead>
                <tr>
                    <th>Product Image</th>
                    <th>Product Name</th>
                    <th>Price (each)</th>
                    <th>Quantity</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (CartItem item : cartItems) {
                        Product p = item.getProduct();
                %>
                <tr>
                    <td><img src="<%= p.getImageUrl()%>" alt="Product Image" style="width: 80px; height: 80px;"></td>
                    <td><%= p.getName()%></td>
                    <td>RM<%= String.format("%.2f", p.getPrice())%></td>
                    <td><%= item.getQuantity()%></td>
                    <td>RM<%= String.format("%.2f", p.getPrice() * item.getQuantity())%></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
        } else {
        %>
        <p>No items found in your cart.</p>
        <%
            }
        %>

        <%
            List<ShippingDetail> shippingList = (List<ShippingDetail>) session.getAttribute("shippingList");

            PaymentMethod payment = (PaymentMethod) session.getAttribute("paymentMethods");
        %>



        <!-- Shipping List -->

        <%
            // Get the ShippingDetail object from the session
            ShippingDetail shippingDetail = (ShippingDetail) session.getAttribute("shippingDetail");

            if (shippingDetail != null) {
        %>

        <!-- Display Shipping Information -->
        <h3>Shipping Information</h3>
        <table>
            <tr style="background-color: #F9E075;"">
                <th>Buyer Name</th>
                <th>Address</th>
            </tr>
            <tr>
                <td><%= shippingDetail.getBuyer().getFullName()%></td>
                <td>
                    <%= shippingDetail.getAddress().getAddressId()%>, 
                    <%= shippingDetail.getAddress().getCity()%>, 
                    <%= shippingDetail.getAddress().getState()%>, 
                    <%= shippingDetail.getAddress().getPostcode()%>
                </td>       
            </tr>
        </table>

        <%
            } else {
                out.println("<p>No shipping information available.</p>");
            }
        %>
    </table>

    <!-- Payment Methods List -->
    <h3>Payment Methods</h3>
    <table>
        <tr style="background-color: #F9E075;">
            <th>Method</th>
            <th>Card Owner</th>
        </tr>
        <%
            if (payment != null) {
        %>
        <tr>
            <td><%= payment.getMethodName()%></td>
            <td><%= payment.getCardOwner()%></td>
        </tr>
        <%
            }
        %>
    </table>



    <!--<div class="summary">
        <h2>Payment Summary:</h2>
        <div>Subtotal: RM<%= checkoutDetail != null ? checkoutDetail.getSubtotal() : "0.00"%></div>
        <div>Tax Amount: RM<%= checkoutDetail != null ? checkoutDetail.getTaxAmount() : "0.00"%></div>
        <div>Delivery Fee: RM<%= checkoutDetail != null ? checkoutDetail.getDeliveryFee() : "0.00"%></div>
        <div><strong>Total Amount: RM<%= checkoutDetail != null ? checkoutDetail.getTotalAmount() : "0.00"%></strong></div>
    </div>-->

    <div class="summary">
        <h2>Payment Summary:</h2>
        <div>Subtotal: RM<%= session.getAttribute("subtotal") != null ? session.getAttribute("subtotal") : "0.00"%></div>
        <div>Tax Amount: RM<%= session.getAttribute("taxAmount") != null ? session.getAttribute("taxAmount") : "0.00"%></div>
        <div>Delivery Fee: RM<%= session.getAttribute("deliveryFee") != null ? session.getAttribute("deliveryFee") : "0.00"%></div>
        <div><strong>Total Amount: RM<%= session.getAttribute("totalAmount") != null ? session.getAttribute("totalAmount") : "0.00"%></strong></div>
    </div>

    <form action="../ConfirmOrderServlet" method="POST">
        <button type="submit" class="submitBtn">Pay Now</button>
    </form>

</body>
</html>
