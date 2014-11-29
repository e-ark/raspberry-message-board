#! /bin/sh

# Prev update: 11/4/2014 by hohno
# Prev update: Sat Nov 29 11:21:32 JST 2014 by hohno
# Last update: Sat Nov 29 16:55:46 JST 2014 by hohno

# ----------------------------------------------------------

MYDATADIR=data
MYTMPFILE=$MYDATADIR/ALL.ppm

MYTEXTDATA=${1-"./textdata.txt"}
OUTFILE=${2-"OUTPUT.ppm"}

if [ ! -d "$MYDATADIR" ]; then
  mkdir $MYDATADIR
  if [ ! -d "$MYDATADIR" ]; then
    echo "Can't create $MYDATADIR"
    exit 9
  fi
fi
  
if [ ! -f "$MYTEXTDATA" ]; then
  echo "Can't open $MYTEXTDATA"
  exit 9
fi

if [ -f "$OUTFILE" ]; then
  echo "$OUTFILE already exists"
  exit 9
fi

# ----------------------------------------------------------

color_text_full () {
  C1=${1-0x00}
  C2=${2-0x00}
  C3=${3-0x00}
  C4=${4-0xff}
  C5=${5-0xff}
  C6=${6-0x1f}
  MESG=${7-"テストです。"}
  MYPPMFILE=${8-"./sample.ppm"}

  /bin/rm -f "$MYPPMFILE"
  sh text2ppm.sh "$C1" "$C2" "$C3" "$C4" "$C5" "$C6" -m "$MESG" | ./ppm-ascii2binary.rb > $MYPPMFILE
  sleep 0.1

  if [ -f "$MYPPMFILE" ]; then
    echo "$MYPPMFILE has been created."
  else
    echo "Can't create $MYPPMFILE "
  fi

  if [ "x$MYTMPFILE" != "x" -a -f "$MYTMPFILE" ]; then
    if [ -s "$MYTMPFILE" ]; then
      convert -append $MYTMPFILE $MYPPMFILE $MYTMPFILE
    else
      cp $MYPPMFILE $MYTMPFILE
    fi
  elif [ "x$MYTMPFILE" != "x" ]; then
    echo "Can't open $MYTMPFILE to append (You can ignore this)."
  fi
}

color_text () {
  export MYMESGCNT=$( printf "%03d" $( expr $MYMESGCNT + 1 ))
  color_text_full 0x00 0x00 0x00 "$1" "$2" "$3" "$4" "$MYDATADIR/$MYMESGCNT.ppm"
}

color_text2 () {
  export MYMESGCNT=$( printf "%03d" $( expr $MYMESGCNT + 1 ))
  color_text_full "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$MYDATADIR/$MYMESGCNT.ppm"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

c_white () {
color_text 0xff 0xff 0xff "$1"
}

c_black () {
color_text 0x00 0x00 0x00 "$1"
}

c_gray () {
color_text 0x40 0x40 0x40 "$1"
}

c_grey () {
  c_gray
}

c_red () {
color_text 0xff 0x00 0x00 "$1"
}

c_green () {
color_text 0x00 0xff 0x00 "$1"
}

c_blue () {
color_text 0x00 0x00 0xff "$1"
}

c_yellow () {
color_text 0xff 0xff 0x00 "$1"
}

c_magenta () {
color_text 0xff 0x00 0xff "$1"
}

c_cyan () {
color_text 0x00 0xff 0xff "$1"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

c__haruka () {
color_text 0xf7 0x0f 0x1f "$1"
}

c__chihaya () {
color_text 0x07 0x75 0xc4 "$1"
}

c__miki () {
color_text 0xa1 0xca 0x62 "$1"
}

c__ritsuko () {
color_text 0x00 0xa7 0x52 "$1"
}

c__ami () {
color_text 0xfc 0xd4 0x24 "$1"
}

c__mami () {
color_text 0xfc 0xd4 0x24 "$1"
}

c__yukiho () {
color_text 0xae 0xce 0xcb "$1"
}

c__makoto () {
color_text 0x46 0x4b 0x4f "$1"
}

c__hibiki () {
color_text 0x00 0xb1 0xbb "$1"
}

c__takane () {
color_text 0xb5 0x1d 0x66 "$1"
}

c__azusa () {
color_text 0x7e 0x51 0xa6 "$1"
}

c__yayoi () {
color_text 0xf2 0x90 0x47 "$1"
}

c__iori () {
color_text 0xfa 0x98 0xbf "$1"
}

# ----------------------------------------------------------

/bin/rm -f $MYTMPFILE || exit 1
/usr/bin/touch $MYTMPFILE || exit 2
/bin/rm -f $OUTFILE || exit 3

export MYMESGCNT=0
. $MYTEXTDATA

/usr/local/bin/convert -rotate 270 $MYTMPFILE $OUTFILE && echo Now $OUTFILE is ready

# ----------------------------------------------------------

exit 0

