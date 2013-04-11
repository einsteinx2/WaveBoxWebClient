module Model
{
    export class SidebarMenuItem extends Backbone.Model 
    {
        name: string;
        image: string;
        cssClass: string;
        index: number;
        enabled: bool;

        // Default attributes for sidebar items
        defaults() 
        {
            return {
                name: " ",
                image: " ",
                cssClass: " ", 
                index: 0,
                enabled: true
            };
        };
    }
}