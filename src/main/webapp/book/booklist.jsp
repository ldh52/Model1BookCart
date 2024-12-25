<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="dao" class="com.sku.cart.BookDAO"/>
<c:set var="list" value="<%=dao.bookList()%>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서목록</title>
<style type="text/css">
table { border:1px solid black; border-collapse: collapse; border-spacing: 0}
tr:nth-child(odd) { background-color:#eef; }
th{border-bottom:2px solid black;}
td,th { padding:0.2em 1em; border-right:1px solid black;}
td { border-bottom:1px dashed black; }
td>a {text-decoration: none; color:blue; }
</style>
</head>
<body>
<main>
<h3>도서목록</h3>
<section>
<table>
   <tr><th>No</th><th>제목</th><th>저자</th><th>출판사</th><th>출판일</th><th>가격</th><th>총페이지수</th></tr>
   <c:forEach var="b" items="${list}">
      <tr><td>${b.no}</td>
         <td><a href="bookDetail.jsp?no=${b.no}">${b.title}</a></td>
         <td>${b.author}</td>
         <td>${b.publisher}</td>
         <td>${b.pubdate}</td>
         <td>${b.price}</td>
         <td>${b.pages}</td>
      </tr>
   </c:forEach>
</table>
</section>
</main>
</body>
</html>