/// <reference path="./WaveBoxView.ts"/>
/// <reference path="../Model/Artist.ts"/>
/// <reference path="./ArtistView.ts"/>

module ViewController
{
    export class ArtistItemView extends WaveBoxView
    {
        model: Model.Artist;
        template: (data: any) => string;

        constructor(options?) 
        {
            // This is a list tag.
            this.tagName = "li";

            // Setup the DOM events
            this.events = {
                "click": "open"
            }

            super(options);

            // Cache the template function for a single item.
            this.template = _.template($('#ArtistView_cover-template').html());
        }

        open()
        {
            console.log("artist item view clicked, artistId = " + this.model.get("artistId"));
            //app.trigger(this.model.get("action"));

            var view = new ArtistView({"artistId":this.model.get("artistId")});
            view.render();
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