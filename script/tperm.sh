#!/bin/bash

#source ~tems/.temsrc
. ~/tems/.temsrc

cd	${RUNTIME_BIN}

PROGLIST_TO_ROOT=( cslv )
PROGLIST_STICKY=( cslv )

for i in "${PROGLIST_TO_ROOT[@]}"
do
	sudo chown root ${BRONTO_PRODUCT_PREFIX}$i
done

for i in "${PROGLIST_STICKY[@]}"
do
	sudo chmod +s ${BRONTO_PRODUCT_PREFIX}$i
done

exit

