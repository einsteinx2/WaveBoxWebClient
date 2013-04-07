var __extends = this.__extends || function (d, b) {
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
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
var SidebarMenuSection = (function (_super) {
    __extends(SidebarMenuSection, _super);
    function SidebarMenuSection() {
        _super.apply(this, arguments);

        this.model = SidebarMenuItem;
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
var SidebarMenuView = (function (_super) {
    __extends(SidebarMenuView, _super);
    function SidebarMenuView() {
        _super.call(this);
        this.setElement($("#SidebarMenuContent"), true);
        this.headerSection = new SidebarMenuSection([
            {
                name: "HomePlex",
                cssClass: "Cloud"
            }, 
            {
                name: "",
                cssClass: "Settings"
            }
        ]);
        this.browseSection = new SidebarMenuSection([
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
        this.personalizeSection = new SidebarMenuSection([
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
        this.settingsSection = new SidebarMenuSection([
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
                var itemView = new SidebarMenuItemView({
                    model: item
                });
                console.log(item);
                _this.$el.append(itemView.render().el);
            });
        });
        return this;
    };
    return SidebarMenuView;
})(Backbone.View);
var ApplicationView = (function (_super) {
    __extends(ApplicationView, _super);
    function ApplicationView() {
        _super.call(this);
        this.sidebarMenu = new SidebarMenuView();
        this.sidebarMenu.render();
    }
    return ApplicationView;
})(Backbone.View);
var application;
$(function () {
    application = new ApplicationView();
});
