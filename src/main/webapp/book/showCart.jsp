<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="cart" class="com.sku.cart.BookCart" scope="session"/>
<jsp:useBean id="bookDAO" class="com.sku.cart.BookDAO" scope="page" /> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니 보기</title>
<style type="text/css">
main { 
    display: flex;
    justify-content: center; /* 수평 중앙 정렬 */
    align-items: center; /* 수직 중앙 정렬 */
    min-height: 100vh; /* 뷰포트 높이만큼 main 영역 확보 */
    text-align: center; /* 텍스트 중앙 정렬 */
}

h3 { 
    margin-bottom: 20px; 
}

table {
    border-collapse: collapse;
    width: 50%; 
    border: 1px solid black;
}

th, td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}

th {
    background-color: blue; 
    color: white; 
}
   table { border-collapse: collapse; border-spacing: 0; }
   tr:first-child, tr:last-child { background-color:#dfd; }
   th,td{padding:0.3em 1em; border:1px dashed black; }
   td#total_cell { text-align:right;font-weight:bolder; }
   td.sum_label { text-align:right; font-weight: bolder;}
   input[type=number] {width:2em;}
</style>
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<script type="text/javascript">
function changeQty(no) {
   var obj = {};
   obj.no = no;
   obj.qty = $('#qty'+no).val();

   $.ajax({
      url:'updateQty.jsp',
      method:'get',
      cache:false,
      data:obj,
      dataType:'json',
      success:function(res){
         alert(res.updated ? '수량변경 성공':'실패');
         if(res.updated) location.href='showCart.jsp';
      },
      error:function(xhr,status,err){
         alert('에러:' + err);
      }
   });
}

function deleteCheckedItems() {
    var checkedItems = [];
    $('input[name="selectedItem"]:checked').each(function() {
        checkedItems.push($(this).val());
    });

    if (checkedItems.length === 0) {
        alert("삭제할 항목을 선택하세요.");
        return;
    }

    if (confirm("선택한 항목을 삭제하시겠습니까?")) {
        $.ajax({
            url: '/cart/deleteSelected', // 선택된 항목 삭제 처리를 위한 서블릿 URL
            method: 'post',
            data: { selectedItems: checkedItems },
            traditional: true, // 배열 데이터 전송 설정
            success: function(res) {
                if (res.deleted) {
                    alert('선택한 항목 삭제 성공');
                    location.reload(); // 페이지 새로고침
                } else {
                    alert('삭제 실패');
                }
            },
            error: function(xhr, status, err) {
                alert('에러: ' + err);
            }
        });
    }
}

</script>
</head>
<body>
<main>
   <h3>장바구니 보기</h3>
   <table>
   <tr><th></th><th>도서번호</th><th>제목</th><th>저자</th><th>출판사</th><th>출판일</th><th>가격</th><th>수량</th><th>합계</th></tr>
   <c:forEach var="item" items="${cart.items}" varStatus="status"> 
      <tr>
         <td><input type="checkbox" name="selectedItem" value="${status.index}"></td> 
         <c:set var="book" value="${bookDAO.selectBook(item.no)}" />
         <td>${book.no}</td><td>${book.title}</td><td>${book.author}</td><td>${book.publisher}</td>
         <td><fmt:formatDate value="${book.pubdate}" pattern="yyyy-MM-dd"/></td>
         <td class="price_cell"><fmt:formatNumber value="${book.price}" pattern="#,###" />원</td>
         <td>
            <input type="number" id="qty${book.no}" value="${item.qty}"> 
            <button onclick="changeQty(${book.no});">적용</button>
         </td>
         <td class="sum_cell">
            <fmt:formatNumber value="${book.price * item.qty}" pattern="#,###"/>원
         </td>
      </tr>
   </c:forEach>
   <fmt:formatNumber var="ttl" value="${cart.totalPrice}" type="currency" currencySymbol="\\"/>
   <tr><td colspan="7"><td class="sum_label">합계</td><td id="total_cell">${ttl}</td><td> </td></tr>
   </table>
   <p>
   <a href="booklist.jsp"><button>목록보기</button></a>
   <button onclick="deleteCheckedItems()">선택 삭제</button>
</main>
</body>
</html>