<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Records Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card { border: none; border-radius: 12px; box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08); }
        .card-header { background-color: #0f172a !important; color: white; border-top-left-radius: 12px !important; border-top-right-radius: 12px !important; padding: 15px 20px; }
        .table-dark { background-color: #1e293b !important; }
        .btn-primary { background-color: #2563eb; border: none; border-radius: 8px; padding: 10px 20px; font-weight: 600; }
        .btn-primary:hover { background-color: #1d4ed8; }
    </style>
</head>
<body class="py-5">
    <div class="container">
        <h2 class="mb-4 text-center fw-bold text-dark">Student Information Dashboard</h2>

        <%
            String studentName = request.getParameter("studentName");
            String rollNo = request.getParameter("rollNo");
            String email = request.getParameter("email");
            String course = request.getParameter("course");
            String gender = request.getParameter("gender");

            String dbURL = "jdbc:mysql://localhost:3306/student_dbaip";
            String dbUser = "root";
            String dbPass = "";

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                if (studentName != null && rollNo != null && !studentName.isEmpty() && !rollNo.isEmpty()) {
                    String sql = "INSERT INTO students (student_name, roll_no, email, course, gender) VALUES (?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, studentName);
                    pstmt.setString(2, rollNo);
                    pstmt.setString(3, email);
                    pstmt.setString(4, course);
                    pstmt.setString(5, gender);
                    pstmt.executeUpdate();
                    pstmt.close();
        %>
                    <div class="alert alert-success shadow-sm rounded-3" role="alert">
                        Student record successfully saved to the database!
                    </div>
        <%
                }
            } catch (Exception e) {
        %>
                <div class="alert alert-danger shadow-sm rounded-3" role="alert">
                    Database Error: <%= e.getMessage() %> (Roll Number may already exist).
                </div>
        <%
            } finally {
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        %>

        <div class="card shadow">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0 fw-semibold">Registered Students Directory</h5>
                <input type="text" id="searchInput" class="form-control form-control-sm w-25" placeholder="Search records...">
            </div>
            <div class="card-body p-0">
                <table class="table table-striped table-hover mb-0 align-middle" id="studentTable">
                    <thead class="table-dark text-white">
                        <tr>
                            <th class="py-3 ps-3">ID</th>
                            <th class="py-3">Name</th>
                            <th class="py-3">Roll No</th>
                            <th class="py-3">Email</th>
                            <th class="py-3">Course</th>
                            <th class="py-3">Gender</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT * FROM students");

                                boolean hasData = false;
                                while (rs.next()) {
                                    hasData = true;
                        %>
                                    <tr>
                                        <td class="ps-3"><%= rs.getInt("id") %></td>
                                        <td><%= rs.getString("student_name") %></td>
                                        <td><%= rs.getString("roll_no") %></td>
                                        <td><%= rs.getString("email") %></td>
                                        <td><%= rs.getString("course") %></td>
                                        <td><%= rs.getString("gender") %></td>
                                    </tr>
                        <%
                                }
                                if (!hasData) {
                        %>
                                    <tr id="noRecordsRow">
                                        <td colspan="6" class="text-center text-muted py-4">No student records found.</td>
                                    </tr>
                        <%
                                }
                                rs.close();
                                stmt.close();
                            } catch (Exception e) {
                        %>
                                <tr>
                                    <td colspan="6" class="text-danger text-center py-4">
                                        Error loading records: <%= e.getMessage() %>
                                    </td>
                                </tr>
                        <%
                            } finally {
                                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="text-center mt-4">
            <a href="index.html" class="btn btn-primary shadow-sm">Register Another Student</a>
        </div>
    </div>

    <script>
        document.getElementById('searchInput').addEventListener('keyup', function () {
            let filterValue = this.value.toLowerCase();
            let tableRows = document.querySelectorAll('#studentTable tbody tr');
            tableRows.forEach(function (row) {
                if (row.id === 'noRecordsRow') return;
                let rowText = row.textContent.toLowerCase();
                row.style.display = rowText.includes(filterValue) ? '' : 'none';
            });
        });
    </script>
</body>
</html>