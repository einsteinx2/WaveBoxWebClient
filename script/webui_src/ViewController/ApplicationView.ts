/// <reference path="./WaveBoxView.ts"/>
/// <reference path="./SidebarMenuView.ts"/>
/// <reference path="./FolderListView.ts"/>
/// <reference path="./ArtistListView.ts"/>
/// <reference path="./AlbumListView.ts"/>
/// <reference path="./PlayQueueView.ts"/>
/// <reference path="../Model/ApiClient.ts"/>
/// <reference path="../WaveBoxRouter.ts"/>

module ViewController
{
    // This is the main application view controller. It is also the Event object used throughout the app for pub/sub events
    export class ApplicationView extends WaveBoxView
    {
        router;
    	sidebarMenu: SidebarMenuView;
        folderList: FolderListView;
        artistList: ArtistListView;
    	albumList: AlbumListView;
        playQueue: PlayQueueView;

        isMenuShowing: bool;
        isPlayQueueShowing: bool;
        isFilterShowing: bool;

    	constructor(options?)
    	{
            super();

            this.createInterface();
            this.authenticate();
            this.router = new Router.WaveBoxRouter();
        }

        authenticate()
        {
            Model.ApiClient.authenticate("test", "test", this, function(success, error) {
                if (success)
                {
                    console.log("[ApplicationView] Successful login!");

                    // Create the album list with some test data
                    this.showArtists();
                }
                else
                {
                    console.log("[ApplicationView] Login error: " + error);
                }
            });
        }

        createInterface()
        {
            console.log("create interface");

            /* Prevent New Windows */
                var a=document.getElementsByTagName("a");
                for(var i=0; i < a.length; i++)
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
                    QueueList = new iScroll('QueueList',  {
                        snap: '.QueueList',
                        hScroll: false,
                        scrollbarClass: 'AllScrollbar',
                        checkDOMChanges: true,
                        }); 
                    FilterList = new iScroll('FilterList',  {
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
                    SidebarMenu = new iScroll('SidebarMenu', {
                        snap: '.SidebarIcons, span',
                        checkDOMChanges: true,
                        hScroll: false,
                        fadeScrollbar: true,
                        scrollbarClass: 'AllScrollbar',
                        }); 
                    contentWrapper = new iScroll("contentWrapper",  
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

            // Enabled iScroll if this is mobile
            this.handleMobile();

            // Create the left side menu
            this.sidebarMenu = new SidebarMenuView();
            this.sidebarMenu.render();
            this.isMenuShowing = false;

            // Create the right side play queue with some test data
            this.playQueue = new PlayQueueView();
            var items = new Array(20);
            for (var i = 0; i < 20; i++)
            {
                items[i] = {
                    songName: "Test Song " + i,
                    artistName: "Test Artist " + i,
                    albumName: "Test Album " + i,
                    duration: i
                };
            }
            this.playQueue.playQueueList = new Collection.PlayQueueList(items);
            this.playQueue.render();
            this.isPlayQueueShowing = false;

            // Bind to events (pub/sub)
            this.on("show:folders", this.showFolders, this);
            this.on("show:artists", this.showArtists, this);
            this.on("show:albums", this.showAlbums, this);
        }

        resizeDiv() 
        {
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

        showMenu()
        {
            if (!this.isMenuShowing)
            {
                this.toggleMenu();
            }
        }

        hideMenu()
        {
            console.log("hideMenu called, isMenuShowing: " + this.isMenuShowing);
            if (this.isMenuShowing)
            {
                this.toggleMenu();
            }
        }

        toggleMenu()
        {
            console.log("toggle menu, isMenuShowing: " + this.isMenuShowing);
            $('#content').css({'width': vpw - sbw  + 'px'});    
            $('#content, #contentWrapper').toggleClass('MenuMargin');
            $('#MenuColumn').toggleClass('displaySidebars');                        
            $("#unclickable, #unclickableHeader").fadeToggle(550); 
            $('.AlbumContainerLink').addClass('disable');
            $('#ContentFilter').removeClass('ContentFilterVisibility');
            this.isMenuShowing = !this.isMenuShowing;
            console.log("toggle menu, isMenuShowing: " + this.isMenuShowing);
        }

        hidePlayQueue()
        {
            if (this.isPlayQueueShowing)
            {
                this.togglePlayQueue();
            }
        }

        showPlayQueue()
        {
            if (!this.isPlayQueueShowing)
            {
                this.togglePlayQueue();
            }
        }

        togglePlayQueue()
        {
            $('#content').css({'width': vpw - sbw  + 'px'});
            $('#content, #contentWrapper').toggleClass('PlaylistMargin');
            $('#Playlist, #QueueList').toggleClass('displaySidebars');                      
            $("#unclickableHeader, #unclickable").fadeToggle();                      
            $('.AlbumContainerLink').addClass('disable');
            $('#ContentFilter').removeClass('ContentFilterVisibility');
            this.isPlayQueueShowing = !this.isPlayQueueShowing;
        }

        hideFilter()
        {
            if (this.isFilterShowing)
            {
                this.toggleFilter();
            }
        }

        showFilter()
        {
            if (!this.isFilterShowing)
            {
                this.toggleFilter();
            }
        }

        toggleFilter()
        {
            $('#content').css({'width': vpw - sbw  + 'px'});
            $('#content, #contentWrapper').toggleClass('FilterMargin');
            $('#Filter, #FilterList').toggleClass('displaySidebars');                       
            $("#unclickableHeader, #unclickable").fadeToggle();                      
            $('.AlbumContainerLink').addClass('disable');
            $('#ContentFilter').removeClass('ContentFilterVisibility');
        }

        showFolders()
        {

            alert("showing folders");
            if (!this.folderList)
            {
                this.folderList = new FolderListView();
            }

            this.folderList.render();
            this.hideMenu();
        }

        showArtists()
        {
            if (!this.artistList)
            {
                this.artistList = new ArtistListView();
            }
            
            this.artistList.render();
            this.hideMenu();
        }

        showAlbums()
        {
            if (!this.albumList)
            {
                this.albumList = new AlbumListView();
                var albums = new Array(30);
                for (var i = 1; i < 31; i++)
                {
                    albums[i-1] = {
                        artistId: i, 
                        artistName: "Test Artist " + i,
                        albumId: i,
                        albumName: "Test Album " + i,
                        releaseYear: 2013,
                        artId: i,
                        artUrl: "art/" + i + ".jpg",
                        numberOfSongs: i
                    };
                }
                this.albumList.albumList = new Collection.AlbumList(albums);
            }
            
            $("#contentMainArea").empty();
            $("#contentMainArea").append(this.albumList.render().el);

            this.hideMenu();
        }

        handleMobile()
        {
            if(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)) 
            {
                // Cell Shadow & Link Disable
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
                var contentWrapper, queueList, filterList, sidebarMenu;
                queueList = new iScroll('QueueList',  {
                    snap: '.QueueList',
                    hScroll: false,
                    scrollbarClass: 'AllScrollbar',
                    }); 
                filterList = new iScroll('FilterList',  {
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
                sidebarMenu = new iScroll('SidebarMenu', {
                    snap: '.SidebarIcons, span',
                    hScroll: false,
                    fadeScrollbar: true,
                    scrollbarClass: 'AllScrollbar',
                    }); 
                contentWrapper = new iScroll("contentWrapper", 
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
        }
    }
}