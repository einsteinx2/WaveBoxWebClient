/// <reference path="../Collection/ArtistList.ts"/>
/// <reference path="./ArtistView.ts"/>

module ViewController
{
    // This represents the entire sidebar menu
    export class ArtistListView extends Backbone.View 
    {
        artistList: Collection.ArtistList;
        displayType: string;

        constructor()
        {        
            // This is an unnumbered list tag.
            this.tagName = "ul";

            super();

            // Default display type of cover
            this.displayType = "cover";
        }

        render()
        {
            // Clear the view
            this.$el.empty();
            this.$el.attr("id", "ArtistView");

            // Add the albums to the DOM
            this.artistList.each((artist : Model.Artist) => 
            {
                var artistView = new ArtistView({model: artist});
                this.$el.append(artistView.render().el);
            });

            return this;
        }
    }
}