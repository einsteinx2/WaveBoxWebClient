/// <reference path="references.ts"/>
/// <reference path="../DataModel/RestClient.ts"/>

module ViewControllers
{
	export class WaveboxFolderContextViewController
	{
		private formattedTimeWithSeconds(seconds: number): string
		{
			var stringTime, hrs, mins, secs;

			stringTime = "";
			hrs = Math.floor(seconds / 3600);
			mins = Math.floor((seconds - (hrs * 3600)) / 60);
			secs = Math.floor(seconds - (hrs * 3600) - (mins * 60));

			if (hrs > 0) 
			{
				stringTime += hrs + ":";
			}

			if (mins < 10 && hrs > 0) 
			{
				stringTime += "0" + mins + ":";
			} 
			else 
			{
				stringTime += mins + ":";
			}

			if (secs < 10) 
			{
				stringTime += "0" + secs;
			}
			else 
			{
				stringTime += secs;
			}

			return stringTime;
		}

		public updateWithArtistList(): void
		{

		}

		public updateWithArtist(artist: any): void 
		{

		}

		public updateWithAlbum(album: any): void
		{

		}

		public updateWithFolder(folderInfo: any): void 
		{
			console.log(JSON.stringify(folderInfo));

			var cf, artUrl, fNum, sNum, vNum, mediaCountString, totalDuration;
			cf = folderInfo.containingFolder;
			console.log("cf " + JSON.stringify(cf));
			artUrl = DataModel.RestClient.getSongArtUrl(cf, undefined);
			$("#contextInfoImg").attr("src", artUrl);
			$("#contextInfoTitle").text(cf.folderName);

			// grab number of folders, songs, videos.  Assemble the needed string, and
			// update the view.
			fNum = folderInfo.folders.length > 0 ? folderInfo.folders.length : "No";
			sNum = folderInfo.songs.length > 0 ? folderInfo.songs.length : "no";
			vNum = folderInfo.videos.length > 0 ? folderInfo.videos.length : "no";
			mediaCountString = fNum + " folders, " + sNum + " songs, " + vNum + " videos";
			$("#contextInfoSubTitle").text(mediaCountString);

			// calculate the total duration of all media items (songs for now)
			// show the duration view if it's more than 0 seconds
			totalDuration = 0;
			folderInfo.songs.forEach((element, index, array) => {
				totalDuration += element.duration;
			});

			if (totalDuration > 0) 
			{
				$("#contextInfoTotalLength").text("Total duration: " + this.formattedTimeWithSeconds(totalDuration));
				$("#contextInfoTotalLength").show();
			} 
			else 
			{
				$("#contextInfoTotalLength").hide();
			}
		}
	}
}