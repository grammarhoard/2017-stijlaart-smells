#!/bin/sh

rm -rf input/zoo
rm -rf zoo-clone
git clone https://github.com/slebok/zoo.git zoo-clone
cp -rf zoo-clone/zoo input/zoo

rm -rf zoo-clone


