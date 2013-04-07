/// <reference path="../DataModel/SidebarMenuItem.ts"/>

// This represents an item in the sidebar menu view
class SidebarMenuItemView extends Backbone.View 
{
    // A SidebarMenuItemView model must be a SidebarMenuItem, redeclare with specific type
    model: SidebarMenuItem;

    constructor(options?) 
    {
        // This is a list tag.
        this.tagName = "li";

        /*// The DOM events specific to an item.
        this.events = {
            "click .check": "toggleDone",
            "dblclick label.todo-content": "edit",
            "click span.todo-destroy": "clear",
            "keypress .todo-input": "updateOnEnter",
            "blur .todo-input": "close"
        };*/

        super(options);

        /*_.bindAll(this, 'render', 'close', 'remove');
        this.model.bind('change', this.render);
        this.model.bind('destroy', this.remove);*/
    }

    // Re-render the contents of the todo item.
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