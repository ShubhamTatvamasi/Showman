pragma solidity ^0.4.0;

contract Showman {

  mapping (address => User) public users;
  mapping (address => Post[]) public posts;

  mapping (address => mapping (address => bool)) public isFollowing;

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

  function totalPosts(address _add) public view returns (uint) {

  	return posts[_add].length;
  }

  function follow(address _follow) public {
    
    following[msg.sender][following[msg.sender].length++] = _follow;

    followers[_follow][followers[_follow].length++] = msg.sender;

    isFollowing[msg.sender][_follow] = true;
  }

  function unFollow(address _unFollow) public {
    
    for (uint i = 0; i < following[msg.sender].length;i++) {

      if (following[msg.sender][i] == _unFollow) {

        following[msg.sender][i] = following[msg.sender][following[msg.sender].length-1];
        following[msg.sender].length--;
      }  
    }

    for (uint j = 0; j < followers[_unFollow].length; j++) {
      
      if (followers[_unFollow][j] == msg.sender) {

        followers[_unFollow][j] = followers[_unFollow][followers[_unFollow].length-1];
        followers[_unFollow].length--;
      }
    }

    isFollowing[msg.sender][_unFollow] = false;
  }

}