<%-- 
    Document   : AdminPanel
    Created on : Apr 16, 2025, 11:39:02 PM
    Author     : tsm11
--%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="model.DashboardStats"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String id = request.getParameter("userId");
    String driverName = "org.apache.derby.jdbc.ClientDriver";
    String connectionUrl = "jdbc:derby://localhost:1527/";
    String dbName = "GlowyDayDB";
    String userId = "nbuser";
    String password = "nbuser";

    try {
        Class.forName(driverName);
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    }

    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;
%>

<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Master Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/GlowyDaysProjectNew/CSS/AdminPanel.css?v=2">
    <link rel="stylesheet" href="/GlowyDaysProjectNew/CSS/DashboardCSS.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>Master Admin</h2>
            <i class="fas fa-bars"></i>
        </div>
        <div class="sidebar-menu">
            <div class="menu-item active">
                <div class="menu-left">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </div>
            </div>
            <div class="menu-item customer-toggle">
                <div class="menu-left">
                    <i class="fa-regular fa-user"></i>
                    <span>Customer Management</span>              
                </div>             
                <i class="fas fa-chevron-right menu-arrow"></i>
            </div>

            <!-- Dropdown Submenu for Customer -->
            <div class="submenu" style="display: none;">
                <div class="submenu-item">
                    <a href="/GlowyDaysProjectNew/JSP/AddNewUser.jsp">Create Customer</a>
                </div>
                <div class="submenu-item">
                    <a href="#" onclick="loadCustomerList()">Customer Listing</a>
                </div>
            </div>

            <div class="menu-item product-toggle">
                <div class="menu-left">
                    <i class="fa-solid fa-boxes-stacked"></i>
                    <span>Product Management</span>
                </div>
                <i class="fas fa-chevron-right menu-arrow"></i>
            </div>

            <!-- Dropdown Submenu -->
            <div class="submenu" style="display: none;">
                <div class="submenu-item">
                    <a href="/GlowyDaysProjectNew/JSP/AddProduct.jsp"> Add Product </a>
                </div>
                <div class="submenu-item">
                    <a href="#" onclick="loadProductList()"> Product Listing</a>
                </div>
            </div>

            <div class="menu-item">
                <div class="menu-left">
                    <i class="fa-solid fa-box"></i>
                    <span><a  style="color: #fff; text-decoration: none;" href="/GlowyDaysProjectNew/OrderServlett" "> Order Management</a></span>                
                </div>
            </div>

            <div class="menu-item">
                <div class="menu-left">
                    <i class="fas fa-file"></i>
                    <span><a  style="color: #fff; text-decoration: none;" href="#" onclick="loadReport()"> Report Generation</a></span>  
                </div>
            </div>
            <div class="menu-item">
                <div class="menu-left">
                    <i class="fa-regular fa-user"></i>
                    <a style="color: #fff; text-decoration: none;" href="<%= request.getContextPath()%>/LogoutServlet">Log Out</a>
                </div>
            </div>            
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div id="dynamicContent">
            <div class="top-bar">
                <div class="breadcrumb">
                    <a href="#"><i class="fas fa-home"></i> Home</a>
                    <span>/</span>
                    <a href="#">Dashboard</a>
                </div>
            </div>

            <div class="dashboard-content">
                <div class="dashboard-header">
                    <h1>Dashboard</h1>
                    <p>Control panel</p>
                </div>

                <div class="stats-grid">               
                    <%
                        DashboardStats stats = (DashboardStats) request.getAttribute("stats");
                        if (stats == null) {
                            out.println("<p style='color:red;'>Error: Dashboard statistics could not be loaded.</p>");
                            return;
                        }
                    %>
                    
                    <div class="start-card">
                        <div class="stat-card-header blue">
                            <h2 class="number"><%= stats.getTotalOrders()%></h2>
                            <div class="label"><p class="label">Total Orders</p></div>
                        </div>
                    </div>

                    <div class="start-card">
                        <div class="stat-card-header orange">
                            <h2 class="number"><%= stats.getTotalCustomers()%></h2>
                            <div class="label"><p class="label">Total Users</p></div>
                        </div>
                    </div>

                    <div class="start-card">
                        <div class="stat-card-header red">
                            <h2 class="number"><%= stats.getTotalItemsSold()%></h2>
                            <div class="label"><p class="label">Total Items Sold</p></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        document.addEventListener("DOMContentLoaded", function () {

            const customerToggle = document.querySelector(".customer-toggle");
            const customerSubmenu = customerToggle.nextElementSibling; // the next .submenu after customer-toggle
            const customerArrow = customerToggle.querySelector(".menu-arrow");

            customerToggle.addEventListener("click", function () {
                customerSubmenu.style.display = customerSubmenu.style.display === "none" ? "block" : "none";
                customerArrow.classList.toggle("rotate");
            });

            // New: Product Toggle
            const productToggle = document.querySelector(".product-toggle");
            const productSubmenu = productToggle.nextElementSibling; // the next .submenu after product-toggle
            const productArrow = productToggle.querySelector(".menu-arrow");

            productToggle.addEventListener("click", function () {
                productSubmenu.style.display = productSubmenu.style.display === "none" ? "block" : "none";
                productArrow.classList.toggle("rotate");
            });

        });

        function loadCustomerList() {
            fetch('/GlowyDaysProjectNew/JSP/CustomerManagement.jsp')
                    .then(response => response.text())
                    .then(data => {
                        document.querySelector('.dashboard-content').innerHTML = data;
                    })
                    .catch(error => {
                        console.error('Error loading customer list:', error);
                    });
        }

        // Function to load product list
        function loadProductList() {
            fetch('/GlowyDaysProjectNew/JSP/ProductList.jsp')
                    .then(response => response.text())
                    .then(data => {
                        document.querySelector('.dashboard-content').innerHTML = data;
                    })
                    .catch(error => {
                        console.error('Error loading product list:', error);
                    });
        }


        // Function to load Order Details
        function loadReport() {
            fetch('/GlowyDaysProjectNew/ReportGenServlet')
                    .then(response => response.text())
                    .then(data => {
                        document.querySelector('.dashboard-content').innerHTML = data;
                    })
                    .catch(error => {
                        console.error('Error loading product list:', error);
                    });
        }
    </script>
</body>

<script link="../Javascript/Panel.js"></script>
</html>