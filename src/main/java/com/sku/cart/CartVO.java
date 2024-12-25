package com.sku.cart;

import java.util.ArrayList;
import java.util.List;

public class CartVO {
    private String userId; // or sessionId (로그인하지 않은 사용자의 경우)
    private List<CartItem> cartItems;
    private int totalPrice;
	private int cartId;

    public CartVO() {
        cartItems = new ArrayList<>();
        totalPrice = 0;
    }

    @Override
	public String toString()
	{
		return "CartVO [userId=" + userId + ", cartItems=" + cartItems + ", totalPrice=" + totalPrice + ", cartId="
				+ cartId + "]";
	}
    
    public CartVO(String userId) {
        this(); // 기본 생성자 호출하여 cartItems 초기화
        this.userId = userId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public List<CartItem> getCartItems() {
        return cartItems;
    }

    public void setCartItems(List<CartItem> cartItems) {
        this.cartItems = cartItems;
        calculateTotalPrice(); // cartItems 변경 시 총 가격 다시 계산
    }

    public int getTotalPrice() {
        return totalPrice;
    }

    // 장바구니에 상품 추가
    public void addCartItem(CartItem cartItem) {
        cartItems.add(cartItem);
        calculateTotalPrice();
    }

    // 장바구니에서 상품 삭제
    public void removeCartItem(CartItem cartItem) {
        cartItems.remove(cartItem);
        calculateTotalPrice();
    }

    // 장바구니 상품 수량 변경
    public void updateCartItemQuantity(CartItem cartItem, int newQuantity) {
        cartItem.setQuantity(newQuantity);
        calculateTotalPrice();
    }

    // 총 가격 계산
    void calculateTotalPrice() {
        totalPrice = 0;
        if (cartItems != null) { 
            for (CartItem item : cartItems) {
                if (item != null && item.getBook() != null && item.getQuantity() > 0) { 
                    totalPrice += item.getBook().getPrice() * item.getQuantity();
                } else {
                    // quantity가 0 이하인 경우 로그 기록 및 cartItem 삭제
                    System.err.println("CartItem 오류: bookNo=" + item.getBook().getNo() + ", quantity=" + item.getQuantity());
                    cartItems.remove(item); 
                }
            }
        }
    }

	public void setCartId(int cartId) {
        this.cartId = cartId; 
    }

    public int getCartId() {
        return cartId; 
    }
}