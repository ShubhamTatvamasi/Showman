pragma solidity ^0.4.0;

/** 
* @title Project Showman
* @author Shubham Tatvamasi
* @notice Social Media Project for connecting people on Blockchain
*/
contract Showman {

  // ****************** Public Variables ******************

  /// @dev address of all the users
  mapping (address => User) public users;
  /// @dev list of posts of the user address
  mapping (address => uint[]) public userPosts;
  /// @dev list of total posts
  Post[] public posts;
  /// @dev list of total feedbacks
  Message[] public feedbacks;

  // ****************** Private Variables ******************

  /// @dev username of all the users
  mapping (string => address) private usernames;

  // ****************** Follow Variables ******************

  /// @dev to check if I am following the person or not
  mapping (address => mapping (address => Following)) public isFollowing;
  /// @dev list of my followings
  mapping (address => address[]) public following;
  /// @dev list of my followers
  mapping (address => address[]) public followers;

  // ****************** Chat Variables ******************

  /// @dev list of my chat numbers
  mapping (address => mapping (address => uint)) public chatNumbers;
  /// @dev list of all the chats
  mapping (uint => Message[]) public chats;
  /// @dev number of total chats
  uint public totalChats;

  // ****************** Events ******************

  /// @dev event for when user updates the name
  event UpdateName(address user, string name);
  /// @dev event for when user updates the username
  event UpdateUsername(address user, string username);
  /// @dev event for when user updates the about me
  event UpdateAboutMe(address user, string aboutMe);
  /// @dev event for when user updates the image hash
  event UpdateImageHash(address user, string imageHash);

  /// @dev event for new post
  event NewPost(address user, string post, uint postNumber);
  /// @dev event for like the post
  event LikePost(address user, address postOwner, uint postNumber);
  /// @dev event for comment on post
  event CommentOnPost(address user, address postOwner, string comment, uint postNumber);
  /// @dev event for new feedback
  event NewFeedback(address user, string feedback);

  /// @dev event for new message
  event NewMessage(address from, address to, string message);

  /// @dev event user follow
  event Follow(address user, address follow);
  /// @dev event user unFollow
  event UnFollow(address user, address unFollow);

  // ****************** Structures ******************

  /// @dev structure for users
  struct User {
    string name;
    string username;
    string aboutMe;
    string imageHash;
  }

  /// @dev structure for posts
  struct Post {
    Message post;
    address[] likes;
    Message[] comments;
    mapping (address => bool) hasLikedPost;
  }

  /// @dev structure for message
  struct Message {
    string message;
    address from;
    uint time;
  }

  /// @dev structure for following and followers users
  struct Following {
    bool status;
    uint followingPosition;
    uint followersPosition;
  }

  // ****************** Update Functions ******************

  /// @param _name for updating name
  function updateName(string _name) public {
    users[msg.sender].name = _name;
    emit UpdateName(msg.sender, _name);
  }

  /// @param _username for updating username
  function updateUsername(string _username) public {
    require(usernames[_username] == 0x0000000000000000000000000000000000000000);

    delete usernames[users[msg.sender].username];
    users[msg.sender].username = _username;
    usernames[_username] = msg.sender;
    emit UpdateUsername(msg.sender, _username);
  }

  /// @param _aboutMe for updating about me
  function updateAboutMe(string _aboutMe) public {
    users[msg.sender].aboutMe = _aboutMe;
    emit UpdateAboutMe(msg.sender, _aboutMe);
  }

  /// @param _imageHash for updating image
  function updateImageHash(string _imageHash) public {
    users[msg.sender].imageHash = _imageHash;
    emit UpdateImageHash(msg.sender, _imageHash);
  }

  // ****************** Post Functions ******************

  /// @param _post for adding new post
  function newPost(string _post) public returns (uint postNumber) {
    postNumber = posts.length++;
    userPosts[msg.sender].push(postNumber);

    Post storage p = posts[postNumber];
    p.post = Message(_post, msg.sender, now);
    emit NewPost(msg.sender, _post, postNumber);
  }

  /// @param _postNumber for liking the post
  function likePost(uint _postNumber) public {
    require(posts[_postNumber].hasLikedPost[msg.sender] == false);
    posts[_postNumber].likes.push(msg.sender);
    posts[_postNumber].hasLikedPost[msg.sender] = true;
    emit LikePost(msg.sender, posts[_postNumber].post.from, _postNumber);
  }

  /// @param _comment what we want to comment
  /// @param _postNumber on which we want to post
  function commentOnPost(string _comment, uint _postNumber) public {
    posts[_postNumber].comments.push(Message(_comment, msg.sender, now));
    emit CommentOnPost(msg.sender, posts[_postNumber].post.from, _comment, _postNumber);
  }

  /// @param _feedback add new feedback
  function newFeedback(string _feedback) public {
    feedbacks.push(Message(_feedback, msg.sender, now));
    emit NewFeedback(msg.sender, _feedback);
  }

  // ****************** Chat Function ******************

  /// @param _to address you want to send the message to
  /// @param _message for the chat
  function newMessage(address _to, string _message) public returns (uint chatNumber) {

    if (chatNumbers[msg.sender][_to] == 0) {
      chatNumber = ++totalChats;
      chatNumbers[_to][msg.sender] = chatNumber;
      chatNumbers[msg.sender][_to] = chatNumber;
    } else {
        chatNumber = chatNumbers[msg.sender][_to];
    }
    chats[chatNumber].push(Message(_message, msg.sender, now));
    emit NewMessage(msg.sender, _to, _message);
  }

  // ****************** Following Functions ******************

  /// @param _follow new user
  function follow(address _follow) public {
    require(isFollowing[msg.sender][_follow].status == false);
    require(msg.sender != _follow);

    isFollowing[msg.sender][_follow] = Following(true, totalFollowing(msg.sender), totalFollowers(_follow));

    following[msg.sender].push(_follow);
    followers[_follow].push(msg.sender);
    emit Follow(msg.sender, _follow);
  }

  /// @param _unFollow the user which I am following
  function unFollow(address _unFollow) public {
    require(isFollowing[msg.sender][_unFollow].status == true);

    uint followingNumber = isFollowing[msg.sender][_unFollow].followingPosition;
    address lastFollowing = following[msg.sender][following[msg.sender].length-1];
    following[msg.sender][followingNumber] = lastFollowing;
    isFollowing[msg.sender][lastFollowing].followingPosition = isFollowing[msg.sender][_unFollow].followingPosition;
    following[msg.sender].length--;

    uint followersNumber = isFollowing[msg.sender][_unFollow].followersPosition;    
    address lastFollowers = followers[_unFollow][followers[_unFollow].length-1];
    followers[_unFollow][followersNumber] = lastFollowers;
    isFollowing[msg.sender][lastFollowers].followersPosition = isFollowing[msg.sender][_unFollow].followersPosition;
    followers[_unFollow].length--;

    delete isFollowing[msg.sender][_unFollow];
    emit UnFollow(msg.sender, _unFollow);
  }

  // ****************** Public Getters ******************

  /// @param _username to see the address
  /// @return address of the _username
  function getUsernameAddress(string _username) public view returns (address) {
    return usernames[_username];
  }

  /// @param _address to see total posts of user
  /// @return total posts of _address
  function getUserPosts(address _address) public view returns (uint) {
    return userPosts[_address].length;
  }

  /// @param _post to see total likes of post
  /// @return total likes of _post
  function totalLikesOnPost(uint _post) public view returns (uint) {
      return posts[_post].likes.length;
  }

  /// @param _post to see total comments of post
  /// @return total comments of _post
  function totalCommentsOnPost(uint _post) public view returns (uint) {
      return posts[_post].comments.length;
  }

  /// @return total posts
  function totalPosts() public view returns (uint) {
    return posts.length;
  }

  /// @param _address to see total following
  /// @return total following of _address
  function totalFollowing(address _address) public view returns (uint) {
    return following[_address].length;
  }

  /// @param _address to see total followers
  /// @return total followers of _address
  function totalFollowers(address _address) public view returns (uint) {
    return followers[_address].length;
  }
   
  /// @return total feedbacks
  function totalFeedbacks() public view returns (uint) {
    return feedbacks.length;
  }

}