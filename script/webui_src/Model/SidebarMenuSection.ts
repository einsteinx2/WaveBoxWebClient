/// <reference path="./SidebarMenuItem.ts"/>

module Model
{
    export class SidebarMenuSection extends Backbone.Collection 
    {
        // The display name of the section
        name: string;

        // Reference to this collection's model.
        model = SidebarMenuItem;

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
}