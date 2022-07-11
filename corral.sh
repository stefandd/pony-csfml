echo "BUILDING SHIM LIB"
DIR="shim library"
clang -c -o "$DIR/csfmlshim.o" "$DIR/csfmlshim.c"
ar -rc "$DIR/libcsfmlshim.a" "$DIR/csfmlshim.o"
