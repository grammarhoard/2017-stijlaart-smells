#!/bin/sh

rm -rf input/zoo
rm -rf zoo-clone
git clone https://github.com/slebok/zoo.git zoo-clone
(cd zoo-clone && git checkout 51ba8ff5a561337b037c58fe9bf833fff8aaea57)

cp -rf zoo-clone/zoo input/zoo

rm -rf zoo-clone


