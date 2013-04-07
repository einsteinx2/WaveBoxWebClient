/// <reference path="./SidebarMenuView.ts"/>

class ApplicationView extends Backbone.View 
{
	sidebarMenu: SidebarMenuView;

	constructor ()
	{
        super();

        // Create the menu
        this.sidebarMenu = new SidebarMenuView();
        this.sidebarMenu.render();
    }
}