package com.sku.cart;

import java.util.*;

public class BookCart
{
   private List<BookVO> list = new ArrayList<>();
   
   public boolean add(BookVO b) {
	   BookVO found = find(b);
      
      if(found==null) list.add(b);
      else {
         found.setQty(found.getQty()+b.getQty());
      }
      return true;
   }
   
   public BookVO find(BookVO b) {
      if(list.contains(b)) {
         return list.get(list.indexOf(b));
      }
      return null;
   }
   
   public int getTotalPrice() {
      int total = 0;
      for(int i=0;i<list.size();i++) {
         total += list.get(i).getPrice()*list.get(i).getQty();
      }
      return total;
   }
   
   public List<BookVO> getItems() {
      return list;
   }
   
   public boolean updateQty(BookVO b) {
      if(list.contains(b)) {
    	 BookVO found = list.get(list.indexOf(b));
         found.setQty(b.getQty());
         return true;
      }
      return false;
   }
}