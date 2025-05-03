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
    String dbName = "GlowyDaysDB";
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

            <!-- Staff Management Section -->
            <div class="menu-item staff-toggle">
                <div class="menu-left">
                    <i class="fa-regular fa-user"></i>
                    <span>Staff Management</span>
                </div>
                <i class="fas fa-chevron-right menu-arrow"></i>
            </div>

            <!-- Dropdown Submenu -->
            <div class="submenu staff-submenu" style="display: none;">
                <div class="submenu-item">
                    <a href="/GlowyDaysProjectNew/JSP/StaffCreation.jsp"> Create Staff</a>
                </div>
                <div class="submenu-item">
                    <a href="#" onclick="loadStaffList()"> Staff Listing</a>
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
                    <span><a  style="color: #fff; text-decoration: none;" href="/GlowyDaysProjectNew/OrderServlett"> Order Management</a></span>                
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

                <%
                    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
                    if (stats == null) {
                            out.println("<p style='color:red;'>Error: Dashboard statistics could not be loaded.</p>");
                            return;
                        }
                %>

                <div class="stats-grid">               

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
            const staffToggle = document.querySelector(".staff-toggle");
            const staffSubmenu = staffToggle.nextElementSibling; // the next .submenu after staff-toggle
            const staffArrow = staffToggle.querySelector(".menu-arrow");

            staffToggle.addEventListener("click", function () {
                staffSubmenu.style.display = staffSubmenu.style.display === "none" ? "block" : "none";
                staffArrow.classList.toggle("rotate");
            });

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
        
        function loadStaffList() {
            fetch('/GlowyDaysProjectNew/JSP/StaffList.jsp')
                    .then(response => response.text())
                    .then(data => {
                        document.querySelector('.dashboard-content').innerHTML = data;
                    })
                    .catch(error => {
                        console.error('Error loading staff list:', error);
                    });
        }

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

        
                
        // Function to load Report 
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
    <script>
            function openModal(orderId) {
                document.getElementById("trackingModal").style.display = "block";
                document.getElementById("modalOrderId").value = orderId;
                document.getElementById("displayOrderId").textContent = orderId;
            }

            document.querySelector(".close").onclick = function () {
                document.getElementById("trackingModal").style.display = "none";
            }

            window.onclick = function (event) {

                const modal = document.getElementById("trackingModal");
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }

            let sortDirection = {}; // Keep track of each column's sort direction

            function sortTable(columnIndex) {
                const table = document.querySelector(".order-table");
                const tbody = table.querySelector("tbody");
                const rows = Array.from(tbody.querySelectorAll("tr"));

                // Default to ascending if it's never been sorted
                const isAsc = sortDirection[columnIndex] = sortDirection[columnIndex] === undefined ? true : !sortDirection[columnIndex];

                rows.sort((a, b) => {
                    const cellA = a.children[columnIndex].textContent.trim();
                    const cellB = b.children[columnIndex].textContent.trim();

                    const valA = isNaN(cellA) ? (Date.parse(cellA) ? new Date(cellA) : cellA.toLowerCase()) : Number(cellA);
                    const valB = isNaN(cellB) ? (Date.parse(cellB) ? new Date(cellB) : cellB.toLowerCase()) : Number(cellB);

                    if (valA < valB)
                        return isAsc ? -1 : 1;
                    if (valA > valB)
                        return isAsc ? 1 : -1;
                    return 0;
                });

                tbody.innerHTML = "";
                rows.forEach(row => tbody.appendChild(row));
            }

            function confirmDelete(orderId) {
                return confirm("Are you sure you want to delete Order ID: " + orderId + "?");
            }

            function filterTable() {
                const input = document.getElementById("searchOrderId");
                const filter = input.value.trim().toLowerCase();
                const table = document.querySelector(".order-table");
                const rows = table.querySelectorAll("tbody tr");

                rows.forEach(row => {
                    const orderIdCell = row.children[1]; // Order ID is the second column (index 1)
                    const orderIdText = orderIdCell.textContent.trim().toLowerCase();
                    row.style.display = orderIdText.includes(filter) ? "" : "none";
                });
            }

        </script>
<script link="../Javascript/Panel.js"></script>
</html>