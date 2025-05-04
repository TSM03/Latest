<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.TopProduct" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Home</title>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/CSS/home.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="stylesheet" href="/GlowyDaysProjectNew/CSS/TopProductCSS.css">
    </head>
    <body>              
        <section id="header" class="header">
            <a href="/GlowyDaysProjectNew/TopProductServlet"><h2 style="font-weight: bolder; font-size: 3rem; color: black;">GLOWY DAYS</h2></a>
            <div class="navbar">
                <a href="/GlowyDaysProjectNew/TopProductServlet">Home</a>
                <a href="<%= request.getContextPath()%>/ProductServlet">Product</a>
                <a href="<%= request.getContextPath()%>/PromotionProductsServlet">Promotion</a>              
                <a href="/GlowyDaysProjectNew/JSP/AboutUs.jsp">About Us</a>                           
            </div>
            <div class="icons">
                <div class="search-wrapper">
                    <i class="fa-solid fa-magnifying-glass" id="search-icon"></i>
                    <input type="text" id="search-box" placeholder="Search..." />
                </div>
                <a href="<%= request.getContextPath()%>/LoadCartServlet" class="fa-solid fa-cart-shopping"></a>    
                <div class="avatar-container">
                    <i class="fa-regular fa-user" style="font-size:18px; cursor:pointer;"></i> 
                    <div class="dropdown-menu">
                        <%
                            Long userID = (Long) session.getAttribute("userID");
                            String username = (String) session.getAttribute("username");
                        %>
                        <a style="pointer-events: none;"><%= username%></a>
                        <a class="dropdown-item" href="<%= request.getContextPath()%>/UserProfile.jsp">User Profile</a>
                        <a class="dropdown-item" href="/GlowyDaysProjectNew/ViewUserOrderServlet">User Order</a>
                        <a class="dropdown-item" href="<%= request.getContextPath()%>/LogoutServlet">Log Out</a>
                    </div>
                </div>
            </div>
        </section>

        <section class="home" id="home">
            <div class="slide active" style="background:url(/GlowyDaysProjectNew/Slides/Slide_1.png); background-size: cover; background-position: center;">
                <div class="content">
                    <span>Glow Naturally</span>
                    <h3>Experience skincare that celebrates your natural beauty, enhancing your glow from within with nourishing, organic ingredients.</h3>
                    <a href="<%= request.getContextPath()%>/ProductServlet" class="btn">Read More</a>
                </div>    
            </div>

            <div class="slide" style="background:url(/GlowyDaysProjectNew/Slides/Slide_2.png); background-size: cover; background-position: center;">
                <div class="content">
                    <span>Revitalize Your Skin</span>
                    <h3>Transform your daily routine into a rejuvenating ritual with our advanced formulas that repair, hydrate, and protect.</h3>
                    <a href="<%= request.getContextPath()%>/ProductServlet" class="btn">Read More</a>
                </div>    
            </div>

            <div class="slide" style="background:url(/GlowyDaysProjectNew/Slides/Slide_11.png); background-size: cover; background-position: center;">
                <div class="content">
                    <span>Embrace Your Beauty</span>
                    <h3>Unlock the power of self-care with products that empower you to feel confident, radiant, and beautifully yourself every day.</h3>
                    <a href="<%= request.getContextPath()%>/ProductServlet" class="btn">Read More</a>
                </div>    
            </div>

            <div id="next-slide" onclick="next()" class="fas fa-angle-right"></div>
            <div id="prev-slide" onclick="prev()" class="fas fa-angle-left"></div>
        </section>


        <section class="category">
            <div class="box-container">

                <a href="#" class="box">
                    <img src="/GlowyDaysProjectNew/Category/Category_moisturizer.png">
                    <h3>Moisturizer</h3>
                </a>

                <a href="#" class="box">
                    <img class="img" src="/GlowyDaysProjectNew/Category/Category_eyecream.png">
                    <h3>Eye Cream</h3>
                </a>

                <a href="#" class="box">
                    <img class="img" src="/GlowyDaysProjectNew/Category/Category_sunscreen.png">
                    <h3>Sun Screen</h3>
                </a>

                <a href="#" class="box">
                    <img class="img" src="/GlowyDaysProjectNew/Category/Category_cleanser.png">
                    <h3>Cleanser</h3>
                </a>

                <a href="#" class="box">
                    <img class="img" src="/GlowyDaysProjectNew/Category/Category_ExfoliatingToner.png">
                    <h3>Exfoliating Toner</h3>
                </a>

                <a href="#" class="box">
                    <img class="img" src="/GlowyDaysProjectNew/Category/Category_Retinol.png">
                    <h3>Retinol</h3>
                </a>                
            </div>
        </section>

        <section class="featured-section">
            <div class="products-container">
                <h2 class="section-heading">Top Selling Products</h2>
                <div class="products-grid">
                    <%
                        List<model.TopProduct> topProducts = (List<model.TopProduct>) request.getAttribute("topProducts");
                        if (topProducts != null) {
                            for (model.TopProduct product : topProducts) {
                    %>
                    <div class="card">
                        <img src="<%= product.getImageUrl()%>?height=300&width=400" alt="Product Image" class="card__image">
                        <div class="card__content">
                            <h2 class="card__title"><%= product.getProductName()%></h2>
                            <p class="card__description"><%= product.getDescription()%></p>
                            <button class="card__button">View Details</button>
                        </div>
                    </div>
                    <%
                        }
                    } else {
                    %>
                    <p class="no-products">No top products available.</p>
                    <%
                        }
                    %>
                </div>
            </div>
        </section>


        <section class="services">

            <div class="box">
                <i class="fa-solid fa-truck-fast"></i>
                <h3>Free Delivery</h3>
                <p>Purchase over RM1000 you can enjoy fast and free nationwide shipping on all <br>orders with no minimum purchase required.</p>
            </div>

            <div class="box">
                <i class="fa-solid fa-user-shield"></i>
                <h3>Secure Payment</h3>
                <p>Your transactions are encrypted and protected. We offer multiple trusted <br> payment options to keep your information safe.</p>
            </div>

            <div class="box">
                <i class="fa-solid fa-business-time"></i>
                <h3>24/7 Support</h3>
                <p>Need help? Our friendly customer support team is available around the clock <br> to assist you with any questions or issues.</p>
            </div>

        </section>

        <section class="footer">
            <div class="box-container">

                <div class="box">
                    <h3>Quick Links</h3>
                    <a href="/GlowyDaysProjectNew/TopProductServlet"><i class="fas fa-angle-right"></i> Home</a>
                    <a href="<%= request.getContextPath()%>/ProductServlet"><i class="fas fa-angle-right"></i> Product</a>
                    <a href="<%= request.getContextPath()%>/PromotionProductsServlet"><i class="fas fa-angle-right"></i> Promotion</a>
                    <a href="<%= request.getContextPath()%>/AboutUs.jsp"><i class="fas fa-angle-right"></i> About Us</a>
                </div>

                <div class="box">
                    <h3>Extra Links</h3>
                    <a href="#"><i class="fas fa-angle-right"></i> My Favorite</a>
                    <a href="<%= request.getContextPath()%>/LoadCartServlet"><i class="fas fa-angle-right"></i> My Orders</a>
                    <a href="#"><i class="fas fa-angle-right"></i> Wishlist</a>
                    <a href="#"><i class="fas fa-angle-right"></i> Terms of Use</a>
                </div>

                <div class="box">
                    <h3>Contact Info</h3>
                    <a href="#"><i class="fas fa-phone"></i> +6018-9064828</a>
                    <a href="#"><i class="fas fa-phone"></i> +6012-3456789</a>
                    <a href="mailto:glowydays05@gmail.com"><i class="fas fa-envelope"></i> glowydays05@gmail.com</a>
                    <a href="#"><i class="fas fa-map-marker-alt"></i> Kuala Lumpur, Malaysia</a>

                    <div class="share">
                        <a href="https://www.facebook.com/" class="fab fa-facebook-f"></a>
                        <a href="https://www.instagram.com/" class="fab fa-instagram"></a>
                        <a href="https://x.com/" class="fab fa-twitter"></a>
                    </div>
                </div>

                <div class="box">
                    <h3>Newsletter</h3>
                    <p>Subscribe for Latest Updates</p>
                    <form action="">
                        <input type="email" placeholder="Enter your email" class="email">
                        <input type="submit" value="Subscribe" class="btn">
                    </form>
                </div>

            </div>
        </section>

        <script src="/GlowyDaysProjectNew/Javascript/main.js"></script>
    </body>
</html>