<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="dao" class="com.sku.cart.BookDAO"/>
<c:set var="b" value="${dao.selectBook(param.no)}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서정보 상세보기</title>
<style type="text/css">
main > h3{text-align:center; }
section {width:fit-content; margin:0.5em auto; padding:1em; border:1px solid black;}
label { display:inline-block; width:5em; padding-right:1em; }
section>div{padding:0.2em;}
div>img { width:200px; }
</style>
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<script type="text/javascript">
function cartAdd() {
   var obj = {};
   obj.no = ${b.no};
   obj.qty = $('#qty').val();
   // alert("qty:" + obj.qty)
   
   $.ajax({
      url:'cartADD.jsp',
      method:'get',
      cache:false,
      data:obj,
      dataType:'json',
      success:function(res){
		//alert(res);
        alert(res.cartadded ? '장바구니에 저장 성공':'실패');
      },
      error:function(xhr,status,err) {
         alert('에러:' + err);
      }
   })
}
</script>
</head>
<body>
<main>
   <h3>도서정보 상세보기</h3>
   <section>
      <div><label>번호</label> ${b.no}</div>
      <div><label>제목</label> ${b.title}</div>
      <div><label>저자</label> ${b.author}</div>
      <div><label>출판사</label> ${b.publisher}</div>
      <div><label>출판일</label> ${b.pubdate}</div>
      <div><label>가격</label> ${b.price}</div>
      <div><label>페이지수</label> ${b.pages}</div>
      <div><label>표지</label> <img src="./img/${b.cover}"/></div>
      <p>
      <div><label>구매수량</label> <input type="number" name="qty" id="qty"></div>
      <p>
      <a href="booklist.jsp"><button>목록보기</button></a> 
      <a href="javascript:cartAdd();"><button>장바구니에 담기</button></a>
      <a href="showCart.jsp"><button>장바구니 내용보기</button></a>
   </section>
</main>
</body>
</html>