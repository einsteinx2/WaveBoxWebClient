/// <reference path="../Model/SidebarMenuSection.ts"/>
/// <reference path="./SidebarMenuItemView.ts"/>

module ViewController
{
    // This represents the entire sidebar menu
    export class SidebarMenuView extends Backbone.View 
    {
        headerSection: Model.SidebarMenuSection;
        browseSection: Model.SidebarMenuSection;
        personalizeSection: Model.SidebarMenuSection;
        settingsSection: Model.SidebarMenuSection;
        
        sections: Model.SidebarMenuSection[];

        constructor()
        {
            super();
            // Instead of generating a new element, bind to the existing skeleton of
            // the menu already present in the HTML.
            this.setElement($("#SidebarMenuContent"), true);

            this.headerSection = new Model.SidebarMenuSection(
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

            this.browseSection = new Model.SidebarMenuSection(
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

            this.personalizeSection = new Model.SidebarMenuSection(
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

    		this.settingsSection = new Model.SidebarMenuSection(
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
            _.each(this.sections, (section: Model.SidebarMenuSection) => 
            {
            	// Add the section title if necessary
            	if (section.name !== undefined)
            	{
            		this.$el.append("<span>" + section.name + "</span>");
            	}
            	
            	// Add the menu row
            	_.each(section.models, (item: Model.SidebarMenuItem) => 
            	{
            		var itemView = new SidebarMenuItemView({
            			model: item
            		})

            		this.$el.append(itemView.render().el);
            	});
            });

            return this;
        }
    }
}