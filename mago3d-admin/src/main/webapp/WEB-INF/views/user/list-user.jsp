<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<%@ include file="/WEB-INF/views/common/config.jsp" %>

<!DOCTYPE html>
<html lang="${accessibility}">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width">
	<title>${sessionSiteName }</title>
	<link rel="stylesheet" href="/css/${lang}/font/font.css" />
	<link rel="stylesheet" href="/images/${lang}/icon/glyph/glyphicon.css" />
	<link rel="stylesheet" href="/externlib/${lang}/normalize/normalize.min.css" />
	<link rel="stylesheet" href="/externlib/${lang}/jquery-ui/jquery-ui.css" />
	<link rel="stylesheet" href="/css/${lang}/style.css" />
</head>
<body>
	<%@ include file="/WEB-INF/views/layouts/header.jsp" %>
	<%@ include file="/WEB-INF/views/layouts/menu.jsp" %>
	<div class="site-body">
		<div class="container">
			<div class="site-content">
				<%@ include file="/WEB-INF/views/layouts/sub_menu.jsp" %>
				<div class="page-area">
					<%@ include file="/WEB-INF/views/layouts/page_header.jsp" %>
					<div class="page-content">
						<div class="filters">
		    				<form:form id="searchForm" modelAttribute="userInfo" method="post" action="/user/list-user.do" onsubmit="return searchCheck();">
							<div class="input-group row">
								<div class="input-set">
									<label for="user_group_id">그룹명</label>
									<form:select path="user_group_id" cssClass="select">
										<option value="0">전체</option>
<c:forEach var="userGroup" items="${userGroupList}">
										<option value="${userGroup.user_group_id}">${userGroup.group_name}</option>
</c:forEach>
									</form:select>
								</div>
								<div class="input-set">
									<label for="search_word">검색어</label>
									<select id="search_word" name="search_word" class="select">
										<option value="">선택</option>
					                	<option value="user_id">아이디</option>
										<option value="user_name">이름</option>
									</select>
									<select id="search_option" name="search_option" class="select">
										<option value="0">일치</option>
										<option value="1">포함</option>
									</select>
									<form:input path="search_value" type="search" cssClass="m" />
								</div>
								<div class="input-set">
									<label for="status">상태</label>
									<select id="status" name="status" class="select">
										<option value="">전체</option>
										<option value="0"> 사용중 </option>
										<option value="1"> 사용중지(관리자) </option>
										<option value="2"> 잠금(비밀번호 실패횟수) </option>
										<option value="3"> 휴면(로그인 기간) </option>
										<option value="4"> 만료(사용기간 종료) </option>
										<option value="5"> 삭제(화면 비표시) </option>
									</select>
								</div>
								<div class="input-set">
									<label for="otp_use_yn">OTP 사용유무</label>
									<select id="otp_use_yn" name="otp_use_yn" class="select">
										<option value="">전체</option>
										<option value="Y"> 사용 </option>
										<option value="N"> 사용안함 </option>
									</select>
								</div>
								<div class="input-set">
									<label for="otp_status">OTP 상태</label>
									<select id="otp_status" name="otp_status" class="select">
										<option value="">전체</option>
										<option value="0"> 사용중 </option>
										<option value="1"> 사용중지(관리자) </option>
										<option value="2"> 잠금(OTP 실패횟수) </option>
									</select>
								</div>
								<div class="input-set">
									<label for="user_insert_type">등록 유형</label>
									<select id="user_insert_type" name="user_insert_type" class="select">
										<option value="">전체</option>
										<option value="${userInsertType.code_value }"> ${userInsertType.code_name } </option>
										<option value="${externalUserInsertType.code_value }"> ${externalUserInsertType.code_name } </option>
									</select>
								</div>
								<div class="input-set">
									<label for="start_date">날짜</label>
									<input type="text" class="s date" id="start_date" name="start_date" />
									<span class="delimeter tilde">~</span>
									<input type="text" class="s date" id="end_date" name="end_date" />
								</div>
								<div class="input-set">
									<label for="order_word">표시순서</label>
									<select id="order_word" name="order_word" class="select">
										<option value=""> 기본 </option>
					                	<option value="user_id"> 아이디 </option>
										<option value="user_name"> 이름 </option>
										<option value="last_login_date"> 로그인날짜 </option>
										<option value="register_date"> 등록일 </option>
									</select>
									<select id="order_value" name="order_value" class="select">
				                		<option value=""> 기본 </option>
					                	<option value="ASC"> 오름차순 </option>
										<option value="DESC"> 내림차순 </option>
									</select>
									<select id="list_counter" name="list_counter" class="select">
				                		<option value="10"> 10 개씩 </option>
					                	<option value="50"> 50 개씩 </option>
										<option value="100"> 100 개씩 </option>
									</select>
								</div>
								<div class="input-set">
									<input type="submit" value="검색" />
								</div>
							</div>
							</form:form>
						</div>
						<div class="list">
							<form:form id="listForm" modelAttribute="userInfo" method="post">
								<input type="hidden" id="check_ids" name="check_ids" value="" />
							<div class="list-header row">
								<div class="list-desc u-pull-left">
									전체: <em><fmt:formatNumber value="${pagination.totalCount}" type="number"/></em>건, 
									<fmt:formatNumber value="${pagination.pageNo}" type="number"/> / <fmt:formatNumber value="${pagination.lastPage }" type="number"/> 페이지
								</div>
								<div class="list-functions u-pull-right">
									<div class="button-group">
										<a href="#" onclick="passowrdInit(); return false;" class="button">비밀번호 초기화</a>
										<a href="#" onclick="updateUserStatus('USER', 'LOCK'); return false;" class="button">사용자 잠금</a>
										<a href="#" onclick="updateUserStatus('USER', 'UNLOCK'); return false;" class="button">사용자 잠금 해제</a>
										<a href="#" onclick="updateUserStatus('OTP', 'LOCK'); return false;" class="button">OTP 잠금</a>
										<a href="#" onclick="updateUserStatus('OTP', 'UNLOCK'); return false;" class="button">OTP 잠금 해제</a>
										<a href="#" onclick="deleteUsers(); return false;" class="button">일괄삭제</a>
										<a href="#" onclick="inputExcelUser(); return false;" class="button">일괄등록(Excel)</a>
<c:if test="${txtDownloadFlag ne 'true' }">
										<a href="/user/download-excel-user.do" class="button">다운로드(Excel)</a>
</c:if>
<c:if test="${txtDownloadFlag eq 'true' }">
										<a href="/user/download-txt-user.do" class="button">다운로드(Txt)</a>
</c:if>
										<a href="/user/download-excel-user-sample.do" class="image-button button-area button-batch-download" title="일괄등록예제파일"><span>일괄등록예제파일</span></a>
									</div>
								</div>
							</div>
							<table class="list-table scope-col">
									<col class="col-checkbox" />
									<col class="col-number" />
									<col class="col-name" />
									<col class="col-id" />
									<col class="col-name" />
									<col class="col-toggle" />
									<col class="col-toggle" />
									<col class="col-toggle" />
									<col class="col-toggle" />
									<!-- <col class="col-tel" /> -->
									<!-- <col class="col-email" /> -->
									<col class="col-date" />
									<col class="col-date" />
									<col class="col-functions" />
									<thead>
										<tr>
											<th scope="col" class="col-checkbox"><input type="checkbox" id="chk_all" name="chk_all" /></th>
											<th scope="col" class="col-number">번호</th>
											<th scope="col" class="col-name">그룹명</th>
											<th scope="col" class="col-id">아이디</th>
											<th scope="col" class="col-name">이름</th>
											<th scope="col" class="col-toggle">상태</th>
											<th scope="col" class="col-toggle">OTP사용유무</th>
											<th scope="col" class="col-toggle">OTP상태</th>
											<th scope="col" class="col-toggle">등록유형</th>
											<!-- <th scope="col" class="col-tel">전화번호</th> -->
											<!-- <th scope="col" class="col-email">이메일</th> -->
											<th scope="col" class="col-date">마지막 로그인</th>
											<th scope="col" class="col-date">등록일</th>
											<th scope="col" class="col-functions">수정/삭제</th>
										</tr>
									</thead>
									<tbody>
<c:if test="${empty userList }">
										<tr>
											<td colspan="12" class="col-none">사용자가 존재하지 않습니다.</td>
										</tr>
</c:if>
<c:if test="${!empty userList }">
	<c:forEach var="userInfo" items="${userList}" varStatus="status">
										<tr>
											<td class="col-checkbox">
												<input type="checkbox" id="user_id_${userInfo.user_id}" name="user_id" value="${userInfo.user_id}" />
											</td>
											<td class="col-number">${pagination.rowNumber - status.index }</td>
											<td class="col-name"><a href="#" class="view-group-detail" onclick="detailUserGroupInfo('${userInfo.user_group_id }'); return false;">${userInfo.user_group_name }</a></td>
											<td class="col-id">${userInfo.user_id }</td>
											<td class="col-name"><a href="/user/detail-user.do?user_id=${userInfo.user_id }&amp;pageNo=${pagination.pageNo }${pagination.searchParameters}">${userInfo.user_name }</a></td>
											<td class="col-toggle">
		<c:if test="${userInfo.status eq '0'}">
												<span class="icon-glyph glyph-on on"></span>
		</c:if>
		<c:if test="${userInfo.status ne '0'}">
												<span class="icon-glyph glyph-off off"></span>
		</c:if>
												<span class="icon-text">${userInfo.viewStatus }</span>
											</td>
											<td class="col-toggle">
		<c:if test="${userInfo.otp_use_yn eq 'Y'}">
												<span class="icon-glyph glyph-on on"></span>
		</c:if>
		<c:if test="${userInfo.otp_use_yn eq 'N'}">
												<span class="icon-glyph glyph-off off"></span>
		</c:if>
												<span class="icon-text">${userInfo.viewOtpUseYn }</span>
											</td>
											<td class="col-toggle">
		<c:if test="${userInfo.otp_status eq '0'}">
												<span class="icon-glyph glyph-on on"></span>								
		</c:if>		
		<c:if test="${userInfo.otp_status ne null && userInfo.otp_status ne '0'}">
												<span class="icon-glyph glyph-off off"></span>							
		</c:if>							
												<span class="icon-text">${userInfo.viewOtpStatus }</span>		
											</td>
											<td class="col-toggle">${userInfo.viewUserInsertType }</td>
											<%-- <td class="col-tel">${userInfo.viewMaskingMobilePhone }</td> --%>
											<%-- <td class="col-email">${userInfo.viewMaskingEmail }</td> --%>
											<td class="col-date">${userInfo.viewLastLoginDate }</td>
											<td class="col-date">${userInfo.viewRegisterDate }</td>
											<td class="col-functions">
												<span class="button-group">
													<a href="/user/modify-user.do?user_id=${userInfo.user_id }&amp;pageNo=${pagination.pageNo }${pagination.searchParameters}" class="image-button button-edit">수정</a>
													<a href="/user/delete-user.do?user_id=${userInfo.user_id }" onclick="return deleteWarning();" class="image-button button-delete">삭제</a>
												</span>
											</td>
										</tr>
	</c:forEach>
</c:if>
									</tbody>
							</table>
							</form:form>
							
							<%-- 엑셀 다운로드 --%>
							<form:form id="excelUserInfo" modelAttribute="excelUserInfo" method="post" action="/user/download-excel-user.do">
								<form:hidden path="user_group_id" />
								<form:hidden path="search_word" />
								<form:hidden path="search_option" />
								<form:hidden path="search_value" />
								<form:hidden path="status" />
								<form:hidden path="otp_status" />
								<form:hidden path="otp_use_yn" />
								<form:hidden path="user_insert_type" />
								<form:hidden path="start_date" />
								<form:hidden path="end_date" />
								<form:hidden path="order_word" />
								<form:hidden path="order_value" />
							</form:form>
							<%-- 엑셀 다운로드 --%>
						</div>
						<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/layouts/footer.jsp" %>
	
	<div class="dialog" title="사용자 그룹 정보">
		<table class="inner-table scope-row">
			<col class="col-label" />
			<col class="col-data" />
			<tr>
				<th class="col-label" scope="row">그룹명</th>
				<td id="group_name_info" class="col-data"></td>
			</tr>
			<tr>
				<th class="col-label" scope="row">그룹명(영문)</th>
				<td id="group_key_info" class="col-data"></td>
			</tr>
			<tr>
				<th class="col-label" scope="row">사용여부</th>
				<td id="viewUseYn_info" class="col-data"></td>
			</tr>
			<tr>
				<th class="col-label" scope="row">설명</th>
				<td id="description_info" class="col-data"></td>
			</tr>
		</table>
	</div>
	<%-- 일괄등록(Excel) --%>
	<div class="dialog_excel" title="사용자 일괄 등록">
		<form id="fileInfo" name="fileInfo" action="/user/ajax-insert-excel-user.do" method="post" enctype="multipart/form-data">
			<table id="excelUserUpload" class="inner-table scope-row">
				<col class="col-sub-label xl" />
				<col class="col-data" />
				<tbody>
					<tr>
						<th class="col-sub-label xl">파일올리기</th>
						<td>
							<div class="inner-data">
								<input type="file" id="file_name" name="file_name" class="col-data" />
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="button-group">
				<input type="button" onclick="fileUpload();" class="button" value="파일저장" />
			</div>
		</form>
	</div>
	<%-- 일괄등록(Excel) --%>
	
<script type="text/javascript" src="/externlib/${lang}/jquery/jquery.js"></script>
<script type="text/javascript" src="/externlib/${lang}/jquery-ui/jquery-ui.js"></script>
<script type="text/javascript" src="/externlib/${lang}/jquery/jquery.form.js"></script>	
<script type="text/javascript" src="/js/${lang}/common.js"></script>
<script type="text/javascript" src="/js/${lang}/message.js"></script>
<script type="text/javascript" src="/js/${lang}/navigation.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		initJqueryCalendar();
		
		initSelect(	new Array("user_group_id", "status", "otp_status", "otp_use_yn", "user_insert_type", "search_word", "search_option", "search_value", "order_word", "order_value", "list_counter"), 
					new Array("${userInfo.user_group_id}", "${userInfo.status}", "${userInfo.otp_status}", "${userInfo.otp_use_yn}", "${userInfo.user_insert_type}", "${userInfo.search_word}", 
							"${userInfo.search_option}", "${userInfo.search_value}", "${userInfo.order_word}", "${userInfo.order_value}", "${pagination.pageRows }"));
		initCalendar(new Array("start_date", "end_date"), new Array("${userInfo.start_date}", "${userInfo.end_date}"));
		$( ".select" ).selectmenu();
	});
	
	var dialog = $( ".dialog" ).dialog({
		autoOpen: false,
		height: 300,
		width: 400,
		modal: true,
		resizable: false
	});
	
	var dialog_excel = $( ".dialog_excel" ).dialog({
		autoOpen: false,
		height: 445,
		width: 600,
		modal: true,
		resizable: false,
		close: function() { location.reload(); }
	});
	
	// 전체 선택 
	$("#chk_all").click(function() {
		$(":checkbox[name=user_id]").prop("checked", this.checked);
	});
	
	// 사용자 등록 Layer 생성
	function inputExcelUser() {
		dialog_excel.dialog( "open" );
	}
	// 사용자 등록 Layer 닫기
	function popClose() {
		dialog_excel.dialog( "close" );
		location.reload();
	}
	
	// 비밀번호 초기화
	var passowrdInitFlag = true;
	function passowrdInit() {
		if($("input:checkbox[name=user_id]:checked").length == 0) {
			alert(JS_MESSAGE["check.value.required"]);
			return false;
		} else {
			var checkedValue = "";
			$("input:checkbox[name=user_id]:checked").each(function(index){
				checkedValue += $(this).val() + ",";
			});
			$("#check_ids").val(checkedValue);
		}
		var info = $("#listForm").serialize();		
		if(passowrdInitFlag) {
			passowrdInitFlag = false;
			$.ajax({
				url: "/user/ajax-init-user-password.do",
				type: "POST",
				data: info,
				cache: false,
				async:false,
				dataType: "json",
				success: function(msg){
					if(msg.result == "success") {
						alert(JS_MESSAGE["update"]);
						location.reload();
						$(":checkbox[name=user_id]").prop("checked", false);
					} else {
						alert(JS_MESSAGE[msg.result]);
					}
					passowrdInitFlag = true;
				},
				error:function(request,status,error){
			        alert(JS_MESSAGE["ajax.error.message"]);
			        passowrdInitFlag = true;
				}
			});
		} else {
			alert(JS_MESSAGE["button.dobule.click"]);
			return;
		} 
	}
	
	var updateUserStatusFlag = true;
	function updateUserStatus(business_type, status_value) {
		if($("input:checkbox[name=user_id]:checked").length == 0) {
			alert(JS_MESSAGE["check.value.required"]);
			return false;
		} else {
			var checkedValue = "";
			$("input:checkbox[name=user_id]:checked").each(function(index){
				checkedValue += $(this).val() + ",";
			});
			$("#check_ids").val(checkedValue);
		}
		var info = $("#listForm").serialize() + "&business_type=" + business_type + "&status_value=" + status_value;		
		if(updateUserStatusFlag) {
			updateUserStatusFlag = false;
			$.ajax({
				url: "/user/ajax-update-user-status.do",
				type: "POST",
				data: info,
				cache: false,
				async:false,
				dataType: "json",
				success: function(msg){
					if(msg.result == "success") {
						if(msg.result_message != null && msg.result_message != "" && business_type == "OTP") {
							var updateMessage = JS_MESSAGE["user.user_otp.update.warning"];
							var patternCount = /{update_count}/ig; // notice "g" here now!
							var pattern = /{user_ids}/ig; // notice "g" here now!
							updateMessage = updateMessage.replace( patternCount, msg.update_count );
							updateMessage = updateMessage.replace( pattern, msg.result_message );
							alert(updateMessage);
						} else {
							alert(JS_MESSAGE["update"]);	
						}
						location.reload();
						$(":checkbox[name=user_id]").prop("checked", false);
					} else {
						alert(JS_MESSAGE[msg.result]);
					}
					updateUserStatusFlag = true;
				},
				error:function(request,status,error){
			        alert(JS_MESSAGE["ajax.error.message"]);
			        updateUserStatusFlag = true;
				}
			});
		} else {
			alert(JS_MESSAGE["button.dobule.click"]);
			return;
		} 
	}

	var fileUploadFlag = true;
	function fileUpload() {
		if($("#file_name").val() == "") {
			alert(JS_MESSAGE["user.file.name"]);
			$("#file_name").focus();
			return false;
		}
		if(!isExcelFile($("#file_name").val())) {
			alert(JS_MESSAGE["user.file.excel"]);
			$("#file_name").focus();
			return false;
		}
		
		if(fileUploadFlag) {
			fileUploadFlag = false;
			$("#fileInfo").ajaxSubmit({
				type: "POST",
				cache: false,
				async:false,
				dataType: "json",
				success: function(msg){
					if(msg.result == "success") {
						if(msg.parse_error_count != 0 || msg.insert_error_count != 0) {
							$("#file_name").val('');
							alert("실패 건수가 존재합니다. 파일을 다시 선택해주세요.");
						} else {
							alert(JS_MESSAGE["update"]);
						}
						var content = ""
						+ "<tr>"
						+ 	"<td colspan=\"2\">&nbsp;</td>"
						+ "</tr>"
						+ "<tr>"
						+ 	"<td> 총건수</td>"
						+ 	"<td> " + msg.total_count + "</td>"
						+ "</tr>"
						+ "<tr>"
						+ 	"<td> 파싱 성공 건수</td>"
						+ 	"<td> " + msg.parse_success_count + "</td>"
						+ "</tr>"
						+ "<tr>"
						+ 	"<td> 파싱 실패 건수</td>"
						+ 	"<td> " + msg.parse_error_count + "</td>"
						+ "</tr>"
						+ "<tr>"
						+ 	"<td> DB 등록 성공 건수</td>"
						+ 	"<td> " + msg.insert_success_count + "</td>"
						+ "</tr>"
						+ "<tr>"
						+ 	"<td> DB 등록 실패 건수</td>"
						+ 	"<td> " + msg.insert_error_count + "</td>"
						+ "</tr>";
						$("#excelUserUpload > tbody:last").append(content);
					}
					fileUploadFlag = true;
				},
				error:function(request,status,error){
					alert(JS_MESSAGE["ajax.error.message"]);
			        fileUploadFlag = true;
				}
			});
		} else {
			alert(JS_MESSAGE["button.dobule.click"]);
			return;
		}
	}
	
	// 사용자 그룹 정보
    function detailUserGroupInfo(userGroupId) {
    	dialog.dialog( "open" );
    	ajaxUserGroupInfo(userGroupId);
	}
	
	// 사용자 그룹 정보
    function ajaxUserGroupInfo(userGroupId) {
    	$.ajax({
    		url: "/user/ajax-user-group-info.do",
    		data: { user_group_id : userGroupId },
    		type: "POST",
    		cache: false,
    		async:false,
    		dataType: "json",
    		success: function(msg){
    			if (msg.result == "success") {
    				drawUserGroupInfo(msg.userGroup);
				} else {
    				alert(JS_MESSAGE[msg.result]);
    			}
    		},
    		error:function(request,status,error){
    			alert(JS_MESSAGE["ajax.error.message"]);
    		}
    	});
    }
	
	// 사용자 그룹 정보
	function drawUserGroupInfo(jsonData) {
		$("#group_name_info").html(jsonData.group_name);
		$("#group_key_info").html(jsonData.group_key);
		$("#viewUseYn_info").html(jsonData.viewUseYn);
		$("#description_info").html(jsonData.description);
	}
	
	// 사용자 일괄 삭제
	var deleteUsersFlag = true;
	function deleteUsers() {
		if($("input:checkbox[name=user_id]:checked").length == 0) {
			alert(JS_MESSAGE["check.value.required"]);
			return false;
		} else {
			var checkedValue = "";
			$("input:checkbox[name=user_id]:checked").each(function(index){
				checkedValue += $(this).val() + ",";
			});
			$("#check_ids").val(checkedValue);
		}
		
		if(confirm(JS_MESSAGE["delete.confirm"])) {
			if(deleteUsersFlag) {
				deleteUsersFlag = false;
				var info = $("#listForm").serialize();
				$.ajax({
					url: "/user/ajax-delete-users.do",
					type: "POST",
					data: info,
					cache: false,
					async:false,
					dataType: "json",
					success: function(msg){
						if(msg.result == "success") {
							alert(JS_MESSAGE["delete"]);	
							location.reload();
							$(":checkbox[name=user_id]").prop("checked", false);
						} else {
							alert(JS_MESSAGE[msg.result]);
						}
						deleteUsersFlag = true;
					},
					error:function(request,status,error){
				        alert(JS_MESSAGE["ajax.error.message"]);
				        deleteUsersFlag = true;
					}
				});
			} else {
				alert(JS_MESSAGE["button.dobule.click"]);
				return;
			}
		}
	}
	
	function searchCheck() {
		if($("#search_option").val() == "1") {
			if(confirm(JS_MESSAGE["search.option.warning"])) {
				// go
			} else {
				return false;
			}
		} 
		
		var start_date = $("#start_date").val();
		var end_date = $("#end_date").val();
		if(start_date != null && start_date != "" && end_date != null && end_date != "") {
			if(parseInt(start_date) > parseInt(end_date)) {
				alert(JS_MESSAGE["search.date.warning"]);
				$("#start_date").focus();
				return false;
			}
		}
		return true;
	}
</script>
</body>
</html>