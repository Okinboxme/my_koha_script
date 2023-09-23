#!/bin/bash
extIP=$(wget -qO- https://ipecho.net/plain; echo);
kohaPass=$(sudo koha-passwd mainlibrary);
echo "";
echo "/*********************************************************";
echo "*******Access to http://"$extIP"            ***************";
echo "**";
echo "**";
echo "**********************************************************";
echo "USER: koha_mainlibrary"
echo "PASS: "$kohaPass;
echo ""
echo "***********************/"
