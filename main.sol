pragma solidity ^0.4.0;

contract Showman {

  mapping (address => User) public users;
  mapping (address => Post[]) public posts;
  mapping (address => mapping (address => bool)) public followers;

  struct User {
    string name;
    string aboutMe;
    string imageHash;
  }

  struct Post {
    string post;
    uint time;
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

  function newPost(string _post) public {

    uint p = posts[msg.sender].length++;

    posts[msg.sender][p].post = _post;
    posts[msg.sender][p].time = now;
  }

  function totalPosts(address _add) public view returns (uint) {
    
  	return posts[_add].length;
  }

  function follow(address _follow) public {
    
    followers[msg.sender][_follow] = true;
  }

  function unFollow(address _unFollow) public {
    
    followers[msg.sender][_unFollow] = false;
  }

}