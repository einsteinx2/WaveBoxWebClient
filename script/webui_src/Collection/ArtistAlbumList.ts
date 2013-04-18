/// <reference path="./WaveBoxCollection.ts"/>
/// <reference path="../Model/Album.ts"/>

module Collection
{
	export class ArtistAlbumList extends WaveBoxCollection 
	{
	    // Reference to this collection's model.
	    model = Model.Album;

        sync(method: string, model: any, options?: any): any
        {
            console.log("options: " + JSON.stringify(this.options));

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
                    Model.ApiClient.getArtistAlbums(this.options.artistId, this, (success: bool, data: any) => {
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