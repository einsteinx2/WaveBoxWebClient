/// <reference path="../references.ts"/>

module ViewControllers
{
	export class BrowseViewController
	{
		viewStack: any[];
		viewStackIndex: number;
		viewMode: any;

		constructor()
		{
			this.viewStack = [];
			this.viewStackIndex = 0;

			// Setup back button
			$("#backButton").hide();
			$("#backButton").click(() => {
				//console.log("popping view");
				this.popView();
			});

			// Bind the filter box
			$("#browseViewFilterBarTextBox").keyup(() => { this.filterRows(); } );
		}

		private filterRows()
		{
			var filterBoxText = $("#browseViewFilterBarTextBox").val().toLowerCase();
			$("#browseView" + this.viewStackIndex + " .folderListItem").each((index, element) => {
				var parentRow = $(element).parent().parent();
				var rowTitleText = $(element).text().toLowerCase();

				// Hide the row if its title doesn't contain the filter text
				if(rowTitleText.indexOf(filterBoxText) === -1)
				{
					console.log($(element).parent().parent());
					parentRow.hide();
				}

				// Ensure that the row is shown if it does contain the filter text.
				else
				{
					if(parentRow.css("display") === "none")
					{
						parentRow.show();
					}
				}
			});
		}

		public clearViews()
		{
			for (var i = 1; i <= this.viewStackIndex; i++) 
			{
				$("#browseView" + i).remove();
			}

			this.viewStackIndex = 0;
			this.viewStack = [];
		}

		public pushView(domElement: any, viewModeOfView: any): void 
		{
			console.log("push view");

			if (viewModeOfView !== this.viewMode) 
			{
				this.viewMode = viewModeOfView;
				this.clearViews();
			}

			// increment index
			this.viewStackIndex++;
			console.log("index: " + this.viewStackIndex);

			var newDiv = document.createElement("div");
			$(newDiv).attr("id", "browseView" + this.viewStackIndex);
			$(newDiv).html(domElement);

			// append element to DOM
			$("#browseViewContainer").append(newDiv);

			// push view reference onto viewStack
			this.viewStack[this.viewStackIndex] = ("#browseView" + this.viewStackIndex);
			console.log(this.viewStack);

			// hide currently shown DOM element
			$("#browseView" + (this.viewStackIndex - 1)).hide();

			// show pushed DOM element
			$("#browseView" + this.viewStackIndex).show();

			// publish ui/browseViewDidChange
			$.publish("ui/browseViewDidChange", "#browseView" + this.viewStackIndex);

			// Show the back button
			if (this.viewStackIndex > 1) 
			{
				$("#backButton").show();
			}
		}

		public popView(): void
		{
			// return if we're at the root because we don't want to pop the last view off the stack
			if (this.viewStackIndex === 1) 
			{
				return;
			}

			// hide currently shown element
			$("#browseView" + this.viewStackIndex).hide();

			// show previous element
			$("#browseView" + (this.viewStackIndex - 1)).show();

			// remove current element from the DOM
			$("#browseView" + this.viewStackIndex).remove();

			// pop reference off of viewStack
			this.viewStack.splice(this.viewStackIndex, 1);

			// subtract from the index
			this.viewStackIndex--;

			// publish ui/browseViewDidChange
			$.publish("ui/browseViewDidChange", "#browseView" + (this.viewStack.length - 1));

			// Hide the back button if necessary
			if (this.viewStackIndex === 1) 
			{
				$("#backButton").hide();
			}
		}

		public currentViewSelector(): any 
		{
			return this.viewStack[this.viewStackIndex];
		}
	}
}