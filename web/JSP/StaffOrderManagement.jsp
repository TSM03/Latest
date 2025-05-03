<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Order" %>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="model.DashboardStats"%>


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

    <style>
        /* Additional CSS styles can be added here */
        .order-table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        .order-table th, .order-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        .order-table th {
            background-color: #f2f2f2;
        }
        .order-table .green-button {
            background-color: green;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
        }
        .order-table .green-button[disabled] {
            background-color: grey;
            cursor: not-allowed;
        }

        .modal {
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }

        .modal-content {
            background-color: #fff;
            margin: 10% auto;
            padding: 20px;
            border-radius: 8px;
            width: 300px;
            position: relative;
        }

        .close {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 20px;
            font-weight: bold;
            cursor: pointer;
        }

        .order-table th i.fas {
            margin-left: 5px;
            font-size: 12px;
            color: #999;
            cursor: pointer;
        }

        .order-table .green-button i {
            pointer-events: none; /* icon doesn't interfere with click */
        }

        .order-table .green-button {
            margin: 2px 0;
        }
    </style>

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
                    <span><a  style="color: #fff; text-decoration: none;" href="#"> Order Management</a></span>                
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
                    <h1>Orders</h1>
                    <p>Orders</p>
                </div>    

                <div class="order-table-div">

                    <div style="margin-bottom: 10px;">
                        <input 
                            type="text" 
                            id="searchOrderId" 
                            placeholder="Search by Order ID" 
                            onkeyup="filterTable()" 
                            style="padding: 8px; width: 250px; border-radius: 5px; border: 1px solid #ccc;">
                    </div>

                    <table class="order-table">
                        <thead>
                            <tr>
                                <th onclick="sortTable(0)">No <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable(1)">Order ID <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable(2)">Order Date <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable(3)">Shipped <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable(4)">Tracking No <i class="fas fa-sort"></i></th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>

                            <%
                                List<Order> orders = (List<Order>) request.getAttribute("orderList");

                                if (orders != null && !orders.isEmpty()) {
                                    int count = 1;
                                    for (Order o : orders) {
                            %>
                            <tr>
                                <td><%= count++%></td>
                                <td><%= o.getOrderId()%></td>
                                <td><%= o.getOrderDate()%></td>
                                <td><%= o.isShipped() ? "Yes" : "No"%></td>
                                <td><%= o.getTrackingNo() != null ? o.getTrackingNo() : "-"%></td>
                                <td>
                                    <button 
                                        class="green-button" 
                                        type="button"
                                        onclick="openModal('<%= o.getOrderId()%>')"
                                        <%= o.getTrackingNo() != null ? "disabled" : ""%>>
                                        Add Tracking No
                                    </button>
                                    <button 
                                        class="green-button" 
                                        type="button"
                                        onclick="location.href = '/GlowyDaysProjectNew/OrderDetailsServlet?orderId=<%= o.getOrderId()%>'"
                                        title="View Order Details">
                                        <i class="fas fa-eye"></i>
                                    </button>

                                    <!-- 
                                    <form method="post" action="DeleteOrderServlet" style="display:inline;" onsubmit="return confirmDelete('<%= o.getOrderId()%>');">
                                        <input type="hidden" name="orderId" value="<%= o.getOrderId()%>">
                                        <button 
                                            class="green-button" 
                                            type="submit"
                                            title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                    -->
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr><td colspan="6">No orders found.</td></tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>

        <div id="trackingModal" class="modal" style="display:none;">
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2>Add Tracking Number</h2>
                <p>Order ID: <span id="displayOrderId" style="font-weight: bold;"></span></p>

                <% String error = (String) request.getAttribute("error"); %>
                <% if (error != null) {%>
                <p style="color: red; font-weight: bold; text-align: center;"><%= error%></p>
                <% }%>

                <form id="trackingForm" method="post" action="AddTrackingServlet">
                    <input type="hidden" name="orderId" id="modalOrderId">
                    <input type="text" name="trackingNo" placeholder="Enter Tracking No" required>
                    <button type="submit" class="green-button">Submit</button>
                </form>
            </div>
        </div>

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
</body>
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
</html>