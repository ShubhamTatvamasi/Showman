pragma solidity ^0.4.0;

contract Showman {

  mapping (address => User) public users;
  mapping (address => Post[]) public posts;
  mapping (address => mapping (address => bool)) public followers;

  struct User {
    string name;
    string description;
  }    

  struct Post {
    string post;
    uint time;
  }    

  function updateUserName(string _name) public {

    users[msg.sender].name = _name;
  }

  function updateUserDescription(string _description) public {

    users[msg.sender].description = _description;
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