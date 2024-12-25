<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.sku.cart.BookVO" %>
<%@ page import="com.sku.cart.BookDAO" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<%@ page import="java.text.ParseException" %> 
<%@ page import="java.sql.SQLException" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새로운 책 등록</title>
</head>
<body>

    <h2>새로운 책 등록</h2>

    <form action="/book/insert" method="post"> 
        <div>
            <label for="title">제목:</label>
            <input type="text" id="title" name="title" required><br>
        </div>
        <div>
            <label for="author">저자:</label>
            <input type="text" id="author" name="author" required><br>
        </div>
        <div>
            <label for="publisher">출판사:</label>
            <input type="text" id="publisher" name="publisher" required><br>
        </div>
        <div>
            <label for="pubdate">출판일 (yyyy-MM-dd):</label> 
            <input type="date" id="pubdate" name="pubdate" required><br>
        </div>
        <div>
            <label for="pages">페이지 수:</label>
            <input type="number" id="pages" name="pages" required><br>
        </div>
        <div>
            <label for="price">가격:</label>
            <input type="number" id="price" name="price" required><br>
        </div>
        <div>
            <label for="cover">표지 이미지 URL:</label>
            <input type="text" id="cover" name="cover"><br>
        </div>
        <button type="submit">등록</button>
    </form>

    <c:if test="${not empty errorMessage}"> 
        <p style='color: red;'>${errorMessage}</p>
    </c:if>

    <%
        if (request.getMethod().equalsIgnoreCase("POST")) {
            request.setCharacterEncoding("UTF-8");

            // 1. 요청 파라미터 처리
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String publisher = request.getParameter("publisher");
            String pubdateStr = request.getParameter("pubdate");
            int pages = Integer.parseInt(request.getParameter("pages"));
            int price = Integer.parseInt(request.getParameter("price"));
            String cover = request.getParameter("cover");

            // 2. 날짜 변환 (문자열 -> Date)
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date pubdate;
            try {
                pubdate = dateFormat.parse(pubdateStr);
            } catch (ParseException e) {
                // 날짜 변환 오류 처리 (예: 오류 메시지 request에 저장)
                request.setAttribute("errorMessage", "날짜 형식이 올바르지 않습니다. (yyyy-MM-dd)");
                return; // 폼 다시 표시
            }

            // 3. BookVO 객체 생성
            BookVO book = new BookVO();
            book.setTitle(title);
            book.setAuthor(author);
            book.setPublisher(publisher);
            book.setPubdate(pubdate);
            book.setPages(pages);
            book.setPrice(price);
            book.setCover(cover);

            // 4. 데이터베이스에 삽입
            BookDAO bookDAO = new BookDAO();
            try {
                bookDAO.insertBook(book);
                response.sendRedirect("/book/list"); // 목록 페이지로 이동
            } catch (SQLException e) {
                // 데이터베이스 오류 처리 (예: 오류 메시지 request에 저장)
                request.setAttribute("errorMessage", "데이터베이스 오류 발생: " + e.getMessage());
            }
        }
    %>

</body>
</html>