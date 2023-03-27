// SPDX-License-Identifier: MIT  

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract GameLord {

    uint internal no_of_sessions = 0;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
    address internal gameLordAddress = 0x19EC7f1D1E2399010C91AF7078D6Ef8dEC0BE93d;

    struct Session {
        address payable owner;
        uint stake;
    }

    mapping (uint => Session) internal sessions;

    function new_session () public {
        uint _stake = 0;
        sessions[no_of_sessions] = Session(
            payable(msg.sender),
            _stake
        );
        no_of_sessions++;
    }

    function get_session(uint _index) public view returns (
        address payable owner,
        uint _stake 
    ) {
        return (
            sessions[_index].owner,
            sessions[_index].stake
        );
    }

    function leave_session(uint _index, uint _stake) public {
        sessions[_index].stake = _stake;
    }

    function deposit(uint _index, uint _amt) public payable {
        require(
            IERC20Token(cUsdTokenAddress).transferFrom(
			sessions[_index].owner,
			gameLordAddress,
			_amt
		  ),
		  "Transfer failed."
		);
    }

    function withdraw(uint _index, uint _amt) public payable {
        require(
		  IERC20Token(cUsdTokenAddress).transferFrom(
			gameLordAddress,
			sessions[_index].owner,
			_amt
		  ),
		  "Transfer failed."
		);
    }
}
