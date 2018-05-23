pragma solidity ^0.4.0;

contract Showman {

  mapping (address => string) public users;
  mapping (address => Post[]) public posts;

  struct Post {
    string post;
    uint time;
  }    


  function updateUser(string _name) public {

    users[msg.sender] = _name;
  }

  function newPost(string _post) public {

    uint p = posts[msg.sender].length++;

    posts[msg.sender][p].post = _post;
    posts[msg.sender][p].time = now;

  }  

  function totalPosts(address _add) public view returns (uint) {
  	return posts[_add].length;
  }


}