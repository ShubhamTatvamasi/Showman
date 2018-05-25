pragma solidity ^0.4.0;

contract Showman {

  mapping (address => User) public users;
  mapping (string => address) usernames;
  mapping (address => uint[]) public postNumbers;

  mapping (address => mapping (address => Following)) public isFollowing;

  mapping (address => address[]) public following;
  mapping (address => address[]) public followers;

  Post[] public posts;
  Feedback[] public feedbacks;

  struct User {
    string name;
    string username;
    string aboutMe;
    string imageHash;
  }

  struct Post {
    string post;
    address from;
    uint time;
  }

  struct Following {
    bool status;
    uint followingPosition;
    uint followersPosition;
  }

  struct Feedback {
    string feedback;
    address from;
    uint time;
  }

  function updateUsername(string _username) public {
    require(usernames[_username] == 0x0000000000000000000000000000000000000000);

    usernames[users[msg.sender].username] = 0x0000000000000000000000000000000000000000;
    users[msg.sender].username = _username;
    usernames[_username] = msg.sender;
  }

  function updateName(string _name) public {

    users[msg.sender].name = _name;
  }

  function updateAboutMe(string _aboutMe) public {

    users[msg.sender].aboutMe = _aboutMe;
  }

  function updateImageHash(string _imageHash) public {

    users[msg.sender].imageHash = _imageHash;
  }

  function newPost(string _post) public {

    postNumbers[msg.sender].push(totalPosts());
    posts.push(Post(_post, msg.sender, now));
  }

  function follow(address _follow) public {
    require(isFollowing[msg.sender][_follow].status == false);
    require(msg.sender != _follow);

    isFollowing[msg.sender][_follow] = Following(true, totalFollowing(msg.sender), totalFollowers(_follow));

    following[msg.sender].push(_follow);
    followers[_follow].push(msg.sender);
  }

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

  function newFeedback(string _feedback) public {
    // add new feedback it array list
    feedbacks.push(Feedback(_feedback, msg.sender, now));
  }

  function getUsernameAddress(string _username) public view returns (address) {
    // return the address of the _username
    return usernames[_username];
  }

  function totalPosts() public view returns (uint) {
    // return the length of total number of posts
    return posts.length;
  }

  function totalPostNumbers(address _address) public view returns (uint) {
    // return the length of total number of posts of _address
    return postNumbers[_address].length;
  }

  function totalFollowing(address _address) public view returns (uint) {
    // return the length of total number of following of _address
    return following[_address].length;
  }

  function totalFollowers(address _address) public view returns (uint) {
    // return the length of total number of followers of _address
    return followers[_address].length;
  }

  function totalFeedbacks() public view returns (uint) {
    // return the length of total number of feedbacks
    return feedbacks.length;
  }

  function () public {
    // if ether is sent to this address, send it back.
    revert();
  }

}