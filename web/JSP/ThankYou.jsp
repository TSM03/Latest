<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.ShippingDetail" %>
<%@page import="model.BuyerDetail" %>
<%@page import="model.Address" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thank You for Your Order</title>
    <link href="../CSS/thankyou.css" rel="stylesheet" type="text/css">
</head>
<body>
    <div class="tq-container">
        <div class="thank-you-box">
            <h1 class="title">THANK YOU FOR YOUR ORDER</h1>
            <p class="conclusion-text">We've received your order and are processing it...</p>       
            <p>Estimated Delivery: 5-7 business days</p>
            
            <div class="backHomeButton">
                <a href="UserHome.jsp" class="home-link">Return to Home</a>
            </div>
        </div>
    </div>
</body>
</html>