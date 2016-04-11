#!/bin/bash

if test $# -ne 1
then
    echo "usage: $0 <html-file-name>"
    exit 1
fi

name=${1%.html}

n=$(grep -c '"slide"' pipeline.html)

export GOOGLE_API_KEY=0 GOOGLE_DEFAULT_CLIENT_ID=0 GOOGLE_DEFAULT_CLIENT_SECRET=0
export DISPLAY=:17
Xvfb $DISPLAY -screen 0 1920x1080x24+32 &
fvwm 2>/dev/null &
chromium --kiosk $name.html 2>/dev/null &
echo -ne "-\r"
sleep 3

xsetroot -solid green
xdotool key F11

rm -f capture??.png
i=0
while test $i -lt $n
do
    echo -ne "$i\r"
    perl -MTime::HiRes -e 'Time::HiRes::usleep(0.2*1e6)'
    xwd -silent -root | convert - $(printf "capture%02d.png" $i)
    xdotool click 1
    ((i++))
done

xdotool key ctrl+shift+q

convert capture??.png $name.pdf
rm -f capture??.png

kill %2 %1
