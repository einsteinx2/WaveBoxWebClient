/// <reference path="../Model/Album.ts"/>
/// <reference path="../Model/ApiClient.ts"/>

module Collection
{
    export class ArtistList extends Backbone.Collection 
    {
        // Reference to this collection's model.
        model = Model.Artist;

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
                    Model.ApiClient.getArtistList(this, (success: bool, data: any) => {
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
            return response;
        }
    }
}