package com.sku.cart;

import java.awt.print.Book;
import java.sql.Date;

public class BookVO {
    private int no;
    private String title;
    private String author;
    private String publisher;
    private java.sql.Date pubdate;
    private int pages;
    private int price;
    private String cover; // 이미지 파일 경로 또는 URL
    private int qty;

	// 기본 생성자
    public BookVO() {}
    
    public BookVO(int no) {
       this.no = no;
    }
    
    public boolean equals(Object obj) {
       BookVO other = (BookVO) obj;
       return this.no == other.no;
    }

    // 모든 필드를 포함하는 생성자
    public BookVO(int no, String title, String author, String publisher, Date pubdate, int pages, int price, String cover) {
        this.no = no;
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.pubdate = pubdate;
        this.pages = pages;
        this.price = price;
        this.cover = cover;
    }

	public int getNo()
	{
		return no;
	}

	public String getTitle()
	{
		return title;
	}

	public String getAuthor()
	{
		return author;
	}

	public String getPublisher()
	{
		return publisher;
	}

	public Date getPubdate()
	{
		return pubdate;
	}

	public int getPages()
	{
		return pages;
	}

	public int getPrice()
	{
		return price;
	}

	public String getCover()
	{
		return cover;
	}

	public void setNo(int no)
	{
		this.no = no;
	}

	public void setTitle(String title)
	{
		this.title = title;
	}

	public void setAuthor(String author)
	{
		this.author = author;
	}

	public void setPublisher(String publisher)
	{
		this.publisher = publisher;
	}

	public void setPubdate(Date pubdate)
	{
		this.pubdate = pubdate;
	}

	public void setPages(int pages)
	{
		this.pages = pages;
	}

	public void setPrice(int price)
	{
		this.price = price;
	}

	public void setCover(String cover)
	{
		this.cover = cover;
	}
	
	public void setPubdate()
	{
		this.pubdate = pubdate;
	}

	public void setPubdate(java.util.Date pubdate2) {
	    this.pubdate = (Date) pubdate2; 
	}

	public int getQty()
	{
		return qty;
	}

	public void setQty(int qty)
	{
		this.qty = qty;
	}

}