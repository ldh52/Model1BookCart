<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sku.cart.BookVO, com.sku.cart.BookDAO" %>
<%@ page import="com.sku.cart.CartItem, com.sku.cart.CartDAO, com.sku.cart.CartVO" %> 
<%@ page import="java.sql.SQLException" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니</title>
</head>
<body>

    <h2>장바구니</h2>

    <%
    // 1. 세션에서 사용자 ID 가져오기 (또는 로그인하지 않은 경우 세션 ID 사용)
    String userId = (String) session.getAttribute("userId"); // 실제 사용자 ID 가져오는 방식으로 수정
    if (userId == null) {
        // 로그인하지 않은 경우 처리 (예: 로그인 페이지로 이동)
        response.sendRedirect("/user/login");
        return;
    }

    // 2. CartDAO를 사용하여 장바구니 정보 조회
    CartDAO cartDAO = new CartDAO();
    try {
        CartVO cart = cartDAO.selectCart(userId);

        if (cart != null && !cart.getCartItems().isEmpty()) { // 장바구니에 상품이 있는 경우
    %>

    <table>
        <thead>
            <tr>
                <th>상품 이미지</th>
                <th>상품 정보</th>
                <th>수량</th>
                <th>가격</th>
                <th>삭제</th>
            </tr>
        </thead>
        <tbody>
            <%
            for (CartItem item : cart.getCartItems()) {
                BookVO book = item.getBook();
            %>
                <tr>
                    <td><img src="<%= book.getCover() %>" alt="<%= book.getTitle() %> 표지" width="50"></td>
                    <td>
                        <%= book.getTitle() %><br>
                        <%= book.getAuthor() %> / <%= book.getPublisher() %>
                    </td>
                    <td>
                        <form action="/cart/update" method="post"> <%-- 수량 변경 폼 --%>
                            <input type="hidden" name="cartId" value="<%= cart.getCartId() %>">
                            <input type="hidden" name="bookNo" value="<%= book.getNo() %>">
                            <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" required>
                            <button type="submit">변경</button>
                        </form>
                    </td>
                    <td><%= book.getPrice() * item.getQuantity() %>원</td>
                    <td>
                        <form action="/cart/delete" method="post"> <%-- 삭제 폼 --%>
                            <input type="hidden" name="cartId" value="<%= cart.getCartId() %>">
                            <input type="hidden" name="bookNo" value="<%= book.getNo() %>">
                            <button type="submit">삭제</button>
                        </form>
                    </td>
                </tr>
            <%
            }
            %>
        </tbody>
    </table>

    <p>총 가격: <%= cart.getTotalPrice() %>원</p>
    <button onclick="location.href='/order'">주문하기</button> <%-- 주문 페이지로 이동 --%>

    <% } else { %>

    <p>장바구니가 비어 있습니다.</p>

    <% } %>

    <a href="/book/list">쇼핑 계속하기</a>

    <%
    } catch (SQLException e) {
        // 데이터베이스 오류 처리
        out.println("<p style='color: red;'>데이터베이스 오류 발생: " + e.getMessage() + "</p>");
    }
    %>

</body>
</html>