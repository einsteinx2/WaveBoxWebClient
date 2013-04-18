module Collection
{
    export class WaveBoxCollection extends Backbone.Collection 
    {
        options: any;

        constructor (models?, opts?)
        {
            if (opts !== undefined && opts !== null)
            {
                this.options = opts;
            }

            super(models, opts);
        }
    }
}