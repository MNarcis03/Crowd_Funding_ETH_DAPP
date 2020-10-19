pragma solidity >=0.6.2 <0.7.0;

contract DistributeFunding
{
    address private owner;

    uint private MAX_NUM_OF_BENEFICIARIES = 1;

    mapping (address => uint) private beneficiaries;
    address[] private beneficiaries_arr;

    event log_contract_made(address indexed _address);
    event log_funding_made(uint amount);
    event log_enroll_made(address indexed _address, uint amount);

    constructor () public
    {
        owner = msg.sender;

        emit log_contract_made(msg.sender);
    }

    function get_address() public view returns (address)
    {
        return address(this);
    }

    function get_balance() public view returns (uint)
    {
        return address(this).balance;
    }

    function enroll() public payable returns (bool)
    {
        if ((beneficiaries_arr.length < MAX_NUM_OF_BENEFICIARIES) &&
            (0 < get_balance()))
        {
            uint funding = get_balance() / MAX_NUM_OF_BENEFICIARIES;

            beneficiaries_arr.push(msg.sender);

            beneficiaries[msg.sender] = funding;

            (msg.sender).transfer(funding);

            emit log_enroll_made(msg.sender, funding);

            return true;
        }

        return false;
    }

    receive () external payable
    {
        emit log_funding_made(msg.value);
    }
}
