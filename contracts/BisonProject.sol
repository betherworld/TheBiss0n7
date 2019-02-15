pragma solidity ^0.5.1;

contract BisonProject {

  address owner;
  uint unclaimedGreenTokens;   // funds which are still available to spend for sth.
  uint unclaimedCommunityTokens;    // funds which are still available to spend for sth.
  mapping (address => uint) communityTokenBalance;
  mapping (address => uint) greenTokenBalance;

  event Donation(address from, uint greenTokens, uint communityTokens);

  constructor () public {
    owner = msg.sender;
    unclaimedGreenTokens = 0;
    unclaimedCommunityTokens = 0;
  }

  // create new tokens when a donation was received.
  function insertNewDonation(uint greenTokens, uint communityTokens) public {
    if (msg.sender != owner) return;
    unclaimedGreenTokens += greenTokens;
    unclaimedCommunityTokens += communityTokens;
    emit Donation(msg.sender, greenTokens, communityTokens);
  }

  // once an action claim was validated, the rewards/tokens are transferred to the individual.
  function increaseTokens(address addr, uint greenTokens, uint communityTokens) public {
    if (msg.sender != owner) return;
    if (unclaimedGreenTokens < greenTokens || unclaimedCommunityTokens < communityTokens) return;
    unclaimedGreenTokens -= greenTokens;
    unclaimedCommunityTokens -= communityTokens;
    greenTokenBalance[addr] += greenTokens;
    communityTokenBalance[addr] += communityTokens;
  }

  // multi-purpose function to deduct tokens from an account
  function decreaseTokens(uint greenTokens, uint communityTokens) public {
    if (greenTokenBalance[msg.sender] < greenTokens || communityTokenBalance[msg.sender] < communityTokens) return;
    greenTokenBalance[msg.sender] -= greenTokens;
    communityTokenBalance[msg.sender] -= communityTokens;
  }

  // all participants are allowed to send tokens to each other.
  function sendGreenTokens(address receiver, uint amount) public {
    if (greenTokenBalance[msg.sender] < amount) return;
    greenTokenBalance[msg.sender] -= amount;
    greenTokenBalance[receiver] += amount;
  }

  function queryGreenTokenBalance(address addr) public view returns (uint) {
    return greenTokenBalance[addr];
  }

  function queryCommunityTokenBalance(address addr) public view returns (uint) {
    return communityTokenBalance[addr];
  }

}
