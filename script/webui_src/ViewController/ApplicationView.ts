/// <reference path="./WaveBoxView.ts"/>
/// <reference path="./SidebarMenuView.ts"/>
/// <reference path="./FolderListView.ts"/>
/// <reference path="./ArtistListView.ts"/>
/// <reference path="./AlbumListView.ts"/>
/// <reference path="./PlayQueueView.ts"/>
/// <reference path="../Model/ApiClient.ts"/>

module ViewController
{
    // This is the main application view controller. It is also the Event object used throughout the app for pub/sub events
    export class ApplicationView extends WaveBoxView
    {
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

            // Width test
            $("#HeaderBar").ready(this.resizeDiv);

            // Handle window resizing
            window.onresize = this.resizeDiv;

            // Setup main application button actions
            $(".MenuIcon").click(this.toggleMenu);
            $(".PlaylistIcon").click(this.togglePlayQueue);
            $(".FilterIcon").click(this.toggleFilter);

            // Not sure what these do
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
            //alert("showing folders");
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