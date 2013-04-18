/// <reference path="./WaveBoxView.ts"/>
/// <reference path="../Collection/AlbumList.ts"/>
/// <reference path="./AlbumItemView.ts"/>

module ViewController
{
    export class AlbumListView extends WaveBoxView 
    {
        albumList: Collection.AlbumList;
        displayType: string;

        constructor(options?)
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
                var albumView = new AlbumItemView({model: album});
                this.$el.append(albumView.render().el);
            });

            return this;
        }
    }
}