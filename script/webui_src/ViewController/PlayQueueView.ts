/// <reference path="../Model/Song.ts"/>
/// <reference path="../Model/PlayQueueList.ts"/>
/// <reference path="./PlayQueueItemView.ts"/>

module ViewController
{
    // This represents the entire sidebar menu
    export class PlayQueueView extends Backbone.View 
    {
        playQueueList: Collection.PlayQueueList;

        constructor()
        {        
            super();

            // Bind to existing element
            this.setElement($("#QueueScroller"), true);
        }

        render()
        {
            // Clear the view
            this.$el.empty();

            // Add the items to the DOM
            this.playQueueList.each((item : Model.Song) => {
                console.log(item);

                var itemView = new PlayQueueItemView({model: item});
                this.$el.append(itemView.render().el);
            });

            return this;
        }
    }
}