<%@ page language="java" contentType="application/json; charset=UTF-8" 
   pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:useBean id="jsObj" class="org.json.simple.JSONObject"/>
<jsp:useBean id="b" class="com.sku.cart.BookVO"/>

<jsp:setProperty name="b" property="*"/>
<jsp:useBean id="cart" class="com.sku.cart.BookCart" scope="session"/>

<c:set var="updated" value="${cart.updateQty(b)}"/>
<c:set var="total" value="${cart.totalPrice}"/>

${jsObj.put("updated",updated)}
${jsObj.toJSONString()}