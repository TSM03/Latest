/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;

/**
 *
 * @author tsm11
 */
@WebServlet("/StaffListServlet")
public class StaffListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/GlowyDaysDB", "nbuser", "nbuser");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT USER_ID, NAME, BIRTH, EMAIL, MOBILENO FROM USERS WHERE ROLE = 'STAFF'");

            out.println("<h2>Staff Listing</h2>");
            out.println("<table border='1'>");
            out.println("<tr><th>User ID</th><th>Name</th><th>Birthdate</th><th>Email</th><th>Mobile</th></tr>");

            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getString("USER_ID") + "</td>");
                out.println("<td>" + rs.getString("NAME") + "</td>");
                out.println("<td>" + rs.getDate("BIRTH").toLocalDate() + "</td>");
                out.println("<td>" + rs.getString("EMAIL") + "</td>");
                out.println("<td>" + rs.getString("MOBILENO") + "</td>");
                out.println("</tr>");
            }

            out.println("</table>");
            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
}
