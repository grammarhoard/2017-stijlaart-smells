#!/bin/sh

cwd=$(pwd)
cd src;
java -jar ../rascal.jar grammarlab/io/read/BGF.rsc $cwd
#java -jar ../rascal.jar Some.rsc $cwd
