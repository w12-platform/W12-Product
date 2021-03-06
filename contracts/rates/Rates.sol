pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/ownership/Secondary.sol";
import "./IRates.sol";
import "../access/roles/IPricerRole.sol";
import "../access/roles/PricerRole.sol";
import "./Symbols.sol";


contract Rates is IRates, Symbols, PricerRole, Secondary {
    mapping (bytes32 => uint) private rates;
    mapping (bytes32 => address) private tokenAddress;

    function addSymbolWithTokenAddress(bytes32 symbol, address _address) public onlyPricer {
        Symbols.addSymbol(symbol);

        if (_address != address(0)) setTokenAddress(symbol, _address);
    }

    function addSymbol(bytes32 symbol) public onlyPricer {
        Symbols.addSymbol(symbol);
    }

    function removeSymbol(bytes32 symbol) public onlyPricer {
        setTokenAddress(symbol, address(0));
        Symbols.removeSymbol(symbol);
        rates[symbol] = 0;
    }

    function setTokenAddress(bytes32 symbol, address _address) public onlyPricer {
        require(hasSymbol(symbol));

        tokenAddress[symbol] = _address;
    }

    function getTokenAddress(bytes32 symbol) public view returns(address) {
        require(isToken(symbol));

        return tokenAddress[symbol];
    }

    function isToken(bytes32 symbol) public view returns (bool) {
        require(hasSymbol(symbol));

        return tokenAddress[symbol] != address(0);
    }

    function addPricer(address account) public onlyPrimary {
        _addPricer(account);
    }

    function removePricer(address account) public onlyPrimary {
        _removePricer(account);
    }

    function get(bytes32 symbol) public view returns(uint) {
        require(hasSymbol(symbol));

        return rates[symbol];
    }

    function set(bytes32 symbol, uint rate) public onlyPricer {
        require(hasSymbol(symbol));

        rates[symbol] = rate;
    }
}
