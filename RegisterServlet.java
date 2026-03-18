// RegisterServlet.java
 @WebServlet("/register")
 public class RegisterServlet extends HttpServlet {
 
     @Override
     protected void doPost(HttpServletRequest req,
                           HttpServletResponse resp)
             throws ServletException, IOException {
 
         String name     = req.getParameter("name").trim();
         String email    = req.getParameter("email").trim().toLowerCase();
         String password = req.getParameter("password");
 
         // Basic server-side validation
         if (name.isEmpty() || email.isEmpty() || password.length() < 6) {
             resp.sendRedirect("register.html?error=invalid");
             return;
         }
 
         // Hash password using BCrypt
         String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));
 
         try (Connection conn = DBUtil.getConnection()) {
             String sql = "INSERT INTO users (name, email, password_hash)"
                        + " VALUES (?, ?, ?)";
             PreparedStatement ps = conn.prepareStatement(sql);
             ps.setString(1, name);
             ps.setString(2, email);
             ps.setString(3, hashed);
             ps.executeUpdate();
             resp.sendRedirect("login.html?registered=true");
         } catch (SQLException e) {
             if (e.getErrorCode() == 1062) { // Duplicate email
                 resp.sendRedirect("register.html?error=exists");
             } else {
                 throw new ServletException("Database error", e);
             }
         }
     }
}
