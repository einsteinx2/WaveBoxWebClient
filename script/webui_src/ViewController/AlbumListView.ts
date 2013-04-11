/// <reference path="../Collection/AlbumList.ts"/>
/// <reference path="./AlbumView.ts"/>

module ViewController
{
    // This represents the entire sidebar menu
    export class AlbumListView extends Backbone.View 
    {
        albumList: Collection.AlbumList;
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
            this.$el.attr("id", "AlbumView");

            // Add the albums to the DOM
            this.albumList.each((album : Model.Album) => 
            {
                var albumView = new AlbumView({model: album});
                this.$el.append(albumView.render().el);
            });

            return this;
        }
    }
}