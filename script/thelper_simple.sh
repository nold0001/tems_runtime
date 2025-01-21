#!/bin/bash

#source ~tems/.${BRONTO_PRODUCT_PREFIX}rc
. ~/tems/.${BRONTO_PRODUCT_PREFIX}rc
#export EDITOR=nano
umask 0002

export	COMMANDER_NAME=${BRONTO_PRODUCT_PREFIX}

function displayMenu()
{
	clear
	echo	""
	echo	"	+--------------------------------------+"
	echo	"	|        TEMS OPERATOR'S HELPER        |"
	echo	"	+--------------------------------------+"
	echo	"	|                                      |"
	echo	"	|  [7m P [0m display system process list     |"
	echo	"	|                                      |"
	echo	"	|  [7m V [0m run tpool viewer                |"
	echo	"	|                                      |"
	echo	"	|  [7m S [0m startup system                  |"
	echo	"	|                                      |"
	echo	"	|  [7m T [0m shutdown system                 |"
	echo	"	|                                      |"
	echo	"	|  [7m C [0m edit system config file         |"
	echo	"	|                                      |"
	echo	"	|                                      |"
	echo	"	|  [7m Q [0m quit                            |"
	echo	"	|                                      |"
	echo	"	+--------------------------------------+"
	echo	""
}

function readSelect()
{
	read -p	"		select menu : " ans
}

function readEnterKey()
{
	echo	""
	read -p "	press <enter> key ..."
}

while true
do
	displayMenu
	readSelect

	case "$ans" in
		[p,P])
			${COMMANDER_NAME} - ps
			readEnterKey
			;;
		[v,V])
			${BRONTO_PRODUCT_PREFIX}tpool
			;;
		[s,S])
			${COMMANDER_NAME} - start
			readEnterKey
			;;
		[t,T])
			${COMMANDER_NAME} - stop
			readEnterKey
			;;
		[c,C])
			$EDITOR ~/runtime/cfg/${BRONTO_PRODUCT_PREFIX}config.xml
			;;
		[q,Q,])
			echo	""
			echo	"	Done ^l^"
			echo	""
			break
			;;
	esac
done
exit

