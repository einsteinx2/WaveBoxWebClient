/// <reference path="../DataModel/MediaItem.ts"/>
/// <reference path="../DataModel/Song.ts"/>

module ViewController
{
    export class PlayQueueItemView extends Backbone.View 
    {
        model: DataModel.Song;
        template: (data: any) => string;

        constructor(options?) 
        {
            super(options);

            // Cache the template function for a single item.
            this.template = _.template($('#PlayQueueItemView-template').html());
        }

        render() 
        {
            // The default item style
            this.$el.addClass("QueueList");

            // Create the item from the template
            this.$el.html(this.template(this.model.toJSON()));

            // Return this for chaining
            return this;
        }
    }
}