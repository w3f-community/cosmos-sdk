#!/usr/bin/env bash

rm -rf ~/.nsd
rm -rf ~/.nscli

nsd init test --chain-id=namechain

# nscli config output json
# nscli config indent true
# nscli config trust-node true
# nscli config chain-id namechain
# nscli config keyring-backend test

# nscli --chain-id namechain --output json keys add jack
# nscli --chain-id namechain --output json keys add alice

export KEYPASSWD='12345678'

export ADDRESS='cosmos1s5vsakgzyjht4umu2zeqg3qlxceu7a0n98dl9a'
export SEED='hood depend mandate catalog minute close glare indicate surge lawn young sauce various chat rain quit airport battle glance father apart loud idea wagon'
(echo $SEED; echo $KEYPASSWD; echo $KEYPASSWD) | nscli --chain-id namechain --output json keys add jack --recover

export ADDRESS='cosmos1na88jjrtm4kfg4y8lqcqqqejz5aclncd5qymv8'
export SEED='riot evoke document section leg security smart velvet island where crouch dream ribbon lizard rabbit safe gas slow vivid correct term delay vital divorce'
(echo $SEED; echo $KEYPASSWD; echo $KEYPASSWD) | nscli --chain-id namechain --output json keys add alice --recover

echo $KEYPASSWD | nsd add-genesis-account $(nscli keys show jack -a) 1000nametoken,100000000stake
echo $KEYPASSWD | nsd add-genesis-account $(nscli keys show alice -a) 1000nametoken,100000000stake

echo $KEYPASSWD | nsd gentx jack --chain-id namechain

echo "Collecting genesis txs..."
nsd collect-gentxs

echo "Validating genesis file..."
nsd validate-genesis
