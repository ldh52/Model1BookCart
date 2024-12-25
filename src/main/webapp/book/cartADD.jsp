<%@ page language="java" contentType="application/json; charset=UTF-8" 
   pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="jsObj" class="org.json.simple.JSONObject"/>

<jsp:useBean id="book" class="com.sku.cart.BookVO" scope="page"/>
<jsp:setProperty name="book" property="*"/>

<jsp:useBean id="dao" class="com.sku.cart.BookDAO"/>
<c:set var="b" value="${dao.bookDetail(book)}"/>

<jsp:useBean id="cart" class="com.sku.cart.BookCart" scope="session"/>
<c:set var="added" value="${cart.add(b)}"/>

${jsObj.put("cartadded", added)}
${jsObj.toJSONString()}