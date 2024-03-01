// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

contract Demo{
    function add(uint a, uint b) public pure returns(uint){
        return a+b;
    }
    
    function sub(uint a, uint b) public pure returns(uint){
        return a-b;
    }

    function mul(uint a, uint b) public pure returns(uint){
        return a*b;
    }

    function div(uint a, uint b) public pure returns(uint){
        return a/b;
    }
}