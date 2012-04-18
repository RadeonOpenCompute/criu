#!/bin/sh

in=$1
codesout=$2
codes=`echo $2 | sed -e 's/include\///g'`
protosout=$3
protos=`echo $3 | sed -e 's/include\///g'`
asmout=$4
asmcommon=$5
prototypes=`echo $6 | sed -e 's/include\///g'`

codesdef=`echo $codes | tr "[[:space:]].-" _`
protosdef=`echo $protos | tr "[[:space:]].-" _`

echo "/* Autogenerated, don't edit */"	>  $codesout
echo "#ifndef $codesdef"		>> $codesout
echo "#define $codesdef"		>> $codesout

echo "/* Autogenerated, don't edit */"	>  $protosout
echo "#ifndef $protosdef"		>> $protosout
echo "#define $protosdef"		>> $protosout
echo "#include \"$prototypes\""		>> $protosout
echo "#include \"$codes\""		>> $protosout

echo "/* Autogenerated, don't edit */"	>  $asmout
echo "#include \"$codes\""		>> $asmout
echo "#include \"$asmcommon\""		>> $asmout

cat $in | egrep -v '^#' | sed -e 's/\t\{1,\}/|/g' | awk -F '|' '{print "#define", $1, $2}'		>> $codesout
cat $in | egrep -v '^#' | sed -e 's/\t\{1,\}/|/g' | awk -F '|' '{print "extern long ", $3, $4, ";"}'	>> $protosout
cat $in | egrep -v '^#' | sed -e 's/\t\{1,\}/|/g' | awk -F '|' '{print "SYSCALL(", $3, ",", $2, ")"}'	>> $asmout

echo "#endif /* $codesdef */"		>> $codesout
echo "#endif /* $protosdef */"		>> $protosout
