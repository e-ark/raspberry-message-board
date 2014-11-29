#! /bin/sh

# Prev update: 8/23/2014 by hohno
# Last update: Sat Nov 29 07:48:18 JST 2014 by hohno

# ----------------------------------------------------------
# Definition and initialize global variables
# ----------------------------------------------------------

# LANG=C export LANG
# LC_ALL=C export LC_ALL

# ----------------------------------------------------------

TRUE="TRUE"
FALSE="FALSE"

# ----------------------------------------------------------

echo="/bin/echo"	# Do NOT use built-in version of "echo" on /bin/sh

rm=/bin/rm
wc=/usr/bin/wc
awk=/usr/bin/awk
cat=/bin/cat
sed=/usr/bin/sed
tee=/usr/bin/tee
expr=/bin/expr
egrep=/usr/bin/egrep
trans270=$HOME/bin/trans270.rb
getbitmapfont=$HOME/bin/getbitmapfont.sh

basename=/usr/bin/basename

# ----------------------------------------------------------

cmdsfound="$TRUE"

for x in rm wc awk cat sed tee expr egrep trans270 getbitmapfont basename; do
    cmd=`eval $echo '$'$x`
    if [ "x$cmd" = "x" ]; then
	cmdsfound="$FALSE"
      ( $echo "" 
	$echo "*** Fatal Error *** NULL string found while searching for the full path of comamnd \"$x\"." ) 1>&2
    elif [ ! -x "$cmd" ]; then
	cmdsfound="$FALSE"
      ( $echo ""
	$echo "*** WARNING *** Can't execute $cmd" ) 1>&2
    fi
done

if [ "x$cmdsfound" != "x$TRUE" ]; then
  ( $echo ""
    $echo "*** EMERGENCY STOP !!! ***"
    $echo "" ) 1>&2
    exit 1
fi

PNAME="`($basename $0 || $echo $0) 2> /dev/null`"

# ----------------------------------------------------------
# Flags
# ----------------------------------------------------------

flag_help="$FALSE"
flag_verbose="$FALSE"

# ----------------------------------------------------------
# Functions
# ----------------------------------------------------------

usage() {
  $echo ""
  $echo "$PNAME [BGColor_R BGColor_G BGColor_B FontColor_R FontColor_G FontColor_B Message] [-m Message | -x]"
  $echo ""
}

hexdec() {
 $echo "$1" | $egrep "^0[xX][0-9a-fA-F][0-9a-fA-F]"
}

# ----------------------------------------------------------
# Main routine
# ----------------------------------------------------------

mode=

while [ "x$1" != "x" ]; do
  case $1 in
    -v)	flag_verbose="$TRUE"; shift;;
    -q)	flag_verbose="$FALSE"; shift;;
    -m) mode=m; shift;;
    -x) mode=x; shift;;
    -h|-help|--help)  flag_help="$TRUE"; break;;
    *)	break;;
  esac
done

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

if [ "x$mode" = "x" ]; then
  # XXX
  if [ "x`hexdec $6`" != "x" ]; then
    BGC_R=$1; [ "x`hexdec $BGC_R`" = "x" ] && BGC_R=0x07
    BGC_G=$2; [ "x`hexdec $BGC_G`" = "x" ] && BGC_G=0x75
    BGC_B=$3; [ "x`hexdec $BGC_B`" = "x" ] && BGC_B=0xc4
    FNT_X=$4; [ "x`hexdec $FNT_X`" = "x" ] && FNT_X=0xff
    FNT_Y=$5; [ "x`hexdec $FNT_Y`" = "x" ] && FNT_Y=0xff
    FNT_Z=$6; [ "x`hexdec $FNT_Z`" = "x" ] && FNT_Z=0xff
    # echo "[$BGC_R] [$BGC_G] [$BGC_B] [$FNT_X] [$FNT_Y] [$FNT_Z]" 1>&2
    shift; shift; shift; shift; shift; shift; 
  
    if [ "x$1" = "x-x" ]; then
      mode=x
      shift
    
    elif [ "x$1" = "x-m" ]; then
      mode=m
      shift
    fi  
  fi
fi

# XXX
[ "x`hexdec $BGC_R`" = "x" ] && BGC_R=0x07
[ "x`hexdec $BGC_G`" = "x" ] && BGC_G=0x75
[ "x`hexdec $BGC_B`" = "x" ] && BGC_B=0xc4
[ "x`hexdec $FNT_X`" = "x" ] && FNT_X=0xff
[ "x`hexdec $FNT_Y`" = "x" ] && FNT_Y=0xff
[ "x`hexdec $FNT_Z`" = "x" ] && FNT_Z=0xff

# echo "[$BGC_R] [$BGC_G] [$BGC_B] [$FNT_X] [$FNT_Y] [$FNT_Z]" 1>&2

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

if [ "x$flag_help" = "x$TRUE" ]; then
  usage;
  $echo ""
  exit 1
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

TMPDIR=/tmp/$USER
[ -d $TMPDIR ] || mkdir $TMPDIR
[ -d $TMPDIR ] || exit 9

TMPFILE="$TMPDIR/tmp.zzz"
BEFORE="$TMPDIR/tmp-before"
AFTER="$TMPDIR/tmp-after"

$rm -f $TMPFILE $BEFORE $AFTER
[ -f $TMPFILE ] && exit 9
[ -f $BEFORE ] && exit 9
[ -f $AFTER ] && exit 9

FONTWIDTH=16

STR="$@"
#echo "[$mode]" 1>&2
#echo "[$STR]" 1>&2

if [ "x$mode" = "xx" ]; then
  STR=""
  STR="$STR 天海春香"
  STR="$STR 如月千早"
  STR="$STR 星井美希"
  STR="$STR 秋月律子"
  STR="$STR 双海亜美"
  STR="$STR 双海真美"
  STR="$STR 萩原雪歩"
  STR="$STR 菊地真"
  STR="$STR 三浦あずさ"
  STR="$STR 我那覇響"
  STR="$STR 四条貴音"
  STR="$STR 高槻やよい"
  STR="$STR 水瀬伊織"
  STR="$STR "
  XCMD=$echo
  XOPT=$STR

elif [ "x$mode" = "xm" ]; then
  XCMD=$echo
  XOPT=$STR

else
  XCMD=$cat
  XOPT=
fi

$rm -f $TMPFILE $BEFORE $ARTER

$cat << ==EOF== > $TMPFILE
P3
# stdin
$FONTWIDTH XXXX
255
==EOF==

$XCMD $XOPT \
| $getbitmapfont \
| $awk -F, '{printf "%s%s\n",$3,$4}' \
| $sed -e '/^$/d' \
| $tee $BEFORE \
| $sed 's/\(.\)/\1 /g' \
| $trans270 \
| $tee $AFTER \
| $sed \
  -e 's/0/R G B /g' \
  -e 's/1/X Y Z /g' \
  -e "s/R/$BGC_R/g" \
  -e "s/G/$BGC_G/g" \
  -e "s/B/$BGC_B/g" \
  -e "s/X/$FNT_X/g" \
  -e "s/Y/$FNT_Y/g" \
  -e "s/Z/$FNT_Z/g" \
| $awk '{print $0;}' \
>> $TMPFILE

x=`$wc -l $TMPFILE | $awk '{print $1}'`
x=`$expr $x - 4`

$sed -e "s/$FONTWIDTH XXXX/$FONTWIDTH $x/" < $TMPFILE

$rm -f $BEFORE $AFTER
$rm -f $TMPFILE

exit 0

