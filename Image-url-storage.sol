// SPDX-License-Identifier: MIT
pragma solidity >=0.7.2 <0.9.0;

contract Upload {
    //XYZAddress wants to share Access
    struct Access{
        address user; // to which user 
        bool access; // True or false check
    }
    //Array mapping 
    mapping(address=>string[]) value; //block mapping 
    mapping(address=>mapping(address=>bool)) ownership; //Nested mapping
    mapping(address=>Access[])accessList;
    mapping(address=>mapping(address=>bool)) previousData; // previous data

    function add(address _user,string memory url) external {
        value[_user].push(url); //adress storing in dynamic array
    }
    function allow(address user) external {
        ownership[msg.sender][user]=true; //ownership mapping
        if(previousData[msg.sender][user]){
            for (uint i=0;i<accessList[msg.sender].length;i++){
                if(accessList[msg.sender][i].user==user){
                    accessList[msg.sender][i].access=true;
                }
            }
        }else{
            accessList[msg.sender].push(Access(user,true));
            previousData[msg.sender][user]=true;  //true
        }
    }
    function disallow(address user) public {
        ownership[msg.sender][user]=false; //here not allowed
        for(uint i=0;i<accessList[msg.sender].length;i++){ //false access point here
            if(accessList[msg.sender][i].user==user){
                accessList[msg.sender][i].access=false;  //false
            }
        }
    }
    //display part
    function display(address _user) external view returns(string[] memory){
        require(_user==msg.sender || ownership[_user][msg.sender], "You dont have access ");
        return value[_user];
    }
    // shared access list
    function shareAccess() public view returns (Access[] memory){
        return accessList[msg.sender];
    }
}
