pragma solidity ^0.4.0;

contract Showman {

  mapping (address => User) public users;
  mapping (address => Post[]) public posts;

  mapping (address => mapping (address => Following)) public isFollowing;

  mapping (address => address[]) public following;
  mapping (address => address[]) public followers;

  struct User {
    string name;
    string aboutMe;
    string imageHash;
  }

  struct Post {
    string post;
    uint time;
  }

  struct Following {
    bool status;
    uint followingPosition;
    uint followersPosition;
  }

  function updateUserName(string _name) public {

    users[msg.sender].name = _name;
  }

  function updateUserAboutMe(string _aboutMe) public {

    users[msg.sender].aboutMe = _aboutMe;
  }

  function updateUserImageHash(string _imageHash) public {

    users[msg.sender].imageHash = _imageHash;
  }

  function newPost(string _post) public returns (uint postNumber) {

    postNumber = posts[msg.sender].length++;

    posts[msg.sender][postNumber] = Post(_post, now);
  }

  function follow(address _follow) public {
    require(isFollowing[msg.sender][_follow].status == false);

    uint followingNumber = following[msg.sender].length++;
    uint followersNumber = followers[_follow].length++;

    following[msg.sender][followingNumber] = _follow;
    followers[_follow][followersNumber] = msg.sender;

    isFollowing[msg.sender][_follow] = Following(true, followingNumber, followersNumber);
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
    isFollowing[msg.sender][lastFollowing].followersPosition = isFollowing[msg.sender][_unFollow].followersPosition;
    followers[_unFollow].length--;

    isFollowing[msg.sender][_unFollow] = Following(false, 0, 0);
  }

  function totalPosts(address _add) public view returns (uint) {

    return posts[_add].length;
  }

  function totalFollowing(address _add) public view returns (uint) {

    return following[_add].length;
  }

  function totalFollowers(address _add) public view returns (uint) {

    return followers[_add].length;
  }

}