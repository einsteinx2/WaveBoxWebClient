module Model
{
    export class WaveBoxModel extends Backbone.Model 
    {
        options: any;

        constructor (attr?, opts?)
        {
            if (opts !== undefined && opts !== null)
            {
                this.options = opts;
            }

            super(attr, opts);
        }
    }
}