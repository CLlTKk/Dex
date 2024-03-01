// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract DexPair is ERC20{

    IERC20 token1;
    IERC20 token2;


    uint reserve1;
    uint reserve2;

    uint k;

    constructor(address one, address two) ERC20("LPDex", "LPD"){
        token1 = IERC20(one);
        token2 = IERC20(two);
    }

    function addLiquidity(uint amount1, uint amount2) public{
        token1.transferFrom(msg.sender, address(this), amount1);
        token2.transferFrom(msg.sender, address(this), amount2);
        reserve1 += amount1;
        reserve2 += amount2;
        k = reserve1 * reserve2;
        _mint(msg.sender, Math.sqrt(amount1*amount2));
    }

    function removeLiquidity(uint amount) public {
        require(amount >= balanceOf(msg.sender), "Not enough tokens to burn");
        uint amount1 = amount*reserve1/totalSupply();
        uint amount2 = amount*reserve2/totalSupply();
        token1.transfer(msg.sender, amount1);
        token2.transfer(msg.sender, amount2);
        reserve1 -= amount1;
        reserve2 -= amount2;
        k = reserve1*reserve2;
        _burn(msg.sender, amount);
    }

    function swap(uint amount1, uint amount2) public {
        require(amount1 == 0 || amount2 == 0, "Amount1 or Amount2 should be 0");
        if(amount1>0){
            token1.transferFrom(msg.sender, address(this), amount1);
            token2.transfer(msg.sender, getPriceXtoY1(amount1));
            reserve1 += amount1;
            reserve2 -= getPriceXtoY1(amount1);
        }
        if(amount2>0){
            token2.transferFrom(msg.sender, address(this), amount2);
            token1.transfer(msg.sender, getPriceXtoY2(amount2));
            reserve2 += amount2;
            reserve1 -= getPriceXtoY2(amount2);
        }
        k = reserve1 * reserve2;
    }


    function getPriceXtoY1(uint amount) public view returns(uint){
        return reserve2 - (k/(reserve2+amount));
    }

    function getPriceXtoY2(uint amount) public view returns(uint){
        return reserve1 - (k/(reserve1+amount));
    }

    function getPriceYtoX(uint amount) public view returns(uint){
        return k/(reserve2-amount) - reserve1;
    }


}