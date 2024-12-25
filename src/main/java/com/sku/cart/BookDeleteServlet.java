package com.sku.cart;

import java.io.IOException;
import java.sql.SQLException;

import com.sku.cart.BookDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/book/delete") 
public class BookDeleteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // 1. 요청 파라미터 처리 (삭제할 책의 번호 가져오기)
        int no = Integer.parseInt(request.getParameter("no"));

        // 2. 데이터베이스에서 삭제
        BookDAO bookDAO = new BookDAO();
        try {
            bookDAO.deleteBook(no);
        } catch (SQLException e) {
            // 데이터베이스 오류 처리 (예: 오류 메시지 출력 후 다시 목록 페이지로 이동)
            e.printStackTrace();
        }

        // 3. 처리 결과에 따른 페이지 이동 (예: 목록 페이지로 이동)
        response.sendRedirect("/book/list"); 
    }
}