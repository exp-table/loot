#!/bin/bash
source .env
forge script --broadcast --verify --etherscan-api-key $ETHERSCAN_KEY -vvvv script/Deploy.s.sol:Deploy --slow