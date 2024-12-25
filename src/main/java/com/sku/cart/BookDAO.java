package com.sku.cart;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class BookDAO 
{
   private Connection conn;
   private PreparedStatement pstmt;
   private ResultSet rs;
   
   private Connection getConn() 
   {
      try {
         Class.forName("oracle.jdbc.OracleDriver");
         conn = DriverManager.getConnection(
                   "jdbc:oracle:thin:@localhost:1521:xe", "SCOTT", "TIGER");
         return conn;
      }catch(Exception e) {
         e.printStackTrace();
      }
      return null;
   }
   
   public List<BookVO> bookList() 
   {
      conn = getConn();
      String sql = "SELECT * FROM book";
      try {
         pstmt = conn.prepareStatement(sql);

         rs = pstmt.executeQuery();
         List<BookVO> list = new ArrayList<BookVO>();
         while(rs.next()) {
        	 BookVO b = new BookVO();
            b.setNo(rs.getInt("NO"));
            b.setTitle(rs.getString("TITLE"));
            b.setAuthor(rs.getString("AUTHOR"));
            b.setPublisher(rs.getString("PUBLISHER"));
            b.setPubdate(rs.getDate("PUBDATE"));
            b.setPrice(rs.getInt("PRICE"));
            b.setPages(rs.getInt("PAGES"));
            b.setCover(rs.getString("COVER"));
            list.add(b);
         }
         return list;
      }catch(SQLException sqle) {
         sqle.printStackTrace();
      }finally {
         closeAll();
      }
      return null;
   }
   
   public BookVO bookDetail(int no) 
   {
      conn = getConn();
      String sql = "SELECT * FROM book WHERE no=?";
      try {
         pstmt = conn.prepareStatement(sql);
         pstmt.setInt(1, no);

         rs = pstmt.executeQuery();
         
         if(rs.next()) {
        	 BookVO b = new BookVO();
            b.setNo(rs.getInt("NO"));
            b.setTitle(rs.getString("TITLE"));
            b.setAuthor(rs.getString("AUTHOR"));
            b.setPublisher(rs.getString("PUBLISHER"));
            b.setPubdate(rs.getDate("PUBDATE"));
            b.setPrice(rs.getInt("PRICE"));
            b.setPages(rs.getInt("PAGES"));
            b.setCover(rs.getString("COVER"));
            return b;
         }
      }catch(SQLException sqle) {
         sqle.printStackTrace();
      }finally {
         closeAll();
      }
      return null;
   }
   
   public BookVO bookDetail(BookVO b) 
   {
      conn = getConn();
      String sql = "SELECT * FROM book WHERE no=?";
      try {
         pstmt = conn.prepareStatement(sql);
         pstmt.setInt(1, b.getNo());

         rs = pstmt.executeQuery();
         
         if(rs.next()) {
            b.setTitle(rs.getString("TITLE"));
            b.setAuthor(rs.getString("AUTHOR"));
            b.setPublisher(rs.getString("PUBLISHER"));
            b.setPubdate(rs.getDate("PUBDATE"));
            b.setPrice(rs.getInt("PRICE"));
            b.setPages(rs.getInt("PAGES"));
            b.setCover(rs.getString("COVER"));
            return b;
         }
      }catch(SQLException sqle) {
         sqle.printStackTrace();
      }finally {
         closeAll();
      }
      return null;
   }
   
   private void closeAll() {
      try {
         if(rs!=null) rs.close();
         if(pstmt!=null) pstmt.close();
         if(conn!=null) conn.close();
      }catch(Exception e) {
         e.printStackTrace();
      }
   }

   public void deleteBook(int no) throws SQLException {
	    String sql = "DELETE FROM book WHERE no = ?";

	    try (Connection conn = getConn();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, no);
	        pstmt.executeUpdate();
	    } 
	}

   public BookVO selectBook(int bookNo) throws SQLException {
	    String sql = "SELECT * FROM book WHERE no = ?";
	    try (Connection conn = getConn();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, bookNo);
	        try (ResultSet rs = pstmt.executeQuery()) {

	            if (rs.next()) {
	                return createBookFromResultSet(rs); // ResultSet에서 BookVO 객체 생성
	            } else {
	                return null; // 해당 번호의 책이 없는 경우 null 반환
	            }
	        }
	    }
	}

   private BookVO createBookFromResultSet(ResultSet rs2) throws SQLException {
	    BookVO book = new BookVO();
	    book.setNo(rs2.getInt("no"));
	    book.setTitle(rs2.getString("title"));
	    book.setAuthor(rs2.getString("author"));
	    book.setPublisher(rs2.getString("publisher"));
	    book.setPubdate(rs2.getDate("pubdate"));
	    book.setPages(rs2.getInt("pages"));
	    book.setPrice(rs2.getInt("price"));
	    book.setCover(rs2.getString("cover"));
	    return book;
	}
   
   public void insertBook(BookVO book) throws SQLException {
	    String sql = "INSERT INTO book (title, author, publisher, pubdate, pages, price, cover) VALUES (?, ?, ?, ?, ?, ?, ?)";
	    try (Connection conn = getConn(); // getConn() 메서드를 통해 데이터베이스 연결 얻기
	         PreparedStatement pstmt = conn.prepareStatement(sql)) { 

	        // BookVO 객체에서 가져온 값을 PreparedStatement에 설정
	        pstmt.setString(1, book.getTitle());
	        pstmt.setString(2, book.getAuthor());
	        pstmt.setString(3, book.getPublisher());
	        // java.util.Date를 java.sql.Date로 변환하여 설정
	        pstmt.setDate(4, new java.sql.Date(book.getPubdate().getTime())); 
	        pstmt.setInt(5, book.getPages());
	        pstmt.setInt(6, book.getPrice());
	        pstmt.setString(7, book.getCover());

	        pstmt.executeUpdate(); // INSERT 쿼리 실행
	    }
	}
   
   public void updateBook(BookVO book) throws SQLException {
	    String sql = "UPDATE book SET title = ?, author = ?, publisher = ?, pubdate = ?, pages = ?, price = ?, cover = ? WHERE no = ?";
	    try (Connection conn = getConn();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, book.getTitle());
	        pstmt.setString(2, book.getAuthor());
	        pstmt.setString(3, book.getPublisher());
	        pstmt.setDate(4, new java.sql.Date(book.getPubdate().getTime())); 
	        pstmt.setInt(5, book.getPages());
	        pstmt.setInt(6, book.getPrice());
	        pstmt.setString(7, book.getCover());
	        pstmt.setInt(8, book.getNo()); 

	        pstmt.executeUpdate();
	    } 
	}

}
