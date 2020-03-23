<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

		<script src="https://code.jquery.com/jquery-3.4.1.min.js" 
		integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo=" crossorigin="anonymous"></script>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css" type="text/css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/timeline.css" type="text/css">
    
<title>타임라인 메인 화면</title>

</head>

<style>
	  .drawColor:hover{
         cursor: pointer;
      }
      #canvas {
        border: 1px solid black;
      }

      .jb_table {
        display: table;
      }

      .drawing {
        border-radius: 10px;
        display: table-row;
      }

      #draw {
        display: table-cell;
        vertical-align: top;
      }

      .drawColor{
          width:32px;
          height: 32px;
          margin-left: 10px;
      }
      
      a:hover {
		   color: #0d0d0d;
		   text-decoration: none;
	 }

</style>
<body style="background-color : rgb(221, 233, 218);">


	<!-- 골목 네비바 여백 -->
	<div class="container-fluid" style="margin-top: 57px;">
		<div class="row"  style="padding: 0px; height:44px"></div>
	</div>


	<!-- 고정된 골목 네비바  -->
	<%@ include file="../street/streetDetail/streetNav.jsp"%>
	<%-- <jsp:include page="../street/streetDetail/streetNav.jsp"/> --%>



	<!-- 고정된 헤더 -->
	<%@include file="../common/header.jsp"%>
	<%-- <jsp:include page="../common/header.jsp"/> --%>



	<!-- 컨텐츠영역-->
	<div class="container-fluid">
		<div class="row">
			
			<%@ include file="../street/streetDetail/streetSide.jsp"%>
			<%-- <jsp:include page="../street/streetDetail/streetSide.jsp"/> --%>
			
			
			<!-- 사이드1 여백 -->
			<div class="col-md-4" id="devideArea"></div>
			<!-- 사이드1 여백 -->


			<!-- 타임라인-->
			<div class="col-md-4" id="devideArea" style="margin-top: 10px;">



				<!-- 검색Bar-->
				<div class="row" id="searchArea" style="width: 99%; margin-left: 1px;">
					<%@ include file="../street/streetDetail/searchBar.jsp"%>
				</div>
				<!-- 검색Bar -->



				<!-- 글작성 영역 -->
				<div class="container box111" id="postArea">
					<%@ include file="../street/streetDetail/fileUpload.jsp"%>
					<%@ include file="../street/streetDetail/post.jsp"%>
				</div>
				<!-- 글작성 영역 -->


				<!-- 중간여백 --><div class="row" style="height: 20px; background-color: rgb(221, 233, 218);"></div>


				<!-- 게시글영역-->
				<div class="postWrapView">
					<%@ include file="../street/streetDetail/timeLine.jsp"%>
				</div>
				<!-- 게시글영역 끝-->
				
				
			</div>
			<!-- 타임라인-->
			
			
			<!-- 사이드2 여백 -->
			<div class="col-md-4" id="devideArea"></div>
			<!-- 사이드2 여백 -->
			
			
			
			
			
			
			
		</div>
	</div>
	<!-- 컨텐츠영역 종료 -->


	<script>
		$(document).ready(function() {
			// 새로고침
			function refreshList() {
				location.reload();
			}

			// 글삭제
			$(".deletePost").click(function() {
				var postNo = $(this).attr("id");
				//var divBox = $(this).parent(".box111");

				$.ajax({
					url : "deletePost",
					data : {postNo : postNo},
					type : "post",
					success : function(result) {
						if (result == "true") {
							system.out.println("게시글 삭제 성공")
							//divBox.remove();
						} else {
							system.out.println("게시글 삭제 실패")
						}
					},
					error : function(e) {
						console.log("ajax 통신 실패");
						console.log(e);
					}
				});
				refreshList()
			}); 
			
			
			// 댓글작성
			$(".commentBtn").click(function() {
				var postNo = $(this).attr("name");
				//var divBox = $(this).parent(".box111");
				var commentContent = $(this).parent().prev().find("textarea").val();
				var replyCount = $(this).parent().parent().parent().prev("div" > ".commentCount").text().substring( 2 );
				
				if(replyCount==""){
					replyCount=0;
				}
				console.log("replyCount:"+replyCount);
				console.log("댓글입력내용:"+commentContent);
				console.log("댓글 입력 게시글 번호 :"+postNo);
												
				$.ajax({
					url : "writeComment",
					data : {"postNo" : postNo, "commentContent" : commentContent },
					type : "post",
					success : function(result) {
						
						if (result == "true") {
							replyCount++;
							$(this).parent().parent().parent().prev("div" > ".commentCount").text("댓글"+replyCount);
							console.log("댓글 작성 성공");
							$(this).parent().prev("div" > ".writeCommentArea" ).text('');
							
						} else {
							$(this).parent().prev("div" > ".writeCommentArea" ).text('');
						}
					},
					error : function(e) {
						console.log("ajax 통신 실패");
						$(this).parent().prev().find("textarea").val= "";
						console.log("댓글 입력 후 내용:"+commentContent);
						console.log(e);
					}
				});
				 refreshList()
			});
			
			// 대댓글작성
			$(".reCommentBtn").click(function() {
				var replyNo = $(this).attr("name");
				var boardNo = $(this).attr("id");
				var commentContent = $(this).parent().prev().find("textarea").val();
				var reReplyCount = $(this).parent().parent().parent().prev("div" > ".reCommentCount").text().substring( 2 );
				
				if(reReplyCount==""){
					reReplyCount=0;
				}
				console.log("reReplyCount:"+reReplyCount);
				console.log("댓글입력내용:"+commentContent);
				console.log("대댓글 달린 댓글 번호 :"+replyNo);
												
				$.ajax({
					url : "writeReComment",
					data : {"replyNo" : replyNo, "commentContent" : commentContent, "boardNo" : boardNo },
					type : "post",
					success : function(result) {
						
						if (result == "true") {
							reReplyCount++;
							$(this).parent().parent().parent().prev("div" > ".commentCount").text("댓글"+replyCount);
							console.log("대댓글 작성 성공");
							$(this).parent().prev("div" > ".writeCommentArea" ).text('');
							
							
						} else {
							$(this).parent().prev("div" > ".writeCommentArea" ).text('');
						}
					},
					error : function(e) {
						console.log("ajax 통신 실패");
						$(this).parent().prev().find("textarea").val= "";
						console.log("댓글 입력 후 내용:"+commentContent);
						console.log(e);
						
					}
				});
				 refreshList()
			});
			

			// 글수정
			/* $(".updatePost").click(function() {
				var postNo = $(this).attr("id");
				//var divBox = $(this).parent(".box111");

				$.ajax({
					url : "updatePost",
					data : {
						postNo : postNo
					},
					type : "post",
					success : function(result) {
						if (result == "true") {
							system.out.println("게시글 삭제 성공")
							//divBox.remove();
						} else {
							system.out.println("게시글 삭제 실패")
						}
					},
					error : function(e) {
						console.log("ajax 통신 실패");
						console.log(e);
					}
				});
				refreshList()
			}); */

			// 게시글 좋아요 클릭시 버튼 이미지 변경, 좋아요 기록
			$(".likeBtn").click(function() {
				var postNo = $(this).attr("name");
				var img = $(this).attr("src");
				var likeCount = $(this).parent().next("p").text()

				if (img == "${contextPath}/resources/img/like.png") {
					likeCount++;
					$(this).attr('src','${contextPath}/resources/img/like2.png');
				} else {
					likeCount--;
					$(this).attr('src','${contextPath}/resources/img/like.png');
				}
				
				if ( likeCount==0){
					likeCount=""
					$(this).parent().next("p").text(likeCount);
				}else{
					$(this).parent().next("p").text(likeCount);
				}

				$.ajax({
					url : "likeFunction",
					data : {"postNo" : postNo},
					type : "post",
					success : function(result) {
						if (result == "true") {
							console.log("좋아요 등록 성공");
						} else {
							console.log("좋아요 해제 성공");
						}
					},
					error : function(e) {
						console.log("ajax 통신 실패");
						console.log(e);
					}
				});
			}); 
			
			
			// 댓글 좋아요 클릭시 버튼 이미지 변경, 좋아요 기록
			$(".likeBtn2").click(function() {
				var replyNo = $(this).attr("name");
				var boardNo = $(this).attr("id");
				var img = $(this).attr("src");
				var likeCount = $(this).parent().next("p").text()

				if (img == "${contextPath}/resources/img/like.png") {
					likeCount++;
					$(this).attr('src','${contextPath}/resources/img/like2.png');
				} else {
					likeCount--;
					$(this).attr('src','${contextPath}/resources/img/like.png');
				}
				
				if ( likeCount==0){
					likeCount=""
					$(this).parent().next("p").text(likeCount);
				}else{
					$(this).parent().next("p").text(likeCount);
				}

				$.ajax({
					url : "replyLikeFunction",
					data : {replyNo : replyNo, boardNo : boardNo},
					type : "post",
					success : function(result) {
						if (result == "true") {
							console.log("좋아요 등록 성공");
						} else {
							console.log("좋아요 해제 성공");
						}
					},
					error : function(e) {
						console.log("ajax 통신 실패");
						console.log(e);
					}
				});
			}); 
			
			// 대댓글 좋아요 클릭시 버튼 이미지 변경, 좋아요 기록
			$(".likeBtn3").click(function() {
				var replyNo = $(this).attr("name");
				var boardNo = $(this).attr("id");
				var img = $(this).attr("src");
				var likeCount = $(this).parent().next("p").text()

				if (img == "${contextPath}/resources/img/like.png") {
					likeCount++;
					$(this).attr('src','${contextPath}/resources/img/like2.png');
				} else {
					likeCount--;
					$(this).attr('src','${contextPath}/resources/img/like.png');
				}
				
				if ( likeCount==0){
					likeCount=""
					$(this).parent().next("p").text(likeCount);
				}else{
					$(this).parent().next("p").text(likeCount);
				}

				$.ajax({
					url : "reReplyLikeFunction",
					data : {replyNo : replyNo, boardNo : boardNo},
					type : "post",
					success : function(result) {
						if (result == "true") {
							console.log("좋아요 등록 성공");
						} else {
							console.log("좋아요 해제 성공");
						}
					},
					error : function(e) {
						console.log("ajax 통신 실패");
						console.log(e);
					}
				});
			}); 
			
			
			// 작성자 프로필 조회
			$(".writerImg, .writerNickName" ).on("click",function(){
				var memberNo = $(this).attr("name");
				
				$.ajax({
					url : "checkProfile",
					data : { memberNo : memberNo },
					type : "post",
					dataType : "json",
					success : function(mList){
						
						// 회원정보
						$("#writerProfileUrl").prop("src","${contextPath}/resources/profileImage/"+mList[0].memberProfileUrl);
						$("#writerNickName").val(mList[0].memberNickname);
						/* $("#memberEmail").val(-); */
						$("#writerName").val(mList[0].memberNm);
						$("#writerAge").val(mList[0].memberAge);
						$("#writerPhone").val("-");
						if(mList[0].memberGender == "M") {
							$("#writerGender").val("남성");	
						}else {
							$("#writerGender").val("여성");
						}
						// 회원정보 끝
						
		    			// 회원 관심사
						var $divPlus = $("#writerProfileHobby");
		    		
						for(var i=1;i<Object.keys(mList).length;i++){
							if(i == 1) { // 제일 처음 관심사
								var $divPlus1 = $("<div class='col-sm-10'>");
			       				var $labelPlus = $("<label>");
			       				var $inputPlus = $("<input>");
								$labelPlus.addClass("col-sm-2 col-form-label text-center nanum").css({"font-weight" : "bold","font-size": "16px"}).html("관심분야");
								$inputPlus.prop({"type":"text","readonly":"true"}).css({"color" : "blue","font-size": "25px"})
										  .addClass("nanum form-control-plaintext").val("#" + mList[1].hobbyName);
								$divPlus1.append($inputPlus);
								if(document.getElementById("writerProfileHobby").childElementCount < (Object.keys(mList).length-1)*2) {
									$divPlus.append($labelPlus);
		   						$divPlus.append($divPlus1);	
								}
							} else { // 그 다음 관심사
								var $divPlus1 = $("<div class='col-sm-10'>");
			       				var $labelPlus = $("<label>");
			       				var $inputPlus = $("<input>");
								$labelPlus.addClass("col-sm-2 col-form-label text-center nanum").css({"font-weight" : "bold","font-size": "16px"});
								$inputPlus.prop({"type":"text","readonly":"true"}).css({"color" : "blue","font-size": "25px"})
										  .addClass("nanum form-control-plaintext").val("#" + mList[i].hobbyName);
								$divPlus1.append($inputPlus);
								if(document.getElementById("writerProfileHobby").childElementCount < (Object.keys(mList).length-1)*2) {
									$divPlus.append($labelPlus);
		   						$divPlus.append($divPlus1);	
								}
							}
						}
						// 회원 관심사 끝
						
					},
					error : function(e){
		   			console.log("ajax 통신 실패");
		   			console.log(e);
		   		}
					
				});
				
			});
			/* 회원 프로필 정보 조회용  */
		});
		
	  	// 댓글 영역 숨기기
  		$(".commentArea").click(function() {
  			$(this).parent().next("div").toggle(100);
  			$('.writeCommentArea').focus();
  		}); 

  		// 대댓글 영역 숨기기
  		$(".doubleCommentArea").click(function() {
  			$(this).parent().parent().parent().next("div").toggle(100);
  			// $(".inputCommentWrap").toggle(500);
  			$('.writeCommentArea2').focus();
  		});
    	
   		//  게시글, 댓글 수정/삭제 메뉴창 보이기, 숨기기
   		$(".optionChevron>img").click(function() {
   			$(this).next("div").toggleClass("hide");
   		});

   		$(".likeNum").click(function() {
   			$(this).next("div").toggleClass("hide");
   		});

   		// 게시글 작성 영역 높이 자동증가
   		$('.writePost').on('keyup', 'textarea', function(e) {
   			$(this).css('height', 'auto');
   			$(this).height(this.scrollHeight);
   		});
   		$('.writePost').find('textarea').keyup();

   		// 댓글 작성 영역 높이 자동증가
   		$('.inputCommentWrap').on('keyup', 'textarea', function(e) {
   			$(this).css('height', 'auto');
   			$(this).height(this.scrollHeight);
   		});
   		$('.inputCommentWrap').find('textarea').keyup();

   		// 댓글 출력 영역 높이 자동증가
   		$('.commentContentWrap').on('keyup', 'textarea', function(e) {
   			$(this).css('height', 'auto');
   			$(this).height(this.scrollHeight);
   		});
   		$('.commentContentWrap').find('textarea').keyup();

   		// 게시글 출력 영역 높이 자동증가
   		$('.postMainWrap').on('keyup', 'textarea', function(e) {
   			$(this).css('height', 'auto');
   			$(this).height(this.scrollHeight);
   		});
   		$('.postMainWrap').find('textarea').keyup();

   		// 게시물 없을때 게시글 작성 클릭시 커서 이동
   		$(".noPostSignArea").click(function() {
   			$('.postArea').focus();
   		});
   		
   		// 지도 모달 창 열기 
		$(".mapOption").click(function(){
			$(this).parent().next("div").attr("style", "display:block");
	    });
	   
	    $("#modal_close_btn").click(function(){
			$(this).parent().parent("div").attr("style", "display:none");
	    });    
	    
	 	// 스케치 모달 창 열기 
		$(".sketchOption").click(function(){
			$(this).parent().next("div").attr("style", "display:block");
	    });
	   
    	$("#modal_close_btn2").click(function(){
			$(this).parent().parent("div").attr("style", "display:none");
	    }); 
    	
    	 // 투표  모달 창 열기 
		$(".voteOption").click(function(){
			$(this).parent().next("div").attr("style", "display:block");
	    });
	   
	     $("#modal_close_btn3").click(function(){
			$(this).parent().parent("div").attr("style", "display:none");
	    }); 
    	     
	</script>

</body>
</html>