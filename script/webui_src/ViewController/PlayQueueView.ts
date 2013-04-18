/// <reference path="./WaveBoxView.ts"/>
/// <reference path="../Model/Song.ts"/>
/// <reference path="../Collection/PlayQueueList.ts"/>
/// <reference path="./PlayQueueItemView.ts"/>

module ViewController
{
    export class PlayQueueView extends WaveBoxView
    {
        playQueueList: Collection.PlayQueueList;

        constructor(options?)
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

                var itemView = new PlayQueueItemView({model: item});
                this.$el.append(itemView.render().el);
            });

            return this;
        }
    }
}