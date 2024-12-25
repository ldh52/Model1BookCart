<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.sku.cart.BookDAO" %>
<%@ page import="java.sql.SQLException" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 삭제</title>
</head>
<body>

    <jsp:useBean id="bookDAO" class="com.sku.cart.BookDAO" scope="page" /> <%-- BookDAO 객체 생성 --%>

    <%
    // 1. 삭제할 책 번호 가져오기
    int no = Integer.parseInt(request.getParameter("no"));

    // 2. 데이터베이스에서 삭제 (bookDAO 사용)
    try {
        bookDAO.deleteBook(no);
        response.sendRedirect("/book/list"); // 삭제 후 목록 페이지로 이동
    } catch (SQLException e) {
        // 데이터베이스 오류 처리 (예: 오류 메시지 출력)
        request.setAttribute("errorMessage", "데이터베이스 오류 발생: " + e.getMessage()); 
    %>
        <p style='color: red;'>${errorMessage}</p> <%-- JSTL을 사용하여 오류 메시지 출력 --%>
    <%
    }
    %>

</body>
</html>