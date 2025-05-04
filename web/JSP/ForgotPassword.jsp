<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="model.Login" %>
<jsp:useBean id="login" class="model.Login" scope="session" />
<jsp:setProperty name="login" property="email" param="email" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Forgot Password</title>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link href="../CSS/forgotPW.css?v=2" rel="stylesheet" type="text/css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <style>
            .avatar-container {
                position: relative;
                display: inline-block;
            }

            .dropdown-menu {
                display: none;
                position: absolute;
                top: 45px;
                left: -10px;
                z-index: 1000;
            }

            .avatar-container .dropdown-menu a {
                /* 这样写就只影响avatar那边的下拉menu */
                display: block;
                text-decoration: none;
                color: black;
                background-color: white;
                width: 180px;
                border: 1px solid #ccc;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            .avatar-container .dropdown-menu a:hover {
                background-color: #F9E075;
                color: black;
            }

            .avatar-container:hover .dropdown-menu {
                display: block;
            }
        </style>
    </head>
    <body>
        <!-- Header - Keeping as is -->
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

                <div class="avatar-container">
                    <i class="fa-regular fa-user" style="font-size:18px; cursor:pointer;"></i> 
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="/GlowyDaysProjectNew/JSP/AddNewUser.jsp">Register</a>
                        <a class="dropdown-item" href="/GlowyDaysProjectNew/JSP/Login.jsp">Log In</a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Main content with new styling -->
        <div class="forgot-container">
            <div class="forgot-card">
                <h1 class="forgot-title">Reset Password</h1>
                <p class="forgot-subtitle">Follow the steps below to reset your password</p>

                <div class="instructions">
                    <ol>
                        <li>Enter your email address below.</li>
                        <li>Our system will send you an OTP to your email.</li>
                        <li>Enter the OTP on the next page.</li>
                    </ol>
                </div>

                <form id="forgotForm" method="post" action="<%= request.getContextPath()%>/ForgotPassword" class="forgot-form">
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" placeholder="Enter your email" required>
                        <div id="emailValidation" class="validation-message"></div>
                    </div>

                    <div class="button-container">
                        <button type="button" class="back-btn" onclick="window.location.href = 'Login.jsp'">
                            <i class="fas fa-arrow-left"></i> Back to Login
                        </button>
                        <button type="submit" class="submit-btn">Submit</button>
                    </div>
                </form>
            </div>
        </div>

        <section class="footer">
            <div class="box-container">

                <div class="box">
                    <h3>Quick Links</h3>
                    <a href="/GlowyDaysProjectNew/TopProductServlet"><i class="fas fa-angle-right"></i> Home</a>
                    <a href="<%= request.getContextPath()%>/ProductServlet"><i class="fas fa-angle-right"></i> Product</a>
                    <a href="<%= request.getContextPath()%>/PromotionProductsServlet"><i class="fas fa-angle-right"></i> Promotion</a>
                    <a href="/GlowyDaysProjectNew/JSP/AboutUs.jsp"><i class="fas fa-angle-right"></i> About Us</a>
                </div>

                <div class="box">
                    <h3>Extra Links</h3>
                    <a href="#"><i class="fas fa-angle-right"></i> My Favorite</a>
                    <a href="#"><i class="fas fa-angle-right"></i> My Orders</a>
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

        <!-- Email validation script -->
        <script>
            $(document).ready(function () {
                $('#email').on('keyup', function () {
                    var email = $(this).val().trim();
                    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                    if (email.length > 0) {
                        if (!emailRegex.test(email)) {
                            $('#emailValidation').html('<span style="color:red; font-size:13px;">Invalid email format! Please enter a valid email address.</span>');
                            $('button[type="submit"]').prop('disabled', true);
                        } else {
                            $.ajax({
                                type: 'POST',
                                url: '/GlowyDaysProjectNew/LoginEmail',
                                data: {email: email},
                                success: function (response) {
                                    if (response.trim() === "Not registered") {
                                        $('#emailValidation').html('<span style="color:red; font-size:13px;">This email is not registered. Please sign up first.</span>');
                                        $('button[type="submit"]').prop('disabled', true);
                                    } else {
                                        $('#emailValidation').html('');
                                        $('button[type="submit"]').prop('disabled', false);
                                    }
                                },
                                error: function () {
                                    $('#emailValidation').html('<span style="color:red;">Error checking email.</span>');
                                    $('button[type="submit"]').prop('disabled', true);
                                }
                            });
                        }
                    } else {
                        $('#emailValidation').html('');
                        $('button[type="submit"]').prop('disabled', true);
                    }
                });
            });
        </script>
        <script src="../JavaScript/main.js"></script>
    </body>
</html>