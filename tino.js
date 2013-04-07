//$(() => {

				/* Width Test */
				 $("#HeaderBar").ready(function(){
     			 resizeDiv();
 				 });

  				window.onresize = function(event) {
      			resizeDiv();
  				}

  				function resizeDiv() {
				muc = '124';
				sbw = '220';	
   			    vpw = $(window).width(); 
      			vph = $(window).height();
      			sdh = $("#QueueScroller").height();
	      		mbh = $("#SidebarMenuScroller").height();
      			$('#contentScroller').css({'width': vpw + 'px'});
      			$('#unclickableHeader').css({'width': vpw - muc  + 'px'});
      			$('#QueueScroller, #').css({'height': sdh  + 'px'});
				$('#ContentFilter').css({'width': vpw-30  + 'px'});
  				}
				
						
				//* Cell Shadow & Link Disable *//

				$(".MenuIcon").click(function(){
					$('#content').css({'width': vpw - sbw  + 'px'});	
					$('#content, #contentWrapper').toggleClass('MenuMargin');
					$('#MenuColumn').toggleClass('displaySidebars');						
					$("#unclickable, #unclickableHeader").fadeToggle(550); 
				  	$('.AlbumContainerLink').addClass('disable');
					$('#ContentFilter').removeClass('ContentFilterVisibility');
				  });
				
				 $(".PlaylistIcon").click(function(){
					$('#content').css({'width': vpw - sbw  + 'px'});
					$('#content, #contentWrapper').toggleClass('PlaylistMargin');
					$('#Playlist, #QueueList').toggleClass('displaySidebars');						
					$("#unclickableHeader, #unclickable").fadeToggle(); 					 
				  	$('.AlbumContainerLink').addClass('disable');
					$('#ContentFilter').removeClass('ContentFilterVisibility');
				  });
				  
				  $(".FilterIcon").click(function(){
					$('#content').css({'width': vpw - sbw  + 'px'});
					$('#content, #contentWrapper').toggleClass('FilterMargin');
					$('#Filter, #FilterList').toggleClass('displaySidebars');						
					$("#unclickableHeader, #unclickable").fadeToggle(); 					 
				  	$('.AlbumContainerLink').addClass('disable');
					$('#ContentFilter').removeClass('ContentFilterVisibility');
					
				  });

				  $(".SidebarIcons, .FilterSideBar, #unclickable, #unclickableHeader").click(function(){
					$('#content, #contentWrapper').removeClass('PlaylistMargin');
					$('#content, #contentWrapper').removeClass('FilterMargin');					
					$('#content, #contentWrapper').removeClass('MenuMargin');
					$('#MenuColumn, #Playlist, #QueueList, #Filter').delay(1000).removeClass('displaySidebars');						
					$("#unclickableHeader, #unclickable").fadeToggle(); 					 
				  	$('.AlbumContainerLink').removeClass('disable');
					$('.HideBrowseOptions').addClass('DisplayNone');
					$("#HideBrowseOptions").removeClass('DisplayNone'); 					 
				  });
				  
				 $("#HideBrowseOptions").click(function(){
					$("#HideBrowseOptions").addClass('DisplayNone'); 					 
					$('.HideBrowseOptions').removeClass('DisplayNone');
				  });
				  

	if( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ) {
				//* Cell Shadow & Link Disable *//
				var header = $('.Cell');

				$("#contentWrapper").scroll(function(e){
					if(header.offset().top !== 0){
						if(!header.hasClass('shadow')){
							header.addClass('shadow');
						}
					}else{
						header.removeClass('shadow');
					}
				});
				var contentWrapper, QueueList, FilterList, SidebarMenu;
				this.QueueList = new iScroll('QueueList',  {
					snap: '.QueueList',
					hScroll: false,
					scrollbarClass: 'AllScrollbar',
					});	
				this.FilterList = new iScroll('FilterList',  {
					snap: 'li',
					hScroll: false,
					scrollbarClass: 'AllScrollbar',
					onBeforeScrollStart: function (e) {
									var target = e.target;
									while (target.nodeType != 1) target = target.parentNode;
						
									if (target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA')
										e.preventDefault();
								},
					});	
				this.SidebarMenu = new iScroll('SidebarMenu', {
					snap: '.SidebarIcons, span',
					hScroll: false,
					fadeScrollbar: true,
					scrollbarClass: 'AllScrollbar',
					});	
				this.contentWrapper = new iScroll("contentWrapper", 
				 { 
					   snap: '.AlbumContainer, .Cell',
        			   momentum: true, 
					   hScroll: false,
					   scrollbarClass: 'AllScrollbar',
					   useTransform: false,
					   onBeforeScrollStart: function (e) {
									var target = e.target;
									while (target.nodeType != 1) target = target.parentNode;
						
									if (target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA')
										e.preventDefault();
								},
					   onScrollMove: function() {
						$('.AlbumContainerLink').addClass('disable');
						$('.Center.Bar').addClass('LogoColored');
					  	$(".nav li").removeClass("navDisplay");
						$('#ContentFilter').removeClass('ContentFilterVisibility');
					},	
					 onScrollEnd : function(){
						$('.AlbumContainerLink').removeClass('disable');
						$('.Center.Bar').removeClass('LogoColored');						
				   							 }
				});
				var header = $('#HeaderBar');
					$("#contentScroller").scroll(function(e){
						if(header.offset().top !== 0){
							if(!header.hasClass('shadow')){
								header.addClass('shadow');
							}
						}else{
							header.removeClass('shadow');
						}
				});
				$(".nav li , .closeNav").click(function () {
					  $(".nav li").toggleClass("navDisplay");
            	}); 
		}

//});