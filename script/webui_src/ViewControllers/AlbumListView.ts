/// <reference path="../DataModel/AlbumList.ts"/>
/// <reference path="./AlbumView.ts"/>

// This represents the entire sidebar menu
class AlbumListView extends Backbone.View 
{
    albumList: AlbumList;
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
        this.albumList.each((album : Album) => {
            console.log(album);

            var albumView = new AlbumView({model: album});
            this.$el.append(albumView.render().el);
        });

        return this;
    }
}