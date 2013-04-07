/// <reference path="../DataModel/SidebarMenuSection.ts"/>
/// <reference path="./SidebarMenuItemView.ts"/>

// This represents the entire sidebar menu
class SidebarMenuView extends Backbone.View 
{
    headerSection: SidebarMenuSection;
    browseSection: SidebarMenuSection;
    personalizeSection: SidebarMenuSection;
    settingsSection: SidebarMenuSection;
    
    sections: SidebarMenuSection[];

    constructor()
    {
        super();
        // Instead of generating a new element, bind to the existing skeleton of
        // the menu already present in the HTML.
        this.setElement($("#SidebarMenuContent"), true);

        this.headerSection = new SidebarMenuSection(
        [
        	{
        		name: "HomePlex", 
        		cssClass: "Cloud"
        	}, 
        	{
        		name: "", 
        		cssClass: "Settings"
        	}
        ]);

        this.browseSection = new SidebarMenuSection(
        [
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

        this.personalizeSection = new SidebarMenuSection(
        [
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

		this.settingsSection = new SidebarMenuSection(
        [
        	{
        		name: "Offline", 
        		cssClass: "Offline"
        	}
        ]);
        this.settingsSection.name = "Settings";

        this.sections = [this.headerSection, this.browseSection, this.personalizeSection, this.settingsSection];
	}

    render()
    {
    	// Clear the view
        this.$el.empty();

        // Add the lists to the DOM
        _.each(this.sections, (section: SidebarMenuSection) => 
        {
        	// Add the section title if necessary
        	if (section.name !== undefined)
        	{
        		this.$el.append("<span>" + section.name + "</span>");
        	}
        	
        	// Add the menu row
        	_.each(section.models, (item: SidebarMenuItem) => 
        	{
        		var itemView = new SidebarMenuItemView({
        			model: item
        		})

        		console.log(item);

        		//this.$el.append('<li class="SidebarIcons ' + item.get("cssClass") + '"><a href="#">' + item.get("name") + '</a></li>');
        		this.$el.append(itemView.render().el);
        	});
        });

        return this;
    }
}