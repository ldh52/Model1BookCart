<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sku.cart.BookVO, com.sku.cart.BookDAO" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.ParseException" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>책 정보 수정</title>
</head>
<body>

    <h2>책 정보 수정</h2>

    <%
    // 1. 수정할 책 정보 가져오기 (GET 요청)
    if (request.getMethod().equalsIgnoreCase("GET")) {
        int no = Integer.parseInt(request.getParameter("no"));
        BookDAO bookDAO = new BookDAO();
        try {
            BookVO book = bookDAO.selectBook(no);
            if (book != null) {
                request.setAttribute("book", book);
            } else {
                // 책 정보를 찾을 수 없는 경우 오류 처리
                out.println("<p style='color: red;'>해당 책 정보를 찾을 수 없습니다.</p>");
                return;
            }
        } catch (SQLException e) {
            // 데이터베이스 오류 처리
            out.println("<p style='color: red;'>데이터베이스 오류 발생: " + e.getMessage() + "</p>");
            return;
        }
    }

    // 2. 폼 출력 (GET 또는 수정 실패 시)
    BookVO book = (BookVO) request.getAttribute("book");
    if (book != null) {
    %>


    <form action="/book/update" method="post">
        <input type="hidden" name="no" value="${book.no}"> 
        <div>
            <label for="title">제목:</label>
            <input type="text" id="title" name="title" value="${book.title}" required><br>
        </div>
        <div>
            <label for="author">저자:</label>
            <input type="text" id="author" name="author" value="${book.author}" required><br>
        </div>
        <div>
            <label for="publisher">출판사:</label>
            <input type="text" id="publisher" name="publisher" value="${book.publisher}" required><br>
        </div>
        <div>
            <label for="pubdate">출판일 (yyyy-MM-dd):</label>
            <input type="date" id="pubdate" name="pubdate" value="<%= new SimpleDateFormat("yyyy-MM-dd").format(book.getPubdate()) %>" required><br> 
        </div>
        <div>
            <label for="pages">페이지 수:</label>
            <input type="number" id="pages" name="pages" value="${book.pages}" required><br>
        </div>
        <div>
            <label for="price">가격:</label>
            <input type="number" id="price" name="price" value="${book.price}" required><br>
        </div>
        <div>
            <label for="cover">표지 이미지 URL:</label>
            <input type="text" id="cover" name="cover" value="${book.cover}"><br>
        </div>
        <button type="submit">수정</button>
    </form>

    <%
    }

    // 3. 폼 제출 시 처리 로직 (POST 요청)
    if (request.getMethod().equalsIgnoreCase("POST")) {
        request.setCharacterEncoding("UTF-8");

        // 1. 요청 파라미터 처리
        int no = Integer.parseInt(request.getParameter("no"));
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
            // 날짜 변환 오류 처리 (예: 오류 메시지 출력)
            out.println("<p style='color: red;'>날짜 형식이 올바르지 않습니다.</p>");
            return; // 폼 다시 표시
        }

        // 3. BookVO 객체 생성
        BookVO updatedBook = new BookVO();
        updatedBook.setNo(no);
        updatedBook.setTitle(title);
        updatedBook.setAuthor(author);
        updatedBook.setPublisher(publisher);
        updatedBook.setPubdate(pubdate);
        updatedBook.setPages(pages);
        updatedBook.setPrice(price);
        updatedBook.setCover(cover);

        // 4. 데이터베이스에서 업데이트
        BookDAO bookDAO = new BookDAO();
        try {
            bookDAO.updateBook(updatedBook);
            response.sendRedirect("/book/detail?no=" + no); // 상세보기 페이지로 이동
        } catch (SQLException e) {
            // 데이터베이스 오류 처리 (예: 오류 메시지 출력)
            out.println("<p style='color: red;'>데이터베이스 오류 발생: " + e.getMessage() + "</p>");
        }
    }
    %>

</body>
</html>