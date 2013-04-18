/// <reference path="./WaveBoxView.ts"/>
/// <reference path="../Collection/ArtistAlbumList.ts"/>
/// <reference path="./AlbumItemView.ts"/>

module ViewController
{
    export class ArtistView extends WaveBoxView
    {
        artistAlbumList: Collection.ArtistAlbumList;
        displayType: string;

        constructor(options?)
        {        
            // This is an unnumbered list tag.
            this.tagName = "ul";

            super(options);

            // Default display type of cover
            this.displayType = "cover";

            // Fetch the artists
            console.log("options.artistId: " + this.options.artistId);
            this.artistAlbumList = new Collection.ArtistAlbumList([], this.options);
            this.artistAlbumList.on("change", this.render, this);
            this.artistAlbumList.fetch({ success: this.fetchSuccess });
        }

        fetchSuccess()
        {
            console.log(this.artistAlbumList.models);
            this.render();
        }

        render()
        {
            console.log("ArtistView render called");

            // Clear the view and add to the DOM
            this.$el.empty();
            $("#contentMainArea").empty();
            $("#contentMainArea").append(this.el);

            // Set the id
            this.$el.attr("id", "AlbumView");

            // Add the albums
            this.artistAlbumList.each((album : Model.Album) => 
            {
                var albumView = new AlbumItemView({parentView: this, model: album});
                this.$el.append(albumView.render().el);
            });

            return this;
        }
    }
}