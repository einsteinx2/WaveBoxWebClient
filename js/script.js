// JavaScript Document



				/* Prevent New Windows */
				var a=document.getElementsByTagName("a");
				for(var i=0;i<a.length;i++)
				{
					a[i].onclick=function()
					{
						window.location=this.getAttribute("href");
						return false
					}
				}


				/* Width Test */
				 $("#HeaderBar").ready(function(){
     			 resizeDiv();
 				 });

  				window.onresize = function(event) {
      			resizeDiv();
  				}

  				function resizeDiv() {
				muc = '124';
				sbw = '260';	
   			    vpw = $(window).width(); 
      			vph = $(window).height();
      			sdh = $("#QueueScroller").height();
	      		mbh = $("#SidebarMenuScroller").height();
	      		ctw = $("#contentWrapper").height();
	      		cts = $("#contentScroller").height();
      			$('#contentScroller').css({'width': vpw + 'px'});
      			$('#unclickableHeader').css({'width': vpw - muc  + 'px'});
      			$('#container').css({'height': vph  + 'px'});
      			$('#QueueScroller').css({'height': sdh  + 'px'});
				$('#ContentFilter').css({'width': vpw-30  + 'px'});
				$('.PlayerDisplay').css({'width': sbw-100  + 'px'});
				$('.ArtistPaddingList').css({'width': 'initial !important'});
				$('.ArtistPageBG').css({'background-size': vpw  + 'px'});
				$('.Cell').css({'width': vpw  + 'px'});
				
  				}
				
						
				//* Cell Shadow & Link Disable *//
	
				$(".FullCover").click(function(){
					$('.AlbumContainerLink').addClass('FullCover');
				  });

				
				$(".DirectoryViewIcon").click(function(){
					$('.AlbumContainerLink').addClass('AlbumMarginReset');
					$('div#ArtistLinks').addClass('ArtistPaddingList');
					$('.AlbumContainer').addClass('ItemsList');
					$('span.AlbumArtwork, .AlbumInfo').addClass('AlbumArtList');
					$('.AlbumTitle').addClass('ArtistLabelList');
					$('.AlbumTitle, .ArtistName').addClass('ArtistListClearMargin');
					$('#AlbumView').removeClass('AlbumViewContent');
				  });
				
								
				$(".AlbumSortIcon").click(function(){
					$('.AlbumContainerLink').removeClass('AlbumMarginReset');
					$('div#ArtistLinks').removeClass('ArtistPaddingList');
					$('.AlbumContainer').removeClass('ItemsList');
					$('span.AlbumArtwork, .AlbumInfo').removeClass('AlbumArtList');
					$('.AlbumTitle').removeClass('ArtistLabelList');
					$('.AlbumTitle, .ArtistName').removeClass('ArtistListClearMargin');
					$('#AlbumView').addClass('AlbumViewContent');
				  });

				/* Playlist Swipe */
				$("#contentWrapper").swiperight(function() {
					$('#content').css({'width': vpw - sbw  + 'px'});	
					$('#content, #contentWrapper').toggleClass('MenuMargin');
					$('#MenuColumn').toggleClass('displaySidebars');						
					$("#unclickable, #unclickableHeader").fadeIn(550); 
				  	$('.AlbumContainerLink').addClass('disable');
					$('#ContentFilter').removeClass('ContentFilterVisibility');
					$('#MiniPlayer').addClass('animate');
					$('#MiniPlayer').addClass('MiniPlayerLeftMargins');				  
				});
				
				/* Menu Swipe */
				$("#contentWrapper").swipeleft(function() {
					$('#content').css({'width': vpw - sbw  + 'px'});	
					$('#content, #contentWrapper').toggleClass('MenuMargin');
					$('#MenuColumn').toggleClass('displaySidebars');						
					$("#unclickable, #unclickableHeader").fadeIn(550); 
				  	$('.AlbumContainerLink').addClass('disable');
					$('#ContentFilter').removeClass('ContentFilterVisibility');
					$('#MiniPlayer').addClass('animate');
					$('#MiniPlayer').addClass('MiniPlayerLeftMargins');				  
				});	
				
				/* Playlist Swipe */
				$("#contentWrapper").swipeleft(function() {
						$('#content, #contentWrapper').toggleClass('PlaylistMargin');
						$('#MiniPlayer').addClass('animate');
						$('#MiniPlayer').addClass('MiniPlayerRightMargins');
						$('#Playlist, #QueueList').toggleClass('displaySidebars');						
						$("#unclickable, #unclickableHeader").fadeIn(550); 
						$('.AlbumContainerLink').addClass('disable');
						$('#ContentFilter').removeClass('ContentFilterVisibility');
				});
							

				$("#unclickable").swipe(function() {
						$('#content, #contentWrapper').removeClass('PlaylistMargin');
						$('#content, #contentWrapper').removeClass('FilterMargin');					
						$('#content, #contentWrapper').removeClass('MenuMargin');
						$('#MenuColumn, #Playlist, #QueueList, #Filter').delay(1000).removeClass('displaySidebars');						
						$("#unclickableHeader, #unclickable").fadeOut(); 					 
						$('.AlbumContainerLink').removeClass('disable');
						$('.HideBrowseOptions').addClass('DisplayNone');
						$("#HideBrowseOptions").removeClass('DisplayNone'); 
						$('#MiniPlayer').removeClass('MiniPlayerRightMargins');
						$('#MiniPlayer').removeClass('MiniPlayerLeftMargins');
						$('#MiniPlayer').removeClass('MiniPlayerFilterMargins');	
				});
				
				


				$(".MenuIcon").click(function(){
					$('#content').css({'width': vpw - sbw  + 'px'});	
					$('#content, #contentWrapper').toggleClass('MenuMargin');
					$('#MenuColumn').toggleClass('displaySidebars');						
					$("#unclickable, #unclickableHeader").fadeToggle(550); 
				  	$('.AlbumContainerLink').addClass('disable');
					$('#ContentFilter').removeClass('ContentFilterVisibility');
					$('#MiniPlayer').addClass('animate');
					$('#MiniPlayer').addClass('MiniPlayerLeftMargins');				  
				});


				
				$(".PlaylistIcon").click(function(){
					if ($('#content, #contentWrapper').hasClass('FilterMargin')) {
						$('#Filter, #FilterList').removeClass('displaySidebars');						
						$('#content, #contentWrapper').removeClass('FilterMargin');					
						$('#content').css({'width': vpw - sbw  + 'px'}, 100);
						$('#content, #contentWrapper').toggleClass('PlaylistMargin');
						$('#MiniPlayer').addClass('animate');
						$('#MiniPlayer').addClass('MiniPlayerRightMargins');
						$('#Playlist, #QueueList').toggleClass('displaySidebars');						
						$('.AlbumContainerLink').addClass('disable');
						$('#ContentFilter').removeClass('ContentFilterVisibility');
					}
					else {
						$('#content').css({'width': vpw - sbw  + 'px'});
						$('#content, #contentWrapper').toggleClass('PlaylistMargin');
						$('#MiniPlayer').addClass('animate');
						$('#MiniPlayer').addClass('MiniPlayerRightMargins');
						$('#Playlist, #QueueList').toggleClass('displaySidebars');						
						$("#unclickableHeader, #unclickable").fadeIn(); 					 
						$('.AlbumContainerLink').addClass('disable');
						$('#ContentFilter').removeClass('ContentFilterVisibility');
					}
				
				});
				
				  $(".FilterIcon").click(function(){
					if ($('#content, #contentWrapper').hasClass('PlaylistMargin')) {
						$('#content, #contentWrapper').removeClass('PlaylistMargin');
						$('#Playlist, #QueueList').removeClass('displaySidebars');						
						$('#content').css({'width': vpw - sbw  + 'px'});
						$('#MiniPlayer').addClass('animate');
						$('#MiniPlayer').addClass('MiniPlayerFilterMargins');				  
						$('#content, #contentWrapper').toggleClass('FilterMargin');
						$('#Filter, #FilterList').toggleClass('displaySidebars');						
						$('.AlbumContainerLink').addClass('disable');
						$('#ContentFilter').removeClass('ContentFilterVisibility');
					}
					else {
						$('#content').css({'width': vpw - sbw  + 'px'});
						$('#MiniPlayer').addClass('animate');
						$('#MiniPlayer').addClass('MiniPlayerFilterMargins');				  
						$('#content, #contentWrapper').toggleClass('FilterMargin');
						$('#Filter, #FilterList').toggleClass('displaySidebars');						
						$("#unclickableHeader, #unclickable").fadeIn(); 					 
						$('.AlbumContainerLink').addClass('disable');
						$('#ContentFilter').removeClass('ContentFilterVisibility');
					}
				
				});
				 

				  $(".SidebarIcons, .FilterSideBar, #unclickable, #unclickableHeader").click(function(){
					$('#content, #contentWrapper').removeClass('PlaylistMargin');
					$('#content, #contentWrapper').removeClass('FilterMargin');					
					$('#content, #contentWrapper').removeClass('MenuMargin');
					$('#MenuColumn, #Playlist, #QueueList, #Filter').delay(1000).removeClass('displaySidebars');						
					$("#unclickableHeader, #unclickable").fadeOut(); 					 
				  	$('.AlbumContainerLink').removeClass('disable');
					$('.HideBrowseOptions').addClass('DisplayNone');
					$("#HideBrowseOptions").removeClass('DisplayNone'); 
					$('#MiniPlayer').removeClass('MiniPlayerRightMargins');
					$('#MiniPlayer').removeClass('MiniPlayerLeftMargins');
					$('#MiniPlayer').removeClass('MiniPlayerFilterMargins');	
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
					checkDOMChanges: true,
					});	
				this.FilterList = new iScroll('FilterList',  {
					checkDOMChanges: true,
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
					checkDOMChanges: true,
					hScroll: false,
					fadeScrollbar: true,
					scrollbarClass: 'AllScrollbar',
					});	
				this.contentWrapper = new iScroll("contentWrapper",  
				 { 
					   snap: '.AlbumContainer, .Cell',
					   checkDOMChanges: true,
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










/******************************************* new *******************************************/
/******************************************* new *******************************************/
/******************************************* new *******************************************/
/******************************************* new *******************************************/
/******************************************* new *******************************************/
/******************************************* new *******************************************/





// Generated by CoffeeScript 1.4.0
(function() {
  var Clickbuster, FastButton, clickDistance, clickbusterDistance, clickbusterTimeout, debug, eventHandler;

  clickbusterDistance = 25;

  clickbusterTimeout = 2500;

  clickDistance = 10;

  if (window.debug == null) {
    debug = function(arg) {
      return console.log(arg);
    };
  }

  FastButton = (function() {

    function FastButton(selector, handler) {
      var handlers, that;
      this.selector = selector;
      this.handler = handler;
      if (!("ontouchstart" in window)) {
        return;
      }
      this.active = false;
      that = this;
      handlers = {
        touchstart: function(event) {
          return that.touchStart(event, this);
        },
        touchend: function(event) {
          return that.touchEnd(event, this);
        }
      };
      $(document).on(handlers, selector).on('touchmove', function() {
        return that.touchMove(event);
      });
    }

    FastButton.prototype.touchStart = function(event, element) {
      var touch;
      touch = event.originalEvent.touches[0];
      this.active = true;
      this.startX = touch.clientX;
      this.startY = touch.clientY;
      return event.stopPropagation();
    };

    FastButton.prototype.touchMove = function(event) {
      var dx, dy, touch;
      if (!this.active) {
        return;
      }
      touch = event.originalEvent.touches[0];
      dx = Math.abs(touch.clientX - this.startX);
      dy = Math.abs(touch.clientY - this.startY);
      if (dx > clickDistance || dy > clickDistance) {
        return this.active = false;
      }
    };

    FastButton.prototype.touchEnd = function(event, element) {
      if (!this.active) {
        return;
      }
      event.preventDefault();
      this.active = false;
      Clickbuster.preventGhostClick(this.startX, this.startY);
      return this.handler.call(element, event);
    };

    return FastButton;

  })();

  Clickbuster = (function() {

    function Clickbuster() {}

    Clickbuster.coordinates = [];

    Clickbuster.preventGhostClick = function(x, y) {
      Clickbuster.coordinates.push(x, y);
      return window.setTimeout(Clickbuster.pop, clickbusterTimeout);
    };

    Clickbuster.pop = function() {
      return Clickbuster.coordinates.splice(0, 2);
    };

    Clickbuster.onClick = function(event) {
      var coordinates, dx, dy, i, x, y;
      coordinates = Clickbuster.coordinates;
      i = 0;
      if (event.clientX == null) {
        return true;
      }
      window.ev = event;
      while (i < coordinates.length) {
        x = coordinates[i];
        y = coordinates[i + 1];
        dx = Math.abs(event.clientX - x);
        dy = Math.abs(event.clientY - y);
        i += 2;
        if (dx < clickbusterDistance && dy < clickbusterDistance) {
          return false;
        }
      }
      return true;
    };

    return Clickbuster;

  })();

  eventHandler = function(handleObj) {
    var origHandler;
    origHandler = handleObj.handler;
    return handleObj.handler = function(event) {
      if (!Clickbuster.onClick(event)) {
        return false;
      }
      return origHandler.apply(this, arguments);
    };
  };

  $.event.special.click = {
    add: eventHandler
  };

  $.event.special.submit = {
    add: eventHandler
  };

  $.fn.extend({
    fastButton: function(handler) {
      return $.fastButton(this.selector, handler);
    }
  });

  $.extend({
    fastButton: function(selector, handler) {
      return new FastButton(selector, handler);
    }
  });

  $.fastButton('.use-fastClick a[data-remote],\
   .use-fastClick .fastClick', function(ev) {
    $(this).trigger('click');
    return false;
  });

  $.fastButton('.use-fastClick a:not([data-remote]):not(.fastClick)', function(ev) {
    var $this, href, target;
    $this = $(this);
    target = $this.attr('target');
    href = $this.attr('href');
    if (target === void 0) {
      window.location = href;
    } else {
      window.open(href, target);
    }
    return false;
  });

  $.fastButton('.use-fastClick .submit,\
   .use-fastClick input[type="submit"],\
   .use-fastClick button[type="submit"]', function(ev) {
    $(this).closest('form').trigger('click');
    return false;
  });

  $.fastButton('.use-fastClick input[type="text"]', function(ev) {
    ev.preventDefault();
    $(this).trigger('focus');
    return false;
  });

}).call(this);





