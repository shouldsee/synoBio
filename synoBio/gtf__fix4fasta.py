#!/usr/bin/env python
# -*- coding: utf-8 -*-
import pymisca.ext as pyext
np = pyext.np

def fasta__getDefLine(FA_FILE,baseFile=0):
    it = pyext.readData(FA_FILE,baseFile=baseFile,ext='it')
    res = []
    for line in it:
        if line.startswith('>'):
            res += [line[1:].strip()]
    return res
def fixGTF(FA_FILE, GTF_FILE, inplace=True,silent=1):
    pyext.shellexec('cp -n %s{,.bak}'%GTF_FILE,silent=silent)
    
    fa = fasta__getDefLine(FA_FILE)
#     pyext.shellexec("cut -d'\t' -f1 %s" % GTF_FILE)
    fa = [x.split()[0] for x in fa] 
    gtf = set(pyext.read__buffer(
        pyext.shellexec("cut -d'\t' -f1 %s.bak" % GTF_FILE,
                       silent=silent),ext='it'),
             )
    gtf = [x.strip() for x in gtf]
    
    mapper = pyext.collections.OrderedDict()
    for gtf_ in gtf:
        worker = pyext.functools.partial(
            pyext.str__longestCommonSubstring,
            string2=gtf_)
        res = [x.size for x in map(worker,fa)]
        MAX  = np.max(res)
        EQ = res== MAX
        assert sum(EQ) == 1,\
        'multiple matches found for GTF key:%s in %s'% (gtf_ , fa)
        assert MAX==len(gtf_),\
        'no match found for GTF key:%s' %gtf_
        mapper[gtf_] = fa[np.argmax(EQ)]
    
    if not inplace:
        ofname = pyext.sys.stdout
    else:
        ofname = GTF_FILE
    
    if 0:
        gtf=  pyext.readData(GTF_FILE+'.bak',ext='tsv',header=None)
        gtf = gtf.rename(index=mapper)
        ofname = pyext.to_tsv(gtf,ofname,index=1)
    
    if 1:
        it = pyext.readData(GTF_FILE+'.bak',ext='it')
        def worker(line):
            sp = line.split(u'\t')
            sp[0] = mapper.get(sp[0])
            line = u'\t'.join(sp)
            return line
        it = (worker(line) for line in it)
        pyext.iter__toFile(it=it,fname=ofname)
        
    if inplace:
        return ofname

main = fixGTF

import argparse
parser= argparse.ArgumentParser()
parser.add_argument('--FA_FILE')
parser.add_argument('--GTF_FILE')
parser.add_argument('--inplace', default=1,type=int)    

if __name__=='__main__':
    args = parser.parse_args()
    main(**vars(args))
    
#     print mapper
    
#     print fa,gtf

# %pdb 0