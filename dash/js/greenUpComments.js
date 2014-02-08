function CommentsHandle(){
	this.scrollPosition = 0;
	this.commentType;

	CommentsHandle.prototype.init = function init(){
		// add the listener to our add comments button
	} // end init()

	// when the comments nest is scrolled to a position defined in home.php, more comments are added
	CommentsHandle.prototype.updateScroll = function updateScroll(element){
		// console.log("Scrolling");
		// var offset = window.pageYOffset;
		var offset = element.scrollTop - window.Comments.scrollPosition;
		if (offset > 90){
			window.Comments.scrollPosition += offset;
			window.ApiConnector.pullCommentData(null, window.UI.commentsNextPageUrl);
		}
	} // end updateScroll()

	// when the comments checkboxes are toggled, this turns the comments on or off
	CommentsHandle.prototype.toggleComments = function toggleComments(type){
		switch(type){
			case('forum'):
				var bubbleNodeList = document.getElementsByClassName('bubbleForum');
				if(document.getElementById("toggleForum").checked){
					var forumBubbles = document.getElementsByClassName("bubbleForum");
					for(var i=0; i<forumBubbles.length; i++){
						forumBubbles[i].style.display = "block";
					}
				}else{
					var forumBubbles = document.getElementsByClassName("bubbleForum");
					for(var i=0; i<forumBubbles.length; i++){
						forumBubbles[i].style.display = "none";
					}
				}
			break;
			case('needs'):
				var bubbleNodeList = document.getElementsByClassName('bubbleNeeds');
				if(document.getElementById("toggleNeeds").checked){
					var forumBubbles = document.getElementsByClassName("bubbleNeeds");
					for(var i=0; i<forumBubbles.length; i++){
						forumBubbles[i].style.display = "block";
					}
				}else{
					var forumBubbles = document.getElementsByClassName("bubbleNeeds");
					for(var i=0; i<forumBubbles.length; i++){
						forumBubbles[i].style.display = "none";
					}
				}
			break;
			case('message'):
				var bubbleNodeList = document.getElementsByClassName('bubbleMessage');
				if(document.getElementById("toggleMessages").checked){
					var forumBubbles = document.getElementsByClassName("bubbleMessage");
					for(var i=0; i<forumBubbles.length; i++){
						forumBubbles[i].style.display = "block";
					}
				}else{
					var forumBubbles = document.getElementsByClassName("bubbleMessage");
					for(var i=0; i<forumBubbles.length; i++){
						forumBubbles[i].style.display = "none";
					}
				}
			break;
		}
	} // end toggleComments()

	CommentsHandle.prototype.goToMarker = function goToMarker(marker){
	// when the user clicks a comment box
	}

	//  The user presses the submit button on the comment submission screen
	CommentsHandle.prototype.commentSubmission = function commentSubmission(commentType, commentMessage){


		var comment = new FCommment();
		comment.message = commentMessage;
		comment.pin = null;
		// comment.type = document.getElementById("comment_type").value;
		comment.type = commentType;
		// comment.type = document.getElementById('comment_type').value;

		var serializedComment = JSON.stringify(comment);
		console.log(serializedComment);

		window.ApiConnector.pushCommentData(serializedComment);

		//Return false to stop normal form submission form occuring
		return false;
	}
}