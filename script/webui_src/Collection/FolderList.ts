/// <reference path="../Model/Folder.ts"/>

module Collection
{
    export class FolderList extends Backbone.Collection 
    {
        folderId: number;

        // Reference to this collection's model.
        model = Model.Folder;
    }
}