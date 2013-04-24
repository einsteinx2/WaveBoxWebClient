/// <reference path="./WaveBoxView.ts"/>
/// <reference path="../Collection/FolderList.ts"/>
/// <reference path="./FolderItemView.ts"/>

module ViewController
{
    // This represents the main folder list
    export class FolderListView extends WaveBoxView
    {
        folderList: Collection.FolderList;

        displayType = "cover";
        tagName = "ul";

        constructor(options?)
        {        
            super();

            // Fetch the folders
            var folderId = undefined;
           	if (options !== undefined && options !== null && options.folderId !== undefined && options.folderId !== null)
           	{
           		folderId = options.folderId;
           	}

            this.folderList = new Collection.FolderList({"folderId": folderId});
            this.folderList.on("change", this.render, this);
            this.folderList.fetch({ success: this.fetchSuccess });
        }

        fetchSuccess()
        {
            console.log(this.folderList.models);
            this.render();
        }

        render()
        {
            // Clear the view and add to the DOM
            this.$el.empty();
            $("#contentMainArea").empty();
            $("#contentMainArea").append(this.el);

            // Set the ID
            this.$el.attr("id", "AlbumView");

            // Add the folders
            this.folderList.each((folder : Model.Folder) => 
            {
                var artistView = new FolderItemView({parentView: this, model: folder});
                artistView.render();
                //this.$el.append(artistView.render().el);
            });

            return this;
        }
    }
}