/// <reference path="./SidebarMenuItem.ts"/>

class SidebarMenuSection extends Backbone.Collection 
{
    // The display name of the section
    name: string;

    // Reference to this collection's model.
    model = SidebarMenuItem;

    // Save all of the todo items under the `"todos"` namespace.
    //localStorage = new Store("sidebaritems-backbone");

    // Filter down to only the enabled
    enabled() 
    {
        return this.filter((item: SidebarMenuItem) => item.get('enabled'));
    }

    // Menu items are sorted by their index
    comparator(item: SidebarMenuItem) 
    {
        return item.get('index');
    }
}