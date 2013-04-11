var __extends = this.__extends || function (d, b) {
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var Model;
(function (Model) {
    var SidebarMenuItem = (function (_super) {
        __extends(SidebarMenuItem, _super);
        function SidebarMenuItem() {
            _super.apply(this, arguments);

        }
        SidebarMenuItem.prototype.defaults = function () {
            return {
                name: " ",
                image: " ",
                cssClass: " ",
                index: 0,
                enabled: true
            };
        };
        return SidebarMenuItem;
    })(Backbone.Model);
    Model.SidebarMenuItem = SidebarMenuItem;    
})(Model || (Model = {}));
var Model;
(function (Model) {
    var SidebarMenuSection = (function (_super) {
        __extends(SidebarMenuSection, _super);
        function SidebarMenuSection() {
            _super.apply(this, arguments);

            this.model = Model.SidebarMenuItem;
        }
        SidebarMenuSection.prototype.enabled = function () {
            return this.filter(function (item) {
                return item.get('enabled');
            });
        };
        SidebarMenuSection.prototype.comparator = function (item) {
            return item.get('index');
        };
        return SidebarMenuSection;
    })(Backbone.Collection);
    Model.SidebarMenuSection = SidebarMenuSection;    
})(Model || (Model = {}));
var ViewController;
(function (ViewController) {
    var SidebarMenuItemView = (function (_super) {
        __extends(SidebarMenuItemView, _super);
        function SidebarMenuItemView(options) {
            this.tagName = "li";
            this.events = {
                "click": "open"
            };
                _super.call(this, options);
        }
        SidebarMenuItemView.prototype.open = function () {
            app.trigger(this.model.get("action"));
        };
        SidebarMenuItemView.prototype.render = function () {
            this.$el.addClass("SidebarIcons");
            this.$el.addClass(this.model.get("cssClass"));
            this.$el.html('<a href="#">' + this.model.get("name") + '</a>');
            return this;
        };
        return SidebarMenuItemView;
    })(Backbone.View);
    ViewController.SidebarMenuItemView = SidebarMenuItemView;    
})(ViewController || (ViewController = {}));
var ViewController;
(function (ViewController) {
    var SidebarMenuView = (function (_super) {
        __extends(SidebarMenuView, _super);
        function SidebarMenuView() {
                _super.call(this);
            this.setElement($("#SidebarMenuContent"), true);
            this.headerSection = new Model.SidebarMenuSection([
                {
                    name: "HomePlex",
                    cssClass: "Cloud",
                    action: "show:server"
                }, 
                {
                    name: "",
                    cssClass: "Settings",
                    action: "show:settings"
                }
            ]);
            this.browseSection = new Model.SidebarMenuSection([
                {
                    name: "Music",
                    cssClass: "Music"
                }, 
                {
                    name: "Discover",
                    cssClass: "Discover"
                }, 
                {
                    name: "Artist",
                    cssClass: "Folder",
                    action: "show:artists"
                }, 
                {
                    name: "Folder",
                    cssClass: "Folder",
                    action: "show:folders"
                }
            ]);
            this.browseSection.name = "Browse";
            this.personalizeSection = new Model.SidebarMenuSection([
                {
                    name: "Favorite",
                    cssClass: "Favorite"
                }, 
                {
                    name: "Playlists",
                    cssClass: "Playlist"
                }, 
                {
                    name: "Morning Drive",
                    cssClass: "Playlist"
                }, 
                {
                    name: "Traffic Jams",
                    cssClass: "Playlist"
                }, 
                {
                    name: "Work Safe",
                    cssClass: "Playlist"
                }, 
                {
                    name: "Saturday's Party",
                    cssClass: "Playlist"
                }, 
                {
                    name: "Juke",
                    cssClass: "Juke"
                }
            ]);
            this.personalizeSection.name = "Personlize";
            this.settingsSection = new Model.SidebarMenuSection([
                {
                    name: "Offline",
                    cssClass: "Offline"
                }
            ]);
            this.settingsSection.name = "Settings";
            this.sections = [
                this.headerSection, 
                this.browseSection, 
                this.personalizeSection, 
                this.settingsSection
            ];
        }
        SidebarMenuView.prototype.render = function () {
            var _this = this;
            this.$el.empty();
            _.each(this.sections, function (section) {
                if(section.name !== undefined) {
                    _this.$el.append("<span>" + section.name + "</span>");
                }
                _.each(section.models, function (item) {
                    var itemView = new ViewController.SidebarMenuItemView({
                        model: item
                    });
                    _this.$el.append(itemView.render().el);
                });
            });
            return this;
        };
        return SidebarMenuView;
    })(Backbone.View);
    ViewController.SidebarMenuView = SidebarMenuView;    
})(ViewController || (ViewController = {}));
var ViewController;
(function (ViewController) {
    var FolderListView = (function (_super) {
        __extends(FolderListView, _super);
        function FolderListView() {
            _super.apply(this, arguments);

        }
        return FolderListView;
    })(Backbone.View);
    ViewController.FolderListView = FolderListView;    
})(ViewController || (ViewController = {}));
var Model;
(function (Model) {
    var Album = (function (_super) {
        __extends(Album, _super);
        function Album() {
            _super.apply(this, arguments);

        }
        return Album;
    })(Backbone.Model);
    Model.Album = Album;    
})(Model || (Model = {}));
var Collection;
(function (Collection) {
    var ArtistList = (function (_super) {
        __extends(ArtistList, _super);
        function ArtistList() {
            _super.apply(this, arguments);

            this.model = Model.Artist;
        }
        return ArtistList;
    })(Backbone.Collection);
    Collection.ArtistList = ArtistList;    
})(Collection || (Collection = {}));
var Model;
(function (Model) {
    var Artist = (function (_super) {
        __extends(Artist, _super);
        function Artist() {
            _super.apply(this, arguments);

        }
        return Artist;
    })(Backbone.Model);
    Model.Artist = Artist;    
})(Model || (Model = {}));
var ViewController;
(function (ViewController) {
    var ArtistView = (function (_super) {
        __extends(ArtistView, _super);
        function ArtistView(options) {
            this.tagName = "li";
                _super.call(this, options);
            this.template = _.template($('#AlbumView_cover-template').html());
        }
        ArtistView.prototype.render = function () {
            this.$el.addClass("AlbumContainer");
            this.$el.html(this.template(this.model.toJSON()));
            return this;
        };
        return ArtistView;
    })(Backbone.View);
    ViewController.ArtistView = ArtistView;    
})(ViewController || (ViewController = {}));
var ViewController;
(function (ViewController) {
    var ArtistListView = (function (_super) {
        __extends(ArtistListView, _super);
        function ArtistListView() {
            this.tagName = "ul";
                _super.call(this);
            this.displayType = "cover";
        }
        ArtistListView.prototype.render = function () {
            var _this = this;
            this.$el.empty();
            this.$el.attr("id", "ArtistView");
            this.artistList.each(function (artist) {
                var artistView = new ViewController.ArtistView({
                    model: artist
                });
                _this.$el.append(artistView.render().el);
            });
            return this;
        };
        return ArtistListView;
    })(Backbone.View);
    ViewController.ArtistListView = ArtistListView;    
})(ViewController || (ViewController = {}));
var Collection;
(function (Collection) {
    var AlbumList = (function (_super) {
        __extends(AlbumList, _super);
        function AlbumList() {
            _super.apply(this, arguments);

            this.model = Model.Album;
        }
        return AlbumList;
    })(Backbone.Collection);
    Collection.AlbumList = AlbumList;    
})(Collection || (Collection = {}));
var ViewController;
(function (ViewController) {
    var AlbumView = (function (_super) {
        __extends(AlbumView, _super);
        function AlbumView(options) {
            this.tagName = "li";
                _super.call(this, options);
            this.template = _.template($('#AlbumView_cover-template').html());
        }
        AlbumView.prototype.render = function () {
            this.$el.addClass("AlbumContainer");
            this.$el.html(this.template(this.model.toJSON()));
            return this;
        };
        return AlbumView;
    })(Backbone.View);
    ViewController.AlbumView = AlbumView;    
})(ViewController || (ViewController = {}));
var ViewController;
(function (ViewController) {
    var AlbumListView = (function (_super) {
        __extends(AlbumListView, _super);
        function AlbumListView() {
            this.tagName = "ul";
                _super.call(this);
            this.displayType = "cover";
        }
        AlbumListView.prototype.render = function () {
            var _this = this;
            this.$el.empty();
            this.$el.attr("id", "AlbumView");
            this.albumList.each(function (album) {
                var albumView = new ViewController.AlbumView({
                    model: album
                });
                _this.$el.append(albumView.render().el);
            });
            return this;
        };
        return AlbumListView;
    })(Backbone.View);
    ViewController.AlbumListView = AlbumListView;    
})(ViewController || (ViewController = {}));
var Model;
(function (Model) {
    var MediaItem = (function (_super) {
        __extends(MediaItem, _super);
        function MediaItem() {
            _super.apply(this, arguments);

        }
        MediaItem.prototype.formatDuration = function () {
            var minutes = Math.floor(this.duration / 60);
            var seconds = Math.floor(this.duration % 60);
            return minutes + ":" + seconds;
        };
        return MediaItem;
    })(Backbone.Model);
    Model.MediaItem = MediaItem;    
})(Model || (Model = {}));
var Model;
(function (Model) {
    var Song = (function (_super) {
        __extends(Song, _super);
        function Song() {
            _super.apply(this, arguments);

        }
        return Song;
    })(Model.MediaItem);
    Model.Song = Song;    
})(Model || (Model = {}));
var Collection;
(function (Collection) {
    var PlayQueueList = (function (_super) {
        __extends(PlayQueueList, _super);
        function PlayQueueList() {
            _super.apply(this, arguments);

            this.model = Model.Song;
        }
        return PlayQueueList;
    })(Backbone.Collection);
    Collection.PlayQueueList = PlayQueueList;    
})(Collection || (Collection = {}));
var ViewController;
(function (ViewController) {
    var PlayQueueItemView = (function (_super) {
        __extends(PlayQueueItemView, _super);
        function PlayQueueItemView(options) {
                _super.call(this, options);
            this.template = _.template($('#PlayQueueItemView-template').html());
        }
        PlayQueueItemView.prototype.render = function () {
            this.$el.addClass("QueueList");
            this.$el.html(this.template(this.model.toJSON()));
            return this;
        };
        return PlayQueueItemView;
    })(Backbone.View);
    ViewController.PlayQueueItemView = PlayQueueItemView;    
})(ViewController || (ViewController = {}));
var ViewController;
(function (ViewController) {
    var PlayQueueView = (function (_super) {
        __extends(PlayQueueView, _super);
        function PlayQueueView() {
                _super.call(this);
            this.setElement($("#QueueScroller"), true);
        }
        PlayQueueView.prototype.render = function () {
            var _this = this;
            this.$el.empty();
            this.playQueueList.each(function (item) {
                var itemView = new ViewController.PlayQueueItemView({
                    model: item
                });
                _this.$el.append(itemView.render().el);
            });
            return this;
        };
        return PlayQueueView;
    })(Backbone.View);
    ViewController.PlayQueueView = PlayQueueView;    
})(ViewController || (ViewController = {}));
var Model;
(function (Model) {
    var Utils = (function () {
        function Utils() { }
        Utils.isRetina = function isRetina() {
            return window.devicePixelRatio > 1 ? true : false;
        }
        return Utils;
    })();
    Model.Utils = Utils;    
})(Model || (Model = {}));
Array.prototype.shuffle = function () {
    var temp, j, i = 0;
    while(i < this.length) {
        this[i].preShuffleIndex = i;
        i++;
    }
    i = this.length;
    while(--i) {
        j = Math.floor(Math.random() * (i + 1));
        temp = this[i];
        this[i] = this[j];
        this[j] = temp;
        if(this.NowPlayingIndex === i) {
            this.NowPlayingIndex = j;
        } else {
            if(this.NowPlayingIndex === j) {
                this.NowPlayingIndex = i;
            }
        }
    }
    console.log("NowPlayingIndex is now: " + this.NowPlayingIndex);
    return this;
};
var Model;
(function (Model) {
    var ApiClient = (function () {
        function ApiClient() { }
        ApiClient.API_ADDRESS = "/api/";
        ApiClient.SESSION_ID = localStorage.getItem("waveBoxSessionKey");
        ApiClient.itemCache = [];
        ApiClient.cacheItem = function cacheItem(item) {
            this.itemCache[parseInt(item.itemId, 10)] = item;
        }
        ApiClient.getCachedItem = function getCachedItem(itemId) {
            return this.itemCache[parseInt(itemId, 10)];
        }
        ApiClient.logOut = function logOut() {
            localStorage.clear();
        }
        ApiClient.authenticate = function authenticate(username, password, context, callback) {
            var _this = this;
            console.log("Calling authenticate");
            $.ajax({
                url: this.API_ADDRESS + "login",
                data: "u=" + username + "&p=" + password,
                success: function (data) {
                    if(data.error === null) {
                        _this.SESSION_ID = data.sessionId;
                        console.log("sessionId: " + _this.SESSION_ID);
                        localStorage.setItem("waveBoxSessionKey", data.sessionId);
                        callback.call(context, true);
                    } else {
                        callback.call(context, false, data.error);
                    }
                },
                error: function (XHR, textStatus, errorThrown) {
                    console.log("authenticate failed error code: " + JSON.stringify(XHR));
                    callback(false);
                },
                async: true,
                type: 'POST'
            });
        }
        ApiClient.clientIsAuthenticated = function clientIsAuthenticated(callback) {
            if(this.SESSION_ID !== undefined) {
                console.log("Verifying sessionId");
                $.ajax({
                    url: this.API_ADDRESS + "status",
                    data: "s=" + this.SESSION_ID,
                    success: function (data) {
                        if(data.error === null) {
                            console.log("sessionId is valid");
                            callback(true);
                        } else {
                            console.log("sessionId is NOT valid, error: " + data.error);
                            callback(false, data.error);
                        }
                    },
                    error: function (XHR, textStatus, errorThrown) {
                        console.log("error checking session id: " + textStatus);
                        callback(false);
                    },
                    async: true,
                    type: 'POST'
                });
            } else {
                callback(false);
            }
        }
        ApiClient.getArtistList = function getArtistList() {
            var artists;
            $.ajax({
                url: this.API_ADDRESS + "artists",
                data: "s=" + this.SESSION_ID,
                success: function (data) {
                    artists = data.artists;
                },
                async: false,
                type: 'POST'
            });
            return artists;
        }
        ApiClient.getArtistInfo = function getArtistInfo(artistId) {
            var aId = "";
            if(artistId !== undefined) {
                aId = artistId;
            } else {
                console.log("artist id undefined");
                $.publish("data/getArtistInfoDone", [
                    undefined
                ]);
                return;
            }
            $.ajax({
                url: this.API_ADDRESS + "artists/",
                data: "s=" + this.SESSION_ID + "&id=" + aId,
                success: function (data) {
                    $.publish("data/getArtistInfoDone", [
                        data
                    ]);
                },
                async: true,
                type: 'POST'
            });
        }
        ApiClient.getSongList = function getSongList(id, forItemType) {
            var _this = this;
            var songs, sId = "", call = "albums", url, i;
            if(id === undefined || forItemType === undefined) {
                $.publish("data/getSongListDone", [
                    undefined
                ]);
                return;
            } else {
                if(forItemType === "songs") {
                    call = "songs";
                } else {
                    if(call !== "albums") {
                        $.publish("data/getSongListDone", [
                            undefined
                        ]);
                        return;
                    }
                }
                call += "/";
                sId = id;
            }
            url = this.API_ADDRESS + call;
            $.ajax({
                url: url,
                data: "s=" + this.SESSION_ID + "&id=" + sId,
                success: function (data) {
                    for(i = 0; i < data.songs.length; i++) {
                        _this.cacheItem(data.songs[i]);
                    }
                    $.publish("data/getSongListDone", [
                        data
                    ]);
                },
                async: true,
                type: 'POST'
            });
        }
        ApiClient.getFolder = function getFolder(folderId, recursive, callback) {
            var _this = this;
            var folder, url = this.API_ADDRESS + "folders", theData = "s=" + this.SESSION_ID, i;
            if(folderId !== undefined) {
                theData += "&id=" + folderId;
            }
            if(recursive === true) {
                theData += "&recursiveMedia=1";
            }
            $.ajax({
                url: this.API_ADDRESS + "folders",
                data: theData,
                success: function (data) {
                    if(data.songs !== undefined) {
                        for(i = 0; i < data.songs.length; i++) {
                            _this.cacheItem(data.songs[i]);
                        }
                    }
                    callback(true, data);
                },
                error: function (XHR, textStatus, errorThrown) {
                    callback(false);
                },
                async: true,
                type: 'POST'
            });
        }
        ApiClient.getSongInfo = function getSongInfo(songId) {
            var _this = this;
            var song, cached, url;
            if(songId === undefined) {
                return;
            } else {
                cached = this.getCachedItem(songId);
                if(cached !== undefined) {
                    $.publish("data/getSongInfoDone", [
                        cached
                    ]);
                    return;
                }
            }
            url = this.API_ADDRESS + "songs";
            $.ajax({
                url: url,
                data: "s=" + this.SESSION_ID + "&id=" + songId,
                success: function (data) {
                    _this.cacheItem(data.songs[0]);
                    $.publish("data/getSongInfoDone", [
                        data.songs[0]
                    ]);
                },
                async: false,
                type: 'POST'
            });
        }
        ApiClient.getSongStreamUrl = function getSongStreamUrl(songId) {
            return this.API_ADDRESS + "stream" + "?" + "s=" + this.SESSION_ID + "&id=" + songId;
        }
        ApiClient.getSongUrlObject = function getSongUrlObject(song) {
            var urlObj = {
            };
            if(song.fileType === 2) {
                urlObj["mp3"] = this.API_ADDRESS + "stream" + "?" + "s=" + this.SESSION_ID + "&id=" + song.itemId;
            } else {
                urlObj["mp3"] = this.API_ADDRESS + "transcode?" + "s=" + this.SESSION_ID + "&id=" + song.itemId + "&transType=" + "MP3" + "&transQuality=" + "medium";
            }
            if(song.fileType === 4) {
                urlObj["oga"] = this.API_ADDRESS + "stream" + "?" + "s=" + this.SESSION_ID + "&id=" + song.itemId;
            } else {
                urlObj["oga"] = this.API_ADDRESS + "transcode?" + "s=" + this.SESSION_ID + "&id=" + song.itemId + "&transType=" + "OGG" + "&transQuality=" + "medium";
            }
            console.log(urlObj);
            return urlObj;
        }
        ApiClient.getSongArtUrl = function getSongArtUrl(song, size) {
            var url = this.API_ADDRESS + "art" + "?" + "id=" + song.artId + "&" + "s=" + this.SESSION_ID, useSize;
            if(size !== undefined) {
                useSize = size;
                if(Model.Utils.isRetina()) {
                    useSize = parseFloat(size) * 2;
                }
                url += "&size=" + useSize;
            }
            return url;
        }
        ApiClient.lfmUpdateNowPlaying = function lfmUpdateNowPlaying(songId) {
            var url = this.API_ADDRESS + "scrobble";
            $.ajax({
                url: url,
                data: "s=" + this.SESSION_ID + "&id=" + songId + "&action=nowplaying",
                success: function (data) {
                    if(data.error === null) {
                        console.log("Now playing update successful");
                    } else {
                        if(data.error === "LFMNotAuthenticated") {
                            window.open(data.authUrl);
                        } else {
                            console.log(data.error);
                        }
                    }
                },
                async: true,
                type: 'POST'
            });
        }
        ApiClient.lfmScrobbleTrack = function lfmScrobbleTrack(song, timestamp) {
            var url = this.API_ADDRESS + "scrobble";
            $.ajax({
                url: url,
                data: "s=" + this.SESSION_ID + "&event=" + song.itemId + "," + timestamp + "&action=submit",
                success: function (data) {
                    if(data.error === null) {
                        console.log("Scrobble successful (" + song.songName + ")");
                    } else {
                        if(data.error === "LFMNotAuthenticated") {
                            window.open(data.authUrl);
                        } else {
                            console.log(data.error);
                        }
                    }
                },
                async: true,
                type: 'POST'
            });
        }
        return ApiClient;
    })();
    Model.ApiClient = ApiClient;    
})(Model || (Model = {}));
var ViewController;
(function (ViewController) {
    var ApplicationView = (function (_super) {
        __extends(ApplicationView, _super);
        function ApplicationView() {
                _super.call(this);
            this.createInterface();
            this.authenticate();
        }
        ApplicationView.prototype.authenticate = function () {
            Model.ApiClient.authenticate("test", "test", this, function (success, error) {
                if(success) {
                    console.log("[ApplicationView] Successful login!");
                    this.showAlbums();
                } else {
                    console.log("[ApplicationView] Login error: " + error);
                }
            });
        };
        ApplicationView.prototype.createInterface = function () {
            $("#HeaderBar").ready(this.resizeDiv);
            window.onresize = this.resizeDiv;
            $(".MenuIcon").click(this.toggleMenu);
            $(".PlaylistIcon").click(this.togglePlayQueue);
            $(".FilterIcon").click(this.toggleFilter);
            $(".SidebarIcons, .FilterSideBar, #unclickable, #unclickableHeader").click(function () {
                $('#content, #contentWrapper').removeClass('PlaylistMargin');
                $('#content, #contentWrapper').removeClass('FilterMargin');
                $('#content, #contentWrapper').removeClass('MenuMargin');
                $('#MenuColumn, #Playlist, #QueueList, #Filter').delay(1000).removeClass('displaySidebars');
                $("#unclickableHeader, #unclickable").fadeToggle();
                $('.AlbumContainerLink').removeClass('disable');
                $('.HideBrowseOptions').addClass('DisplayNone');
                $("#HideBrowseOptions").removeClass('DisplayNone');
            });
            $("#HideBrowseOptions").click(function () {
                $("#HideBrowseOptions").addClass('DisplayNone');
                $('.HideBrowseOptions').removeClass('DisplayNone');
            });
            this.handleMobile();
            this.sidebarMenu = new ViewController.SidebarMenuView();
            this.sidebarMenu.render();
            this.isMenuShowing = false;
            this.playQueue = new ViewController.PlayQueueView();
            var items = new Array(20);
            for(var i = 0; i < 20; i++) {
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
            this.on("show:folders", this.showFolders, this);
            this.on("show:artists", this.showArtists, this);
            this.on("show:albums", this.showAlbums, this);
        };
        ApplicationView.prototype.resizeDiv = function () {
            muc = '124';
            sbw = '220';
            vpw = $(window).width();
            vph = $(window).height();
            sdh = $("#QueueScroller").height();
            mbh = $("#SidebarMenuScroller").height();
            $('#contentScroller').css({
                'width': vpw + 'px'
            });
            $('#unclickableHeader').css({
                'width': vpw - muc + 'px'
            });
            $('#QueueScroller, #').css({
                'height': sdh + 'px'
            });
            $('#ContentFilter').css({
                'width': vpw - 30 + 'px'
            });
        };
        ApplicationView.prototype.showMenu = function () {
            if(!this.isMenuShowing) {
                this.toggleMenu();
            }
        };
        ApplicationView.prototype.hideMenu = function () {
            if(this.isMenuShowing) {
                this.toggleMenu();
            }
        };
        ApplicationView.prototype.toggleMenu = function () {
            $('#content').css({
                'width': vpw - sbw + 'px'
            });
            $('#content, #contentWrapper').toggleClass('MenuMargin');
            $('#MenuColumn').toggleClass('displaySidebars');
            $("#unclickable, #unclickableHeader").fadeToggle(550);
            $('.AlbumContainerLink').addClass('disable');
            $('#ContentFilter').removeClass('ContentFilterVisibility');
            this.isMenuShowing = !this.isMenuShowing;
        };
        ApplicationView.prototype.hidePlayQueue = function () {
            if(this.isPlayQueueShowing) {
                this.togglePlayQueue();
            }
        };
        ApplicationView.prototype.showPlayQueue = function () {
            if(!this.isPlayQueueShowing) {
                this.togglePlayQueue();
            }
        };
        ApplicationView.prototype.togglePlayQueue = function () {
            $('#content').css({
                'width': vpw - sbw + 'px'
            });
            $('#content, #contentWrapper').toggleClass('PlaylistMargin');
            $('#Playlist, #QueueList').toggleClass('displaySidebars');
            $("#unclickableHeader, #unclickable").fadeToggle();
            $('.AlbumContainerLink').addClass('disable');
            $('#ContentFilter').removeClass('ContentFilterVisibility');
            this.isPlayQueueShowing = !this.isPlayQueueShowing;
        };
        ApplicationView.prototype.hideFilter = function () {
            if(this.isFilterShowing) {
                this.toggleFilter();
            }
        };
        ApplicationView.prototype.showFilter = function () {
            if(!this.isFilterShowing) {
                this.toggleFilter();
            }
        };
        ApplicationView.prototype.toggleFilter = function () {
            $('#content').css({
                'width': vpw - sbw + 'px'
            });
            $('#content, #contentWrapper').toggleClass('FilterMargin');
            $('#Filter, #FilterList').toggleClass('displaySidebars');
            $("#unclickableHeader, #unclickable").fadeToggle();
            $('.AlbumContainerLink').addClass('disable');
            $('#ContentFilter').removeClass('ContentFilterVisibility');
        };
        ApplicationView.prototype.showFolders = function () {
            this.hideMenu();
        };
        ApplicationView.prototype.showArtists = function () {
            this.hideMenu();
        };
        ApplicationView.prototype.showAlbums = function () {
            if(!this.albumList) {
                this.albumList = new ViewController.AlbumListView();
                var albums = new Array(30);
                for(var i = 1; i < 31; i++) {
                    albums[i - 1] = {
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
        };
        ApplicationView.prototype.handleMobile = function () {
            if(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)) {
                var header = $('.Cell');
                $("#contentWrapper").scroll(function (e) {
                    if(header.offset().top !== 0) {
                        if(!header.hasClass('shadow')) {
                            header.addClass('shadow');
                        }
                    } else {
                        header.removeClass('shadow');
                    }
                });
                var contentWrapper, queueList, filterList, sidebarMenu;
                queueList = new iScroll('QueueList', {
                    snap: '.QueueList',
                    hScroll: false,
                    scrollbarClass: 'AllScrollbar'
                });
                filterList = new iScroll('FilterList', {
                    snap: 'li',
                    hScroll: false,
                    scrollbarClass: 'AllScrollbar',
                    onBeforeScrollStart: function (e) {
                        var target = e.target;
                        while(target.nodeType != 1) {
                            target = target.parentNode;
                        }
                        if(target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA') {
                            e.preventDefault();
                        }
                    }
                });
                sidebarMenu = new iScroll('SidebarMenu', {
                    snap: '.SidebarIcons, span',
                    hScroll: false,
                    fadeScrollbar: true,
                    scrollbarClass: 'AllScrollbar'
                });
                contentWrapper = new iScroll("contentWrapper", {
                    snap: '.AlbumContainer, .Cell',
                    momentum: true,
                    hScroll: false,
                    scrollbarClass: 'AllScrollbar',
                    useTransform: false,
                    onBeforeScrollStart: function (e) {
                        var target = e.target;
                        while(target.nodeType != 1) {
                            target = target.parentNode;
                        }
                        if(target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA') {
                            e.preventDefault();
                        }
                    },
                    onScrollMove: function () {
                        $('.AlbumContainerLink').addClass('disable');
                        $('.Center.Bar').addClass('LogoColored');
                        $(".nav li").removeClass("navDisplay");
                        $('#ContentFilter').removeClass('ContentFilterVisibility');
                    },
                    onScrollEnd: function () {
                        $('.AlbumContainerLink').removeClass('disable');
                        $('.Center.Bar').removeClass('LogoColored');
                    }
                });
                var header = $('#HeaderBar');
                $("#contentScroller").scroll(function (e) {
                    if(header.offset().top !== 0) {
                        if(!header.hasClass('shadow')) {
                            header.addClass('shadow');
                        }
                    } else {
                        header.removeClass('shadow');
                    }
                });
                $(".nav li , .closeNav").click(function () {
                    $(".nav li").toggleClass("navDisplay");
                });
            }
        };
        return ApplicationView;
    })(Backbone.View);
    ViewController.ApplicationView = ApplicationView;    
})(ViewController || (ViewController = {}));
var muc;
var sbw;
var vpw;
var vph;
var sdh;
var mbh;
var app;
$(function () {
    app = new ViewController.ApplicationView();
});
