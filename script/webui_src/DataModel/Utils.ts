module DataModel
{
	export class Utils 
	{
		public static isRetina(): bool 
		{
			return window.devicePixelRatio > 1 ? true : false;
		}
	}
}

interface Array
{
	NowPlayingIndex: number;
	shuffle(): void;
	slice(): any;
}

interface Window
{
	webkitNotifications: any;
}

Array.prototype.shuffle = function () {
	// iterate over the array and assign pre-shuffle indices
	var temp, j, i = 0;
	while (i < this.length) 
	{
		this[i].preShuffleIndex = i;
		i++;
	}

	i = this.length;
	while (--i) 
	{
		// generate a random number
		j = Math.floor(Math.random() * (i + 1));

		// swap the item at the current index and the item at the randomly generated number
		temp = this[i];
		this[i] = this[j];
		this[j] = temp;

		// if the currently playing song is involved in the swap, adjust the NowPlayingIndex to reflect that.
		if (this.NowPlayingIndex === i) 
		{
			this.NowPlayingIndex = j;
		} 
		else if (this.NowPlayingIndex === j) 
		{
			this.NowPlayingIndex = i;
		}
	}

    console.log("NowPlayingIndex is now: " + this.NowPlayingIndex);

    return this; // for convenience, in case we want a reference to the array
};