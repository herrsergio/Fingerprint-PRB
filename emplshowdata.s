#
USAGE="$0 hrcempl.dat"
if [ $# -ne 1 ]
then
   echo "$USAGE"
   exit 0
fi

/usr/bin/ph/emplalt/bin/empl2ascii.s $1 | awk -F"|" '
{
  printf("%s %s|%s|%s|%s|%s\n", $3, $5, $22, $1, $81, $82);
}
' | sort

