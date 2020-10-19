pragma solidity >=0.6.2 <0.7.0;

contract CrowdFunding
{
    address private owner;

    uint constant private FUNDING_GOAL = 20 ether;

    mapping (address => uint) private funders;
    address[] private funders_address_arr;
    uint private current_funding;

    event log_contract_made(address indexed _address);
    event log_deposit_made(address indexed _address, uint amount);
    event log_withdraw_made(address indexed _address, uint amount);
    event log_transfer_made(uint amount);

    constructor() public
    {
        owner = msg.sender;

        current_funding = 0 ether;

        emit log_contract_made(owner);
    }

    function get_balance() public view returns (uint)
    {
        return address(this).balance;
    }

    function is_funding_goal_reached() public view returns (bool)
    {
        if (current_funding >= FUNDING_GOAL)
        {
            return true;
        }

        return false;
    }

    function deposit() public payable returns (bool)
    {
        if ((true == is_funding_goal_reached()) ||
            (msg.value < 1 ether))
        {
            revert();
        }

        current_funding += msg.value;
        funders[msg.sender] += msg.value;

        emit log_deposit_made(msg.sender, msg.value);

        return true;
    }

    function withdraw(uint withdraw_amount) public returns (bool)
    {
        if ((true == is_funding_goal_reached()) ||
            (withdraw_amount < 1 ether) ||
            (withdraw_amount > funders[msg.sender]))
        {
            return false;
        }

        msg.sender.transfer(withdraw_amount);

        current_funding -= withdraw_amount;
        funders[msg.sender] -= withdraw_amount;

        emit log_withdraw_made(msg.sender, withdraw_amount);

        return true;
    }

    function transfer_to_distribute_funding(address distribute_funding_address) public payable returns (bool)
    {
        if (true == is_funding_goal_reached())
        {
            address payable payable_address = payable(distribute_funding_address);

            payable_address.transfer(current_funding);

            for (uint it = 0; it < funders_address_arr.length; it += 1)
            {
                funders[funders_address_arr[it]] = 0 ether;
            }

            current_funding = 0 ether;

            emit log_transfer_made(current_funding);
        }
    }

    fallback () external payable
    {

    }
}
