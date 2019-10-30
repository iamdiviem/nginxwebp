#!/bin/bash
webpbuilder ()
{
if [ ! -f "$1.webp" ]; then cwebp -q 80 $1 -o "$1.webp"; fi
}
export -f myfunc
find $1 -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png \) -exec bash -c 'webpbuilder "$@"' bash {} \;