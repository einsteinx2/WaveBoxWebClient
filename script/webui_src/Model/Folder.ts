module Model
{
    export class Folder extends Backbone.Model 
    {
        itemTypeId: number;
        folderId: number;
        folderName: string;
        parentFolderId: number;
        mediaFolderId: number;
        folderPath: string;
        artId: number;
    }
}