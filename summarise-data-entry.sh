#!/bin/sh

entry="$1"

printf '%s\t' $(basename $entry)

printf '%d\t' $(grep -c '^processor' $entry/cpuinfo)

awk '/^Mem:/ { printf "%s MB", ($2 / 1024) }' $entry/free
printf '\t'

# printf '%s\t' $(awk '/^Hardware/ { print $3 }' $entry/cpuinfo)

revision=$(awk '/^Revision/ { print $3 }' $entry/cpuinfo)
case "$revision" in
    0002) kind="B v1.0";;
    0003) kind="B v1.0";;
    0004) kind="B v2.0";;
    0005) kind="B v2.0";;
    0006) kind="B v2.0";;
    0007) kind="A v2.0";;
    0008) kind="A v2.0";;
    0009) kind="A v2.0";;
    000d) kind="B v2.0";;
    000e) kind="B v2.0";;
    000f) kind="B v2.0";;
    0010) kind="B+ v1.2";;
    0011) kind="CM1 v1.0";;
    0012) kind="A+ v1.1";;
    0013) kind="B+ v1.2";;
    0014) kind="CM1 v1.0";;
    0015) kind="A+ v1.1";;
    *??????)
        rev=" rev $(echo $revision | sed -e 's/.*\(.\)/\1/')"
        case "$revision" in
            *???00?) model='A';;
            *???01?) model='B';;
            *???02?) model='A+';;
            *???03?) model='B+';;
            *???04?) model='2B';;
            *???06?) model='CM1';;
            *???08?) model='3B';;
            *???09?) model='Zero';;
            *???0a?) model='CM3';;
            *???0c?) model='Zero W';;
            *???0d?) model='3B+';;
            *???0e?) model='3A+';;
            *???10?) model='CM3+';;
            *)
                model='?$revision'
                rev=''
                ;;
        esac
        kind="$model$rev";;
    *) kind="UNKNOWN $revision";;
esac
printf '%s\t' "$kind"

awk 'BEGIN { FS=":"; ORS=" "; }; /^[a-zA-Z0-9]/ { if ($1 != "lo") { print $1 } }' $entry/ifconfig \
    | sed -e 's/ \+$//'

printf '\n'
