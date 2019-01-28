#!/usr/bin/env python2
import pyBigWig as pybw
import sys
import pandas as pd
def main(fname):
	with pybw.open(fname,'r') as f:
		df = pd.DataFrame(f.chroms().items(),columns=['chr','size']
                 ).sort_values('size',ascending=False)
		res = df.to_csv(sep='\t',index=0,header=None)
	return res
if __name__ == '__main__':
	assert len(sys.argv)>=2
	res = main(sys.argv[1])
	sys.stdout.write(res)

