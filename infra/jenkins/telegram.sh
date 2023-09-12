#!/bin/bash
SENDME=$1
TG_BOT_ID=6612780049:AAFN1EPIxZJYZwURiMC3Cx1XYEFlDeeNdOs
TG_CHAT_ID=-1001859723546
curl --socks5-basic \
-X POST https://api.telegram.org/bot$TG_BOT_ID/sendMessage -d chat_id=$TG_CHAT_ID -d \
text="$SENDME"
cat $SENDME > /tmp/$SENDME && \
curl --socks5-basic \
-s -X POST https://api.telegram.org/bot$TG_BOT_ID/sendDocument -F chat_id=$TG_CHAT_ID -F \
document=@/tmp/$SENDME
rm -f /tmp/$SENDME