pragma solidity ^0.4.0;

/** 
* @title Project Showman
* @author Shubham Tatvamasi
* @notice Social Media Project for connecting to people
*/
contract Showman {

  /// @dev address of all the users
  mapping (address => User) public users;
  /// @dev usernames of all the users
  mapping (string => address) usernames;
  /// @dev list of posts of the user address
  mapping (address => uint[]) public postNumbers;
  /// @dev to check if I am following the person or not
  mapping (address => mapping (address => Following)) public isFollowing;
  /// @dev list of my followings
  mapping (address => address[]) public following;
  /// @dev list of my followers
  mapping (address => address[]) public followers;
  /// @dev list of total posts
  Post[] public posts;
  /// @dev list of total feedbacks
  Feedback[] public feedbacks;

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

  /// @param _username for updating username
  function updateUsername(string _username) public {
    require(usernames[_username] == 0x0000000000000000000000000000000000000000);

    usernames[users[msg.sender].username] = 0x0000000000000000000000000000000000000000;
    users[msg.sender].username = _username;
    usernames[_username] = msg.sender;
  }

  /// @param _name for updating name
  function updateName(string _name) public {
    users[msg.sender].name = _name;
  }

  /// @param _aboutMe for updating about me
  function updateAboutMe(string _aboutMe) public {
    users[msg.sender].aboutMe = _aboutMe;
  }

  /// @param _imageHash for updating image
  function updateImageHash(string _imageHash) public {
    users[msg.sender].imageHash = _imageHash;
  }

  /// @param _post for adding new post
  function newPost(string _post) public {
    postNumbers[msg.sender].push(totalPosts());
    posts.push(Post(_post, msg.sender, now));
  }

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

  /// @param _feedback add new feedback
  function newFeedback(string _feedback) public {
    feedbacks.push(Feedback(_feedback, msg.sender, now));
  }

  /// @param _username to see the address
  /// @return address of the _username
  function getUsernameAddress(string _username) public view returns (address) {
    return usernames[_username];
  }

  /// @return posts
  function totalPosts() public view returns (uint) {
    return posts.length;
  }

  /// @param _address to see total following
  /// @return total posts of _address
  function totalPostNumbers(address _address) public view returns (uint) {
    return postNumbers[_address].length;
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

  /// @dev if ether is sent to this address, send it back
  function () public {
    revert();
  }

}