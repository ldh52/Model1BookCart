package com.sku.cart;

public class CartItem {
    private BookVO book; // 장바구니에 담긴 책 정보
    private int quantity; // 구매 수량

    // 생성자
    public CartItem(BookVO book, int quantity) {
        this.book = book;
        this.quantity = quantity;
    }

    // Getter & Setter
    public BookVO getBook() {
        return book;
    }

    public void setBook(BookVO book) {
        this.book = book;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}