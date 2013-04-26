/// <reference path="./WaveBoxView.ts"/>
/// <reference path="../Model/SidebarMenuItem.ts"/>

module ViewController
{
    // This represents an item in the sidebar menu view
    export class SidebarMenuItemView extends WaveBoxView
    {
        model: Model.SidebarMenuItem;

        constructor(options?) 
        {
            // This is a list tag.
            this.tagName = "li";

            // Setup the DOM events
            this.events = {
                "click": "open"
            }

            super(options);
        }

        open()
        {
            console.log("open triggered: " + this.model.get("name"));
            app.trigger(this.model.get("action"));
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
}