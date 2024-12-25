package com.sku.cart;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
	private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private Connection getConn() {
        try {
            Class.forName("oracle.jdbc.OracleDriver");
            conn = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:xe", "SCOTT", "TIGER");
            return conn;
        } catch (Exception e) {
            e.printStackTrace(); 
        }
        return null;
    }

    public void insertCart(CartVO cart) throws SQLException {
        // 1. cart 테이블에 삽입 (cart_id 생성)
        String insertCartSql = "INSERT INTO cart (user_id) VALUES (?)"; // user_id 컬럼 추가
        try (Connection conn = getConn();
             PreparedStatement pstmt = conn.prepareStatement(insertCartSql, Statement.RETURN_GENERATED_KEYS)) { // 생성된 키 반환 설정

            pstmt.setString(1, cart.getUserId());
            pstmt.executeUpdate();

            // 생성된 cart_id 가져오기
            ResultSet generatedKeys = pstmt.getGeneratedKeys();
            int cartId = -1; 
            if (generatedKeys.next()) {
                cartId = generatedKeys.getInt(1);
            } else {
                throw new SQLException("cart_id 생성 실패");
            }

            // 2. cart_item 테이블에 삽입
            String insertCartItemSql = "INSERT INTO cart_item (cart_id, book_no, quantity) VALUES (?, ?, ?)";
            try (PreparedStatement pstmt2 = conn.prepareStatement(insertCartItemSql)) {
                for (CartItem item : cart.getCartItems()) {
                    pstmt2.setInt(1, cartId);
                    pstmt2.setInt(2, item.getBook().getNo());
                    pstmt2.setInt(3, item.getQuantity());
                    pstmt2.executeUpdate();
                }
            }
        }
    }

    public CartVO selectCart(String userId) throws SQLException {
        CartVO cart = null; 

        // 1. cart 테이블에서 cart_id 조회
        String selectCartSql = "SELECT cart_id FROM cart WHERE user_id = ?";
        try (Connection conn = getConn(); // getConn() -> getConnection() 으로 수정
             PreparedStatement pstmt = conn.prepareStatement(selectCartSql)) {

            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) { // ResultSet도 try-with-resources로 관리

                if (rs.next()) {
                    int cartId = rs.getInt("cart_id");
                    cart = new CartVO(); // CartVO 객체를 여기서 생성
                    cart.setCartId(cartId); // cartId 설정 추가
                    cart.setUserId(userId);

                    // 2. cart_item 테이블에서 상품 목록 조회
                    String selectCartItemsSql = "SELECT * FROM cart_item WHERE cart_id = ?";
                    try (PreparedStatement pstmt2 = conn.prepareStatement(selectCartItemsSql)) {
                        pstmt2.setInt(1, cartId);
                        try (ResultSet rs2 = pstmt2.executeQuery()) { // ResultSet도 try-with-resources로 관리

                            List<CartItem> cartItems = new ArrayList<>();
                            while (rs2.next()) {
                                int bookNo = rs2.getInt("book_no");
                                int quantity = rs2.getInt("quantity");

                                // 3. book 테이블에서 책 정보 조회
                                BookDAO bookDAO = new BookDAO();
                                BookVO book = bookDAO.selectBook(bookNo);
                                if (book != null) { // 책 정보가 존재하는 경우에만 추가
                                    cartItems.add(new CartItem(book, quantity));
                                } else {
                                    // 책 정보를 찾을 수 없는 경우 처리 (예: 로그 기록, cart_item 삭제 등)
                                    // ... (실제 애플리케이션에 맞게 구현)
                                }
                            }
                            cart.setCartItems(cartItems);
                            cart.calculateTotalPrice(); // 총 가격 계산
                        } 
                    } 
                }
            } 
        } 
        return cart; 
    }

    public void updateCart(CartVO cart) throws SQLException {
        try (Connection conn = getConn()) {
            conn.setAutoCommit(false); // 트랜잭션 시작

            try {
                // 1. 기존 cart_item 삭제
                String deleteCartItemsSql = "DELETE FROM cart_item WHERE cart_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(deleteCartItemsSql)) {
                    pstmt.setInt(1, cart.getCartId());
                    pstmt.executeUpdate();
                }

                // 2. 새로운 cart_item 삽입
                String insertCartItemSql = "INSERT INTO cart_item (cart_id, book_no, quantity) VALUES (?, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(insertCartItemSql)) {
                    for (CartItem item : cart.getCartItems()) {
                        pstmt.setInt(1, cart.getCartId());
                        pstmt.setInt(2, item.getBook().getNo());
                        pstmt.setInt(3, item.getQuantity());
                        pstmt.executeUpdate();
                    }
                }

                conn.commit(); // 트랜잭션 커밋
            } catch (SQLException e) {
                conn.rollback(); // 트랜잭션 롤백
                throw e;
            }
        }
    }

    public void deleteCart(String userId) throws SQLException {
        try (Connection conn = getConn()) {
            conn.setAutoCommit(false); // 트랜잭션 시작

            try {
                // 1. cart 테이블에서 cart_id 조회
                String selectCartSql = "SELECT cart_id FROM cart WHERE user_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(selectCartSql)) {
                    pstmt.setString(1, userId);
                    ResultSet rs = pstmt.executeQuery();

                    if (rs.next()) {
                        int cartId = rs.getInt("cart_id");

                        // 2. cart_item 테이블에서 관련 항목 삭제
                        String deleteCartItemsSql = "DELETE FROM cart_item WHERE cart_id = ?";
                        try (PreparedStatement pstmt2 = conn.prepareStatement(deleteCartItemsSql)) {
                            pstmt2.setInt(1, cartId);
                            pstmt2.executeUpdate();
                        }

                        // 3. cart 테이블에서 장바구니 삭제
                        String deleteCartSql = "DELETE FROM cart WHERE cart_id = ?";
                        try (PreparedStatement pstmt3 = conn.prepareStatement(deleteCartSql)) {
                            pstmt3.setInt(1, cartId);
                            pstmt3.executeUpdate();
                        }
                    } 
                }

                conn.commit(); // 트랜잭션 커밋
            } catch (SQLException e) {
                conn.rollback(); // 트랜잭션 롤백
                throw e;
            }
        }
    }

 // 특정 상품 삭제
    public void deleteCartItem(int cartId, int bookNo) throws SQLException {
        String sql = "DELETE FROM cart_item WHERE cart_id = ? AND book_no = ?";
        try (Connection conn = getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, cartId);
            pstmt.setInt(2, bookNo);
            pstmt.executeUpdate();
        }
    }

    // 상품 수량 변경
    public void updateCartItemQuantity(int cartId, int bookNo, int newQuantity) throws SQLException {
        String sql = "UPDATE cart_item SET quantity = ? WHERE cart_id = ? AND book_no = ?";
        try (Connection conn = getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, newQuantity);
            pstmt.setInt(2, cartId);
            pstmt.setInt(3, bookNo);
            pstmt.executeUpdate();
        }
    }
}