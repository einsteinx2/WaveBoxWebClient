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
                _super.call(this, options);
        }
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
                    cssClass: "Cloud"
                }, 
                {
                    name: "",
                    cssClass: "Settings"
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
                    name: "Folder",
                    cssClass: "Folder"
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
                console.log(item);
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
    var ApplicationView = (function (_super) {
        __extends(ApplicationView, _super);
        function ApplicationView() {
                _super.call(this);
            this.sidebarMenu = new ViewController.SidebarMenuView();
            this.sidebarMenu.render();
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
            $("#contentScroller").append(this.albumList.render().el);
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
        }
        return ApplicationView;
    })(Backbone.View);
    ViewController.ApplicationView = ApplicationView;    
})(ViewController || (ViewController = {}));
var application;
$(function () {
    application = new ViewController.ApplicationView();
});
