#!/usr/bin/env python2
import synotil.ptn as sptn
import os,sys
assert len(sys.argv)>1,'not enough arguments'
IN=sys.argv[1]
sp = IN.split('/')
res = [ x for x in sp if sptn.get_runID(x) is not None]
lenLst = (map(len, res));
minIdx = min( range(len(lenLst)),key=lenLst.__getitem__)
print (res[minIdx])
#print (sptn.get_runID(IN))
