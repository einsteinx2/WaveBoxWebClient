/// <reference path="./WaveBoxCollection.ts"/>
/// <reference path="../Model/Folder.ts"/>

module Collection
{
    export class FolderList extends WaveBoxCollection 
    {
        folderId: number;

        // Reference to this collection's model.
        model = Model.Folder;
    }
}