source .env
forge script --broadcast -g 100 --verify --etherscan-api-key $ETHERSCAN_KEY -vvvv script/Deploy.s.sol:Deploy --slow