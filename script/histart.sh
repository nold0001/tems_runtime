#!/bin/bash

source ~/tems/.temsrc

##########################################################################################
# Font directory priority
#    1. bronto_hi_fontdir
#    2. ${RUNTIME_HOME}/fonts
#    3. ${RUNTIME_HOME}/font
#    4. QT_QPA_FONTDIR
#
# command for changing Font directory to ${RUNTIME_HOME}/fonts
#    -. ln -s <legacy font dir> ${RUNTIME_HOME}/fonts
#       e.g.> ln -s /usr/share/fonts/truetype/unfonts-core ${RUNTIME_HOME}/fonts
#
##########################################################################################
#UNFONTS_FONTDIR=/usr/share/fonts/truetype/dejavu
NANUM_FONTDIR=/usr/share/fonts/truetype/ubuntu

if [ "${#UNFONTS_FONTDIR}" -gt 0 ] && [ -d "${UNFONTS_FONTDIR}" ]; then FONTDIR="${UNFONTS_FONTDIR}"
elif [ "${#NANUM_FONTDIR}" -gt 0 ] && [ -d "${NANUM_FONTDIR}" ]; then FONTDIR="${NANUM_FONTDIR}"
fi
export bronto_hi_fontdir=${FONTDIR}

###${RUNTIME_HOME}/bin/hi cfg/hi.conf &
${RUNTIME_HOME}/bin/hi cfg/hi.conf
# ~/nsui/hyosung/build-hi-Qt_Static-Profile/hi cfg/hi.conf &

exit

