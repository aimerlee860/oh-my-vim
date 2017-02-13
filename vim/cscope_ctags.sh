#!/bin/sh
find $1 -name "*.h" -o -name "*.c" -o -name "*.s" -o -name "*.cpp" -o -name "*.inl" > cscope.files

cscope -bkq -i cscope.files
ctags -R  --c++-kinds=+p --fields=+iaS --extra=+q 
