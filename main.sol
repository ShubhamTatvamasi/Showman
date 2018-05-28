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
  Feedback[] public feedbacks;

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
    string post;
    address from;
    uint time;
    address[] likes;
    Comment[] comments;
    mapping (address => bool) hasLikedPost;
  }

  /// @dev structure for comment
  struct Comment {
    string comment;
    address from;
    uint time;
  }

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

  /// @dev structure for feedbacks
  struct Feedback {
    string feedback;
    address from;
    uint time;
  }

  // ****************** Update Functions ******************

  /// @param _name for updating name
  function updateName(string _name) public {
    users[msg.sender].name = _name;
  }

  /// @param _username for updating username
  function updateUsername(string _username) public {
    require(usernames[_username] == 0x0000000000000000000000000000000000000000);

    delete usernames[users[msg.sender].username];
    users[msg.sender].username = _username;
    usernames[_username] = msg.sender;
  }

  /// @param _aboutMe for updating about me
  function updateAboutMe(string _aboutMe) public {
    users[msg.sender].aboutMe = _aboutMe;
  }

  /// @param _imageHash for updating image
  function updateImageHash(string _imageHash) public {
    users[msg.sender].imageHash = _imageHash;
  }

  // ****************** Post Functions ******************

  /// @param _post for adding new post
  function newPost(string _post) public returns (uint postNumber) {
    postNumber = posts.length++;
    userPosts[msg.sender].push(postNumber);

    Post storage p = posts[postNumber];
    p.post = _post;
    p.from = msg.sender;
    p.time = now;
  }

  /// @param _post for liking the post
  function likePost(uint _post) public {
    require(posts[_post].hasLikedPost[msg.sender] == false);
    posts[_post].likes.push(msg.sender);
    posts[_post].hasLikedPost[msg.sender] = true;
  }

  /// @param _post on which we want to post
  /// @param _comment what we want to comment
  function commentOnPost(uint _post, string _comment) public {
    posts[_post].comments.push(Comment(_comment, msg.sender, now));
  }

  /// @param _feedback add new feedback
  function newFeedback(string _feedback) public {
    feedbacks.push(Feedback(_feedback, msg.sender, now));
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
  }

  // ****************** Following Functions ******************

  /// @param _follow new user
  function follow(address _follow) public {
    require(isFollowing[msg.sender][_follow].status == false);
    require(msg.sender != _follow);

    isFollowing[msg.sender][_follow] = Following(true, totalFollowing(msg.sender), totalFollowers(_follow));

    following[msg.sender].push(_follow);
    followers[_follow].push(msg.sender);
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

    isFollowing[msg.sender][_unFollow] = Following(false, 0, 0);
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

  // ****************** Utility Functions ******************

  /// @dev if ether is sent to this address, send it back
  function () external {
    revert();
  }

}