/// <reference path="./WaveBoxView.ts"/>
/// <reference path="../Model/Album.ts"/>

module ViewController
{
    export class AlbumItemView extends WaveBoxView
    {
        model: Model.Album;
        template: (data: any) => string;

        constructor(options?) 
        {
            // This is a list tag.
            this.tagName = "li";

            super(options);

            // Cache the template function for a single item.
            this.template = _.template($('#AlbumView_cover-template').html());
        }
    
        render() 
        {
            // Add to the DOM
            this.appendToParent();

            // Add the default style
            this.$el.addClass("AlbumContainer");

            // Create the artist from the template
            this.$el.html(this.template(this.model.toJSON()));

            // Return this for chaining
            return this;
        }
    }
}