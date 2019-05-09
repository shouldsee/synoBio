#!/usr/bin/env python2
import synotil.ptn as sptn
import os,sys
assert len(sys.argv)>1,'not enough arguments'
IN=sys.argv[1]
print (sptn.get_sampleID(IN))
