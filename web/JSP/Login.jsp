<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="model.Login" %>
<jsp:useBean id="login" class="model.Login" scope="session" />
<jsp:setProperty name="login" property="email" param="email" />
<jsp:setProperty name="login" property="password" param="password" />

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <link href="../CSS/login.css?v=3" rel="stylesheet" type="text/css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <!-- Header - Keeping as is -->
    <section id="header" class="header">
            <a href="GuestHome.jsp"><h2 style="font-weight: bolder; font-size: 3rem; color: black;">GLOWY DAYS</h2></a>
            <div class="navbar">
                <a href="GuestHome.jsp">Home</a>
                <a href="<%= request.getContextPath()%>/ProductServlet">Product</a>
                <a href="<%= request.getContextPath()%>/PromotionProductsServlet">Promotion</a>              
                <a href="AboutUs.jsp">About Us</a>                           
            </div>
            <div class="icons">
                <div class="search-wrapper">
                    <i class="fa-solid fa-magnifying-glass" id="search-icon"></i>
                    <input type="text" id="search-box" placeholder="Search..." />
                </div>
                    
                <div class="avatar-container">
                    <i class="fa-regular fa-user" style="font-size:18px; cursor:pointer;"></i> 
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="AddNewUser.jsp">Register</a>
                        <a class="dropdown-item" href="Login.jsp">Log In</a>
                    </div>
                </div>
            </div>
        </section>
    
    <!-- Main content with new styling -->
    <div class="login-container">
        <div class="login-card">
            <h1 class="login-title">Log in</h1>
            <p class="login-subtitle">Please fill in the fields below</p>
            
            <form action="/UserLogin"id="loginForm" method="post" class="login-form">
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                    <div id="emailValidation" class="validation-message"></div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" 
                           pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" required>
                    <div id="passwordValidation" class="validation-message"></div> 
                </div>
                
                <div class="forgot-password">
                    <a href="../JSP/ForgotPassword.jsp">Forgot Password?</a>
                </div>
                
                <div class="button-container">
                    <button type="submit" class="login-btn">Login</button>
                </div>
                
                <div class="register-link">
                    <p>Not yet have an account? <a href="AddNewUser.jsp">Register Now</a></p>
                </div>
            </form>
        </div>
    </div>

    <section class="footer">
            <div class="box-container">

                <div class="box">
                    <h3>Quick Links</h3>
                    <a href="GuestHome.jsp"><i class="fas fa-angle-right"></i> Home</a>
                    <a href="<%= request.getContextPath()%>/ProductServlet"><i class="fas fa-angle-right"></i> Product</a>
                    <a href="<%= request.getContextPath()%>/PromotionProductsServlet"><i class="fas fa-angle-right"></i> Promotion</a>
                    <a href="AboutUs.jsp"><i class="fas fa-angle-right"></i> About Us</a>
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

    <!-- Email validation script - Keeping as is -->
    <script>
        $(document).ready(function(){
            $('#email').on('keyup', function(){
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
                            data: { email: email },
                            success: function(response){
                                if (response.trim() === "Not registered") {
                                    $('#emailValidation').html('<span style="color:red; font-size:13px;">This email is not registered. Please sign up first.</span>');
                                    $('button[type="submit"]').prop('disabled', true);
                                } else {
                                    $('#emailValidation').html(''); 
                                    $('button[type="submit"]').prop('disabled', false);
                                }
                            },
                            error: function(){
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
    
    <!-- Password validation script - Keeping as is -->
    <script>
        $(document).ready(function () {
            $('#loginForm').on('submit', function (e) {
                e.preventDefault();  // 阻止默认提交行为

                var email = $('#email').val().trim();
                var password = $('#password').val().trim();
                var isValid = true;

                // 清空之前的验证错误
                $('#emailValidation').html('');
                $('#passwordValidation').html('');

                // 简单的前端验证
                if (password.length === 0) {
                    $('#passwordValidation').html('<span style="color:red; font-size:13px;">Password is required.</span>');
                    isValid = false;
                }

                if (!isValid) return;

                // 使用 AJAX 向后端验证密码
                $.ajax({
                    type: 'POST',
                    url: '/GlowyDaysProjectNew/LoginPassword',  // 修改为实际的Servlet路径
                    data: { email: email, password: password },
                    success: function (response) {
                        console.log("Response from backend: ", response);  // 输出后端返回的数据

                        if (response.trim() === "Not login") {
                            $('#passwordValidation').html('<span style="color:red; font-size:13px;">Invalid password! Please try again!</span>');
                            $('#password').val('');
                        } else {
                            // 打印角色，检查返回的角色
                            console.log("Role received: ", response.trim());

                            var role = response.trim();  // 假设后端返回的是角色信息

                            switch (role) {
                                case "manager":
                                    window.location.href = "/GlowyDaysProjectNew/DashboardServlet";  // 重定向到管理员面板
                                    break;
                                case "staff":
                                    window.location.href = "/GlowyDaysProjectNew/DashboardServlet";  // 重定向到员工面板
                                    break;
                                case "customer":
                                    window.location.href = "UserHome.jsp";  // 重定向到用户主页
                                    break;
                                default:
                                    alert("Unknown role: " + role);
                            }
                        }
                    },
                    error: function () {
                        $('#passwordValidation').html('<span style="color:red;">Server error. Please try again later.</span>');
                    }
                });
            });
        });
    </script>
    <script src="../JavaScript/main.js"></script>
</body>
</html>