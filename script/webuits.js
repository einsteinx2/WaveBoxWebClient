var __extends = this.__extends || function (d, b) {
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var ViewController;
(function (ViewController) {
    var WaveBoxView = (function (_super) {
        __extends(WaveBoxView, _super);
        function WaveBoxView(options) {
                _super.call(this, options);
            this.parentView = this.options.parentView;
            _.bindAll(this);
        }
        WaveBoxView.prototype.appendToParent = function () {
            this.parentView.$el.append(this.el);
        };
        return WaveBoxView;
    })(Backbone.View);
    ViewController.WaveBoxView = WaveBoxView;    
})(ViewController || (ViewController = {}));
var Model;
(function (Model) {
    var WaveBoxModel = (function (_super) {
        __extends(WaveBoxModel, _super);
        function WaveBoxModel(attr, opts) {
            if(opts !== undefined && opts !== null) {
                this.options = opts;
            }
                _super.call(this, attr, opts);
        }
        return WaveBoxModel;
    })(Backbone.Model);
    Model.WaveBoxModel = WaveBoxModel;    
})(Model || (Model = {}));
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
    })(Model.WaveBoxModel);
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
    })(ViewController.WaveBoxView);
    ViewController.SidebarMenuItemView = SidebarMenuItemView;    
})(ViewController || (ViewController = {}));
var ViewController;
(function (ViewController) {
    var SidebarMenuView = (function (_super) {
        __extends(SidebarMenuView, _super);
        function SidebarMenuView(options) {
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
                    cssClass: "Music",
                    action: "show:albums"
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
    })(ViewController.WaveBoxView);
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
    })(ViewController.WaveBoxView);
    ViewController.FolderListView = FolderListView;    
})(ViewController || (ViewController = {}));
var Collection;
(function (Collection) {
    var WaveBoxCollection = (function (_super) {
        __extends(WaveBoxCollection, _super);
        function WaveBoxCollection(models, opts) {
            if(opts !== undefined && opts !== null) {
                this.options = opts;
            }
                _super.call(this, models, opts);
        }
        return WaveBoxCollection;
    })(Backbone.Collection);
    Collection.WaveBoxCollection = WaveBoxCollection;    
})(Collection || (Collection = {}));
var Model;
(function (Model) {
    var Album = (function (_super) {
        __extends(Album, _super);
        function Album() {
            _super.apply(this, arguments);

        }
        Album.prototype.defaults = function () {
            return {
                itemTypeId: 2,
                artistId: 0,
                artistName: "",
                albumId: 0,
                albumName: "",
                releaseYear: 0,
                artId: 0,
                artUrl: "",
                numberOfSongs: 0
            };
        };
        return Album;
    })(Model.WaveBoxModel);
    Model.Album = Album;    
})(Model || (Model = {}));
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
        ApiClient.getArtistList = function getArtistList(context, callback) {
            $.ajax({
                url: this.API_ADDRESS + "artists",
                data: "s=" + this.SESSION_ID,
                success: function (data) {
                    if(data.error === null) {
                        callback.call(context, true, data.artists);
                    } else {
                        callback.call(context, false, data.error);
                    }
                },
                async: true,
                type: 'POST'
            });
        }
        ApiClient.getArtistAlbums = function getArtistAlbums(artistId, context, callback) {
            if(artistId === undefined) {
                callback.call(context, false, "artistId missing");
                return;
            }
            $.ajax({
                url: this.API_ADDRESS + "artists/",
                data: "s=" + this.SESSION_ID + "&id=" + artistId,
                success: function (data) {
                    if(data.error === null) {
                        callback.call(context, true, data.albums);
                    } else {
                        callback.call(context, false, data.error);
                    }
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
            return ApiClient.getArtUrl(song.artId, size);
        }
        ApiClient.getArtUrl = function getArtUrl(artId, size) {
            var url = this.API_ADDRESS + "art" + "?" + "id=" + artId + "&" + "s=" + this.SESSION_ID, useSize;
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
var Collection;
(function (Collection) {
    var ArtistList = (function (_super) {
        __extends(ArtistList, _super);
        function ArtistList() {
            _super.apply(this, arguments);

            this.model = Model.Artist;
        }
        ArtistList.prototype.sync = function (method, model, options) {
            switch(method) {
                case 'create': {
                    break;

                }
                case 'update': {
                    break;

                }
                case 'delete': {
                    break;

                }
                case 'read': {
                    Model.ApiClient.getArtistList(this, function (success, data) {
                        console.log("success: " + success + "  data: " + JSON.stringify(data));
                        if(success) {
                            options.success(data);
                        } else {
                            options.error(data);
                        }
                    });
                    break;

                }
                default: {
                    console.error('Unknown method:', method);
                    break;

                }
            }
        };
        ArtistList.prototype.parse = function (response, options) {
            console.log("parse called, response: " + JSON.stringify(response));
            return response;
        };
        return ArtistList;
    })(Collection.WaveBoxCollection);
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
    })(Model.WaveBoxModel);
    Model.Artist = Artist;    
})(Model || (Model = {}));
var Collection;
(function (Collection) {
    var ArtistAlbumList = (function (_super) {
        __extends(ArtistAlbumList, _super);
        function ArtistAlbumList() {
            _super.apply(this, arguments);

            this.model = Model.Album;
        }
        ArtistAlbumList.prototype.sync = function (method, model, options) {
            console.log("options: " + JSON.stringify(this.options));
            switch(method) {
                case 'create': {
                    break;

                }
                case 'update': {
                    break;

                }
                case 'delete': {
                    break;

                }
                case 'read': {
                    Model.ApiClient.getArtistAlbums(this.options.artistId, this, function (success, data) {
                        console.log("success: " + success + "  data: " + JSON.stringify(data));
                        if(success) {
                            options.success(data);
                        } else {
                            options.error(data);
                        }
                    });
                    break;

                }
                default: {
                    console.error('Unknown method:', method);
                    break;

                }
            }
        };
        ArtistAlbumList.prototype.parse = function (response, options) {
            console.log("parse called, response: " + JSON.stringify(response));
            return response;
        };
        return ArtistAlbumList;
    })(Collection.WaveBoxCollection);
    Collection.ArtistAlbumList = ArtistAlbumList;    
})(Collection || (Collection = {}));
var ViewController;
(function (ViewController) {
    var AlbumItemView = (function (_super) {
        __extends(AlbumItemView, _super);
        function AlbumItemView(options) {
            this.tagName = "li";
                _super.call(this, options);
            this.template = _.template($('#AlbumView_cover-template').html());
        }
        AlbumItemView.prototype.render = function () {
            this.appendToParent();
            this.$el.addClass("AlbumContainer");
            this.$el.html(this.template(this.model.toJSON()));
            return this;
        };
        return AlbumItemView;
    })(ViewController.WaveBoxView);
    ViewController.AlbumItemView = AlbumItemView;    
})(ViewController || (ViewController = {}));
var ViewController;
(function (ViewController) {
    var ArtistView = (function (_super) {
        __extends(ArtistView, _super);
        function ArtistView(options) {
            this.tagName = "ul";
                _super.call(this, options);
            this.displayType = "cover";
            console.log("options.artistId: " + this.options.artistId);
            this.artistAlbumList = new Collection.ArtistAlbumList([], this.options);
            this.artistAlbumList.on("change", this.render, this);
            this.artistAlbumList.fetch({
                success: this.fetchSuccess
            });
        }
        ArtistView.prototype.fetchSuccess = function () {
            console.log(this.artistAlbumList.models);
            this.render();
        };
        ArtistView.prototype.render = function () {
            var _this = this;
            console.log("ArtistView render called");
            this.$el.empty();
            $("#contentMainArea").empty();
            $("#contentMainArea").append(this.el);
            this.$el.attr("id", "AlbumView");
            this.artistAlbumList.each(function (album) {
                var albumView = new ViewController.AlbumItemView({
                    parentView: _this,
                    model: album
                });
                _this.$el.append(albumView.render().el);
            });
            return this;
        };
        return ArtistView;
    })(ViewController.WaveBoxView);
    ViewController.ArtistView = ArtistView;    
})(ViewController || (ViewController = {}));
var ViewController;
(function (ViewController) {
    var ArtistItemView = (function (_super) {
        __extends(ArtistItemView, _super);
        function ArtistItemView(options) {
            this.tagName = "li";
            this.events = {
                "click": "open"
            };
                _super.call(this, options);
            this.template = _.template($('#ArtistView_cover-template').html());
        }
        ArtistItemView.prototype.open = function () {
            console.log("artist item view clicked, artistId = " + this.model.get("artistId"));
            var view = new ViewController.ArtistView({
                "artistId": this.model.get("artistId")
            });
            view.render();
        };
        ArtistItemView.prototype.render = function () {
            this.appendToParent();
            this.$el.addClass("AlbumContainer");
            this.$el.html(this.template(this.model.toJSON()));
            return this;
        };
        return ArtistItemView;
    })(ViewController.WaveBoxView);
    ViewController.ArtistItemView = ArtistItemView;    
})(ViewController || (ViewController = {}));
var ViewController;
(function (ViewController) {
    var ArtistListView = (function (_super) {
        __extends(ArtistListView, _super);
        function ArtistListView(options) {
            this.tagName = "ul";
                _super.call(this);
            this.displayType = "cover";
            this.artistList = new Collection.ArtistList();
            this.artistList.on("change", this.render, this);
            this.artistList.fetch({
                success: this.fetchSuccess
            });
        }
        ArtistListView.prototype.fetchSuccess = function () {
            console.log(this.artistList.models);
            this.render();
        };
        ArtistListView.prototype.render = function () {
            var _this = this;
            this.$el.empty();
            $("#contentMainArea").empty();
            $("#contentMainArea").append(this.el);
            this.$el.attr("id", "AlbumView");
            this.artistList.each(function (artist) {
                var artistView = new ViewController.ArtistItemView({
                    parentView: _this,
                    model: artist
                });
                artistView.render();
            });
            return this;
        };
        return ArtistListView;
    })(ViewController.WaveBoxView);
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
    })(Collection.WaveBoxCollection);
    Collection.AlbumList = AlbumList;    
})(Collection || (Collection = {}));
var ViewController;
(function (ViewController) {
    var AlbumListView = (function (_super) {
        __extends(AlbumListView, _super);
        function AlbumListView(options) {
            this.tagName = "ul";
                _super.call(this);
            this.displayType = "cover";
        }
        AlbumListView.prototype.render = function () {
            var _this = this;
            this.$el.empty();
            this.$el.attr("id", "AlbumView");
            this.albumList.each(function (album) {
                var albumView = new ViewController.AlbumItemView({
                    model: album
                });
                _this.$el.append(albumView.render().el);
            });
            return this;
        };
        return AlbumListView;
    })(ViewController.WaveBoxView);
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
    })(Model.WaveBoxModel);
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
    })(Collection.WaveBoxCollection);
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
    })(ViewController.WaveBoxView);
    ViewController.PlayQueueItemView = PlayQueueItemView;    
})(ViewController || (ViewController = {}));
var ViewController;
(function (ViewController) {
    var PlayQueueView = (function (_super) {
        __extends(PlayQueueView, _super);
        function PlayQueueView(options) {
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
    })(ViewController.WaveBoxView);
    ViewController.PlayQueueView = PlayQueueView;    
})(ViewController || (ViewController = {}));
var ViewController;
(function (ViewController) {
    var ApplicationView = (function (_super) {
        __extends(ApplicationView, _super);
        function ApplicationView(options) {
                _super.call(this);
            this.createInterface();
            this.authenticate();
        }
        ApplicationView.prototype.authenticate = function () {
            Model.ApiClient.authenticate("test", "test", this, function (success, error) {
                if(success) {
                    console.log("[ApplicationView] Successful login!");
                    this.showArtists();
                } else {
                    console.log("[ApplicationView] Login error: " + error);
                }
            });
        };
        ApplicationView.prototype.createInterface = function () {
            console.log("create interface");
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
            console.log("hideMenu called, isMenuShowing: " + this.isMenuShowing);
            if(this.isMenuShowing) {
                this.toggleMenu();
            }
        };
        ApplicationView.prototype.toggleMenu = function () {
            console.log("toggle menu, isMenuShowing: " + this.isMenuShowing);
            $('#content').css({
                'width': vpw - sbw + 'px'
            });
            $('#content, #contentWrapper').toggleClass('MenuMargin');
            $('#MenuColumn').toggleClass('displaySidebars');
            $("#unclickable, #unclickableHeader").fadeToggle(550);
            $('.AlbumContainerLink').addClass('disable');
            $('#ContentFilter').removeClass('ContentFilterVisibility');
            this.isMenuShowing = !this.isMenuShowing;
            console.log("toggle menu, isMenuShowing: " + this.isMenuShowing);
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
            if(!this.artistList) {
                this.artistList = new ViewController.ArtistListView();
            }
            this.artistList.render();
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
    })(ViewController.WaveBoxView);
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
