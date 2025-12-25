<%@page import="com.classes.seeker"%>
<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    seeker seeker = (seeker) session.getAttribute("seeker");
    if (seeker == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        return;
    }

    String notificationId = request.getParameter("notificationId");
    
    if (notificationId != null) {
        Connection connection = null;
        try {
            connection = DBConnector.getCon();
            
            PreparedStatement stmt = connection.prepareStatement(
                "UPDATE notifications SET is_read = true, read_at = NOW() " +
                "WHERE notification_id = ? AND recipient_type = 'seeker' AND recipient_id = ?");
            stmt.setString(1, notificationId);
            stmt.setInt(2, seeker.getSeekerID());
            
            stmt.executeUpdate();
            stmt.close();
            
            response.setStatus(HttpServletResponse.SC_OK);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            if (connection != null) connection.close();
        }
    } else {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    }
%>