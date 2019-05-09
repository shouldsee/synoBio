#!/usr/bin/env python2
#import synotil.util as sutil

import pymisca.util as pyutil
import sys,argparse
# import sys
import synotil.ptn as sptn

from signal import signal, SIGPIPE, SIG_DFL
signal(SIGPIPE,SIG_DFL) 

parser = argparse.ArgumentParser()
parser.add_argument('fnames',nargs='+')
parser.add_argument('--extract',default='TPM',type=str)
parser.add_argument('--verbose',action='store_true', default=False)

args = parser.parse_args()
fnames = args.fnames

sys.stderr.write('[STATUS] extracting column "%s"\n'%args.extract)
if args.verbose:
    sys.stderr.write(fnames+'\n')



### creating columns
vals = map(sptn.getBrachy,fnames)

bnames = map(lambda x: x.split('/')[-1].rsplit('.',2)[0].replace('_','-'), fnames )
# for i,d in enumerate(vals):
# 	d['Alias']=bnames[i]
# flats = pyutil.meta2flat([ [ (x,d.pop(x)) for x in ['RunID','sampleID','Alias']] 
# 	for d in vals])

nonEmptyVals = [{k:v for k,v in d.items() if v is not None} for d in vals]

meta = pyutil.pd.DataFrame(vals)
# meta = pyutil.pd.DataFrame(nonEmptyVals)
# meta['conds'] = conds = pyutil.meta2flat(nonEmptyVals)
meta['fname_'] = fnames
meta['alias'] = bnames
meta['sampleID_int'] = meta.sampleID.str.strip('S').astype(int)

## drop extra columns
mshort= meta.drop(columns = meta.columns[meta.isnull().all(axis=0)] )
meta['header_'] = pyutil.meta2name(mshort,)


meta.set_index('fname_',inplace=True)
meta.sort_values("sampleID_int",inplace=True)
mapper = pyutil.df2mapper(meta,'fname_','header_')
# meta.sort_values

# colNames = pyutil.paste0([flats,conds])
# fname2colName = dict(zip(fnames,colNames))
if args.verbose:
    sys.stderr.write(' '.join(map(str,['[meta]',meta])))
    sys.stderr.write('\n')

if args.verbose:
    sys.stderr.write(colNames+'\n')

#print vals
#sys.exit(0)
def callback(df):
#     df = pyutil.filterMatch(
#         df,
#         key='STRG',
#         negate=1)
    match = df.iloc[:,0].str.startswith('STRG')
    df = df.loc[~match]
    
    return df

dfc = pyutil.readData_multiple(fnames,
                               callback=callback,
#                                ext='tsv',
                               guess_index=0,
#                                valCol='TPM',idCol='Gene ID'
                              )
dfcc = dfc.pivot_table(index=   dfc.columns[0], 
                       values = args.extract,
                      columns = 'fname')
dfcc = dfcc.reindex(columns = meta.index,)
# dfcc.columns = map(fname2colName.get, dfcc.columns)
dfcc.columns = map(mapper.get,dfcc.columns)

# print dfcc.head()
print( dfcc.to_csv())
# df = pyutil.Table2Mat(fnames,callback=callback, valCol='TPM',idCol='Gene ID',ext='tsv')
# df.columns = colNames
# print df.to_csv()
 


