/// <reference path="./WaveBoxCollection.ts"/>
/// <reference path="../Model/Folder.ts"/>

module Collection
{
    export class FolderList extends WaveBoxCollection 
    {
        folderId: number;

        // Reference to this collection's model.
        model = Model.Folder;

        constructor(options?: any)
        {
        	super();
        	this.folderId = options.folderId;
        } 

        sync(method: string, model: any, options?: any): any
        {
            switch (method) 
            {
                case 'create':
                    break;

                case 'update':
                    break;

                case 'delete':
                    break;

                case 'read':
                    // The model value is a collection in this case
                    console.log("folderId: " + this.folderId);
                    Model.ApiClient.getFolder(this.folderId, false, (success: bool, data: any) => {
                        console.log("success: " + success + "  data: " + JSON.stringify(data));
                        if (success)
                        {
                            options.success(data);
                        }
                        else
                        {
                            options.error(data);
                        }
                        
                    });
                    break;

                default:
                    // Something probably went wrong
                    console.error('Unknown method:', method);
                break;
            }
        }

        parse(response: any, options?: any): any
        {
            console.log("parse called, response: " + JSON.stringify(response));
            return response.folders;
        }
    }
}