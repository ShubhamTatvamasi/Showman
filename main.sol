pragma solidity ^0.4.0;

contract Showman {

  mapping (address => string) public users;
  mapping (address => string[]) public posts;





  function updateUser(string _name) public {

    users[msg.sender] = _name;
  }

  function newPost(string _post) public {

    posts[msg.sender][posts[msg.sender].length++] = _post;
  }  

  function totalPosts(address _add) public view returns (uint) {
  	return posts[_add].length;
  }


}