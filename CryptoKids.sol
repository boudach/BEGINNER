// SPDX-License-Identifier: MIT                                                                               

pragma solidity ^ 0.8.7;

contract Cryptokids{
    address owner;

    constructor( ){
        owner = msg.sender ;
    }

    struct Kid {
        address payable walletAddress;
        string firstname;
        string lastname;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }
    Kid[] public kids;

    function addKid( address payable  walletAddress, string memory firstname, string memory lastname,
     uint releaseTime, uint amount, bool canWithdraw) public {
     
     kids.push(Kid(
       walletAddress,
       firstname,
       lastname,
       releaseTime,
       amount,
       canWithdraw
     ));
   
   }
   function balanceof() public view returns (uint) {
       return address(this).balance;

   }
   function deposit (address walletAddress) payable public{
      addToKidsBalance(walletAddress);
   }
   function getIndex(address walletAddress) view private returns (uint){
         for (uint i = 0; i < kids.length; i++) {
              if(kids[i].walletAddress == walletAddress)
               return i;
         }     
    return 999;
   }

      function addToKidsBalance(address walletAddress) private {
          for (uint i = 0; i < kids.length; i++) {
              if(kids[i].walletAddress == walletAddress) {
                  kids[i].amount += msg.value;
              }
          }
        }
      function availableToWithdraw (address  walletAddress) public returns  (bool) {
          uint i = getIndex(walletAddress);
          if (block.timestamp > kids[i].releaseTime) {
              kids[i].canWithdraw = true;
              return true;
          } else{
              return false;
          }
      }
     function withdraw( address payable walletAddress) payable public {
         uint i = getIndex(walletAddress);
         kids[i].walletAddress.transfer(kids[i].amount);
     }
      
        
}
