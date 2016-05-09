
killall -9 node_runner
killall -9 bridge

build/x86_64/Debug/bridge/bridge -n -f bridge/config/bridge_config.json &

rm -rf /tmp/node_mount/*

sleep 1

./build/x86_64/Debug/node/node_runner -d -f node/config/node_config.json
