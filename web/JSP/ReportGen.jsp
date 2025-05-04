<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.ReportGen"%>
<%@ page import="jakarta.servlet.*" %>
<%@page import="java.util.List" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Sales Report</title>
        <link rel="stylesheet" href="../CSS/ReportGenCSS.css?v=5"/>
        <link rel="stylesheet" href="CSS/ReportGenCSS.css?v=5"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>
        <div class="report-container">
            <h1>Product Sales Report</h1>

            <form method="get" action="/GlowyDaysProjectNew/ReportGenServlet">
                <div class="form-group">
                    <label for="filterType">Filter By:</label>
                    <select name="filterType" id="filterType">
                        <option value="all">All</option>
                        <option value="daily">Daily</option>
                        <option value="monthly">Monthly</option>
                        <option value="yearly">Yearly</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="filterDate">Date:</label>
                    <input type="date" name="filterDate" id="filterDate">
                </div>

                <button type="submit"><i class="fas fa-search"></i> Generate Report</button>
            </form>
            
            <%
                List<ReportGen> reportList = (List<ReportGen>) request.getAttribute("reportList");
            %>

            <% if (reportList != null && !reportList.isEmpty()) { %>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Photo</th>
                            <th>Item Name</th>
                            <th>Quantity Sold</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int no = 1;
                            for (ReportGen item : reportList) {
                        %>
                        <tr>
                            <td><%= no++%></td>
                            <td><img src="<%= item.getImageUrl()%>" alt="<%= item.getProductName()%>" loading="lazy"></td>
                            <td><%= item.getProductName()%></td>
                            <td><span class="quantity-badge"><%= item.getQuantitySold()%></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="empty-state">
                <i class="fas fa-chart-bar"></i>
                <p>No data available or failed to load the report.</p>
                <p class="hint">Try adjusting your filter criteria.</p>
            </div>
            <% }%>
        </div>
    </body>
</html>