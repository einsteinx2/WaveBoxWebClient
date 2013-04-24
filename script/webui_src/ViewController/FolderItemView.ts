/// <reference path="./WaveBoxView.ts"/>
/// <reference path="../Model/Folder.ts"/>

module ViewController
{
    export class FolderItemView extends WaveBoxView
    {
        model: Model.Folder;
        template: (data: any) => string;

        constructor(options?) 
        {
            // This is a list tag.
            this.tagName = "li";

            this.events = {
                "click": "open"
            };

            super(options);

            // Cache the template function for a single item.
            this.template = _.template($('#FolderView_cover-template').html());
        }
    
        open()
        {
            console.log("open called.  folderId: " + this.model.get("folderId"));
            var view = new FolderListView({ "folderId": this.model.get("folderId") });
            view.render();
        }

        render() 
        {
            console.log(this.model);

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