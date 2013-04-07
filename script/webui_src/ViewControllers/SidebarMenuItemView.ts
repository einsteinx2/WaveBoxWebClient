/// <reference path="../DataModel/SidebarMenuItem.ts"/>

// This represents an item in the sidebar menu view
class SidebarMenuItemView extends Backbone.View 
{
    model: SidebarMenuItem;

    constructor(options?) 
    {
        // This is a list tag.
        this.tagName = "li";

        super(options);
    }

    render() 
    {
    	// The default sidebar item style
    	this.$el.addClass("SidebarIcons");

    	// The specific style for this item
    	this.$el.addClass(this.model.get("cssClass"));

    	// Add the link with the name
        this.$el.html('<a href="#">' + this.model.get("name") + '</a>');

        // Return this for chaining
        return this;
    }
}