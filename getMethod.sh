#!/bin/bash

afile=$1
method=$2
showContents=1
recursive=1
nextMethod=$method

getMethod() {
awk "/.+\(/ {
  if (! /\)\;/ && ! /if\ *\t*\(/ && !/for\ *\t*\(/ && ! /while\ *\t*\(/) {
    hit=1; m=0; got_br=0; k=1
  }
}
{
  if (hit==1) {
    if (/{/) {m++; got_br=1}
    if (/}/) {m--; got_br=-1}
    if (/${method} *\(.*\)\;/) {
       show=1
       mname=a[1]
    }
    if (got_br==0) {
      a[k]=sprintf(\"%4d %s\", NR,\$0); k++
    } else if (m < 0) {
      hit=0; show=0;
    } else if (m > 0) {
      a[k]=sprintf(\"%4d %s\", NR,\$0); k++
    } else if (m==0) {
      hit=0;
      a[k]=sprintf(\"%4d %s\", NR,\$0);
      if (show==1) {
        show=0;
        #print mname;
	n=split(mname, xname, \"(\");
	if (n) {
	  n=split(xname[1], yname, \" \");
	  if (n) {
	    print yname[n]
            if ($recursive) {
              #print yname[n] >> tmp_mname
            }
	  }
 	}
        if ($showContents) {
            for (i=1; i<=k; i++) {
              #print a[i]
            }
        }
      }
    }
  }
}" ${afile}

}

while [ ! -z $method ]
do
    method=`getMethod`
    echo $method
#exit 0
done
