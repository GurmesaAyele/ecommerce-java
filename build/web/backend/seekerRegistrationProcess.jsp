
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.classes.DBConnector"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.classes.MD5"%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String firstname = request.getParameter("firstname");
            String lastName = request.getParameter("lastname");
            String email = request.getParameter("email");
            String username = request.getParameter("username");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String password = request.getParameter("password");
            
            response.setContentType("text/html;charset=UTF-8");

            // Validate input parameters
            if (firstname == null || firstname.isEmpty()) {
                response.sendRedirect("../userRegisterForm.jsp?error=1");
                return;
            }

            if (lastName == null || lastName.isEmpty()) {
                response.sendRedirect("../userRegisterForm.jsp?error=1");
                return;
            }

            if (email == null || !email.matches("[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")) {
                response.sendRedirect("../userRegisterForm.jsp?error=1");
                return;
            }

            if (username == null || username.isEmpty()) {
                response.sendRedirect("../userRegisterForm.jsp?error=1");
                return;
            }
            
            if (phone == null || phone.isEmpty()) {
                response.sendRedirect("../userRegisterForm.jsp?error=1");
                return;
            }
            
            if (address == null || address.isEmpty()) {
                response.sendRedirect("../userRegisterForm.jsp?error=1");
                return;
            }
            
            if (password == null || password.isEmpty()) {
                response.sendRedirect("../userRegisterForm.jsp?error=1");
                return;
            }

            try {
                // Hash the password
                String HashedPassword = MD5.getMd5(password);
                String PicturePath = "./images/uploads/profilePictures/default.jpg";
                String cv = "./images/uploads/cvs/default.pdf";

                // Get database connection
                Connection connection = DBConnector.getCon();
                
                if (connection == null) {
                    out.println("<h3>Database connection failed!</h3>");
                    out.println("<p>Please check if WAMP server is running and database credentials are correct.</p>");
                    out.println("<a href='../userRegisterForm.jsp'>Go Back</a>");
                    return;
                }
                
                String query = "INSERT INTO seeker (seekerFName, seekerLName, seekerEmail, seekerPhone, seekerUName, seekerAddress, seekerPassword, seekerImg, seekerCV) VALUES (?,?,?,?,?,?,?,?,?)";
            
                PreparedStatement statement = connection.prepareStatement(query);
                statement.setString(1, firstname);
                statement.setString(2, lastName);
                statement.setString(3, email);
                statement.setString(4, phone);
                statement.setString(5, username);
                statement.setString(6, address);
                statement.setString(7, HashedPassword);
                statement.setString(8, PicturePath);
                statement.setString(9, cv);
                
                int result = statement.executeUpdate();
            
                if (result > 0) {
                    response.sendRedirect("../seekerLogin.jsp?success=1");
                } else {
                    response.sendRedirect("../userRegisterForm.jsp?error=2");
                }
                
                statement.close();
                connection.close();
                
            } catch (SQLException e) {
                out.println("<h3>Database Error:</h3>");
                out.println("<p>" + e.getMessage() + "</p>");
                out.println("<a href='../userRegisterForm.jsp'>Go Back</a>");
                e.printStackTrace();
            } catch (Exception e) {
                out.println("<h3>Error:</h3>");
                out.println("<p>" + e.getMessage() + "</p>");
                out.println("<a href='../userRegisterForm.jsp'>Go Back</a>");
                e.printStackTrace();
            }
        %>
    </body>
</html>
