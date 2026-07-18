REPORT="${NUVYRA_REPORT:-.nuvyra/reports/NUVYRA_AUDIT.txt}"


echo "=================================" >> "$REPORT"
echo "     NUVYRA BLOCKCHAIN MONITOR" >> "$REPORT"
echo "=================================" >> "$REPORT"



check_rpc(){

NAME=$1
URL=$2


echo "" >> "$REPORT"
echo "NETWORK : $NAME" >> "$REPORT"
echo "RPC : $URL" >> "$REPORT"


START=$(date +%s%3N)


RESULT=$(curl -s \
-X POST \
-H "Content-Type: application/json" \
--data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
"$URL")



END=$(date +%s%3N)

TIME=$((END-START))



if echo "$RESULT" | grep -q "result"
then

echo "STATUS : ONLINE" >> "$REPORT"
echo "LATENCY : ${TIME}ms" >> "$REPORT"

else

echo "STATUS : FAILED" >> "$REPORT"

fi


}



check_rpc \
"Ethereum Mainnet" \
"https://cloudflare-eth.com"


check_rpc \
"Sepolia Testnet" \
"https://rpc.sepolia.org"


check_rpc \
"Polygon" \
"https://polygon-rpc.com"


check_rpc \
"Base" \
"https://mainnet.base.org"



echo "" >> "$REPORT"
echo "FIN MONITOR" >> "$REPORT"

echo "$REPORT"

