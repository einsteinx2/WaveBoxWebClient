/// <reference path="./WaveBoxView.ts"/>
/// <reference path="../Collection/ArtistList.ts"/>
/// <reference path="./ArtistItemView.ts"/>

module ViewController
{
    export class ArtistListView extends WaveBoxView
    {
        artistList: Collection.ArtistList;
        displayType: string;

        constructor(options?)
        {        
            // This is an unnumbered list tag.
            this.tagName = "ul";

            super();

            // Default display type of cover
            this.displayType = "cover";

            // Fetch the artists
            this.artistList = new Collection.ArtistList();
            this.artistList.on("change", this.render, this);
            this.artistList.fetch({ success: this.fetchSuccess });
        }

        fetchSuccess()
        {
            console.log(this.artistList.models);
            this.render();
        }

        render()
        {
            // Clear the view and add to the DOM
            this.$el.empty();
            $("#contentScroller").empty();
            $("#contentScroller").append(this.el);

            // Set the ID
            this.$el.attr("id", "AlbumView");

            // Add the artists
            this.artistList.each((artist : Model.Artist) => 
            {
                var artistView = new ArtistItemView({parentView: this, model: artist});
                artistView.render();
                //this.$el.append(artistView.render().el);
            });

            return this;
        }
    }
}