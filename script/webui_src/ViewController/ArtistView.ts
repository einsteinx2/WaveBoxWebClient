/// <reference path="../Model/Artist.ts"/>

module ViewController
{
    // This represents an item in the sidebar menu view
    export class ArtistView extends Backbone.View 
    {
        model: Model.Artist;
        template: (data: any) => string;

        constructor(options?) 
        {
            // This is a list tag.
            this.tagName = "li";

            super(options);

            // Cache the template function for a single item.
            this.template = _.template($('#AlbumView_cover-template').html());
        }

        // Re-render the contents of the todo item.
        render() 
        {
            // Add the default style
            this.$el.addClass("AlbumContainer");

            // Create the album from the template
            this.$el.html(this.template(this.model.toJSON()))

            // Return this for chaining
            return this;
        }
    }
}