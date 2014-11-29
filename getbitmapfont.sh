#! /bin/sh

# Prev update: Mon Dec 26 08:16:28 JST 2011 by hohno
# Prev update: Tue Nov 27 06:49:20 JST 2012 by hohno
# Prev udpate: Wed Jan 15 11:02:41 JST 2014 by hohno
# Prev udpate: Fri Jul 18 00:09:22 JST 2014 by hohno
# Last update: Sat Nov 29 05:42:17 JST 2014 by hohno

# ----------------------------------------------------------
# Definition and initialize global variables
# ----------------------------------------------------------

# LANG=C export LANG
# LC_ALL=C export LC_ALL

# ----------------------------------------------------------

TRUE="TRUE"
FALSE="FALSE"

# ----------------------------------------------------------

[ "x$TARGETFONTNAME" = "x" ] && TARGETFONTNAME="kanji16"
[ "x$TARGETFONTSIZE" = "x" ] && TARGETFONTSIZE="16"

# ----------------------------------------------------------

ECHO="/bin/echo"	# Do NOT use built-in version of "echo" on /bin/sh

# BDUMP=/opt/local/bin/bdump
EGREP=/usr/bin/egrep
GAWK=/opt/local/bin/gawk
HAN2ZEN=$HOME/bin/h2z.rb
HEXDUMP=/usr/bin/hexdump
NKF=/usr/local/bin/nkf
PERL=/usr/bin/perl
SED=/usr/bin/sed
SHOWFONT=/usr/X11R6/bin/showfont
TR=/usr/bin/tr
# VFONT_ROTATE=$HOME/bin/vfont-should-be-rotated.sh
VFONT_ROTATE=/bin/cat
XARGS=/usr/bin/xargs

BASENAME=/usr/bin/basename

# ----------------------------------------------------------

cmdsfound="$TRUE"

for x in EGREP GAWK HAN2ZEN HEXDUMP NKF PERL SED SHOWFONT TR VFONT_ROTATE XARGS BASENAME; do
    cmd=`eval /bin/echo '$'$x`
    if [ "x$cmd" = "x" ]; then
	cmdsfound="$FALSE"
      ( $ECHO ""
	$ECHO "*** Fatal Error *** NULL string found while searching for the full path of comamnd \"$x\"." ) 1>&2
    elif [ ! -x "$cmd" ]; then
	cmdsfound="$FALSE"
      ( $ECHO ""
	$ECHO "*** WARNING *** Can't execute $cmd" ) 1>&2
    fi
done

if [ "x$cmdsfound" != "x$TRUE" ]; then
  ( $ECHO ""
    $ECHO "*** EMERGENCY STOP !!! ***"
    $ECHO "" ) 1>&2
    exit 1
fi

PNAME="`($BASENAME $0 || $ECHO $0) 2> /dev/null`"

# ----------------------------------------------------------
# Flags
# ----------------------------------------------------------

flag_help="$FALSE"
flag_verbose="$FALSE"

# ----------------------------------------------------------
# Functions
# ----------------------------------------------------------

usage() {
    $ECHO ""
    $ECHO "Usage: `/usr/bin/basename $0` < text.dat"
    $ECHO ""
    $ECHO "Note: Don't forget to run xfs (font server) before running this command."
    $ECHO ""
}

showtips() {
/bin/cat << '--EOF--'
How to use this command ?

(1) get bitmap font data
    % ./ThisCommand < text.dat > /tmp/example.dat

(2) create hexadecimal font data written in C language.
    % cat /tmp/example.dat | awk '{if (/^#/){cnt++;printf "%-5s, ",$3;if(cnt%4==0){printf "\n";}}}END{printf "\n";}'

(3) create font rotation data written in C language.
    % cat /tmp/example.dat | awk -F, '{if (\!/^#/){cnt++;printf "  %s, %s,",$1,$2;if (cnt%4==0){printf "\n";}}else{printf "\n"}}'

--EOF--
}

# ----------------------------------------------------------
# Main routine
# ----------------------------------------------------------

while [ "x$1" != "x" ]; do
    case $1 in
	-v)	    flag_verbose="$TRUE"; shift;;
	-q)	    flag_verbose="$FALSE"; shift;;
	-h|-help|--help)  flag_help="$TRUE"; break;;
	*)	    break;;
    esac
done

if [ "x$flag_help" = "x$TRUE" ]; then
    usage 1>&2
    showtips 1>&2
    $ECHO ""
    exit 1
fi

# ----------------------------------------------------------

$NKF -w \
| $HAN2ZEN | $SED -e "s/^\"//" -e "s/\"$//" \
| $TR -d '\n' \
| $NKF -j \
| $HEXDUMP | $SED -e 's/$/ /' -e 's/^[0-9A-Fa-f]* / /' \
| $TR -d '\n' \
| $SED -e 's/  */ /g' -e 's/1[bB] 24 42//g' -e 's/1[bB] 28 42//g' \
| $SED -e 's/  */ /g' -e 's/ \([0-9A-Fa-f][0-9A-Fa-f]\) \([0-9A-Fa-f][0-9A-Fa-f]\)/ \1\2/g' \
| $TR ' ' '\n' \
| $GAWK '{if (NF>0){printf "%3d\n",strtonum("0x"$1)}}' \
| $XARGS -I % $SHOWFONT -b 2 -start % -end % -fn $TARGETFONTNAME \
| $EGREP '^-|^#|^char' \
| $SED -e '/^[-#]/s/-/0/g' -e '/^[0#]/s/#/1/g' -e 's/ #/ /g' -e '/^char/s/^/# /g' \
| $PERL -n -e 'if (/^#/){print} else {printf "0x%s,0x%s,%s,%s,\n", unpack("H2", pack("B8",substr($_,0,8))), unpack("H2", pack("B8",substr($_,8,8))),substr($_,0,8),substr($_,8,8)}' \
| $VFONT_ROTATE

# ----------------------------------------------------------

$ECHO ""

exit 0
