#!/usr/bin/env python2

#import synotil.util as sutil
import pymisca.util as pyutil

import argparse

parser= argparse.ArgumentParser()
parser.add_argument('-v','--verbose',default=0,type = int)

parser.add_argument('fname',)
parser.add_argument('-k','--keys',type=list,default=['feat_acc','FC'], nargs='+')

args = parser.parse_args()
print pyutil.firstByKey(**vars(args))
