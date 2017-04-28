#!/bin/sh

git clone https://github.com/cwi-swat/grammarlab.git grammarlab-clone
(cd grammarlab-clone && git checkout e2215547911060736c52030074241eb5b9562168)

rm -rf src/grammarlab
cp -rf grammarlab-clone/src/grammarlab src/grammarlab
rm -rf grammarlab-clone
