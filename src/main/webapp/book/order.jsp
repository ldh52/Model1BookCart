<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sku.cart.BookVO" %>
<%@ page import="com.sku.cart.CartItem, com.sku.cart.CartDAO, com.sku.cart.CartVO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 페이지</title>
</head>
<body>

    <h2>주문 페이지</h2>

    <%
    // 1. 세션에서 사용자 ID 및 장바구니 정보 가져오기
    String userId = (String) session.getAttribute("userId"); 
    if (userId == null) {
        // 로그인하지 않은 경우 처리 (예: 로그인 페이지로 이동)
        response.sendRedirect("/user/login");
        return;
    }

    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
        // 장바구니가 비어있는 경우 처리 (예: 장바구니 페이지로 이동)
        response.sendRedirect("/cart"); 
        return;
    }

    // 2. 주문 정보 출력
    %>

    <h3>주문 상품</h3>
    <table>
        <thead>
            <tr>
                <th>상품 정보</th>
                <th>수량</th>
                <th>가격</th>
            </tr>
        </thead>
        <tbody>
            <%
            int totalPrice = 0;
            for (CartItem item : cart) {
                BookVO book = item.getBook();
                int itemPrice = book.getPrice() * item.getQuantity();
                totalPrice += itemPrice;
            %>
                <tr>
                    <td>
                        <%= book.getTitle() %><br>
                        <%= book.getAuthor() %> / <%= book.getPublisher() %>
                    </td>
                    <td><%= item.getQuantity() %></td>
                    <td><%= itemPrice %>원</td>
                </tr>
            <%
            }
            %>
        </tbody>
    </table>

    <p>총 결제 금액: <%= totalPrice %>원</p>

    <%
    // 3. 주문자 정보 입력 폼 (필요한 경우)
    // ...

    // 4. 배송 정보 입력 폼 (필요한 경우)
    // ...

    // 5. 결제 정보 입력 폼 (필요한 경우)
    // ...

    // 6. 주문 처리 로직 (POST 요청)
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // 사용자 입력 값 가져오기 및 검증
        // ...

        // 주문 정보 데이터베이스에 저장 (CartDAO 활용 또는 직접 구현)
        // ...

        // 장바구니 비우기
        session.removeAttribute("cart");

        // 주문 완료 페이지로 이동
        response.sendRedirect("/order/complete"); 
    }
    %>

    <form action="/order" method="post"> 
        <button type="submit">주문하기</button>
    </form>

</body>
</html>