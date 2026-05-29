// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {confirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/FunctionsRequest.sol";

/*
 * @title dTSLA 
 * @author Mushuka Mulenga
 */
contract dTSLA is ConfirmedOwner, FunctionsClient() {
    using FunctionsRequest for FunctionsRequest.Request;

    enum MinOrRedeem {
        mint,
        redeem
    }

    struct dTslaRequest {
        uint256 amountofToken;
        address requester;
        MinOrRedeem minOrRedeem;
    }

    address constant SEPOLIA_FUNCTIONS_ROUTER = "add sepolia address here!!!";
    bytes32 constant DON_ID = hex"add from 'chainlink network', there should be an address for (DON)";
    uint32 constant GAS_LIMIT = 300_000;
    uint64 immutable i_subId;

    String private s_mintSourceCode;
    mapping (bytes32 requestId => dTslaRequest request) private s_requestIdToRequest;

    constructor(string memory mintSourceCode, uint64 subId) ConfirmedOwner(msg.sender) FunctionsClient
    (SEPOLIA_FUNCTIONS_ROUTER) {
        s_mintSourceCode = mintSourceCode;
        i_subId = subId;
    }

    /// Send an HTTP request to:
    /// 1. See how much TSLA is bought
    /// 2. If enough TSLA is in the alpaca account,
    /// mint dTSLA. 
    /// 2 transaction function
    function sendMintRequest(uint256 amount) external onlyOwner returns(bytes32){
        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(s_mintSourceCode);
        bytes32 requestId = _sendRequest(req.encodeCBOR(), i_subId, GAS_LIMIT, DON_ID);
        s_requestIdToRequest[requestId] = dTslaRequest(amount, msg.sender, MinOrRedeem.mint);
        return requestId;
    }

    function _mintFulFillRequest() internal {}

    /// @notice User sends a request to sell TSLA for USDC (redeemptionToken)
    /// This will have the chainlink function call our alpaca (bank)
    /// and do the following:
    /// 1. Sell TSLA on the brokerage
    /// 2. Buy USDC on the brokerage
    /// 3. Send USDC to this contract's address for the user to withdraw
    function sendRedemmRequest() external {}

    function _redeemFulFillRequest() internal {}

    function fulfillRequest(bytes32 requestId, bytes memory response, bytes memory /*err*/ ) internal override {
        if (s_requestIdToRequest[requestId].mintOrRedeem.mint) {
            _mintFulFillRequest();
        } else {
            _redeemFulFillRequest();
        }
    }
    
}