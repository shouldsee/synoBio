#!/usr/bin/env bash
set -e

##### Initialising a working environment in current directory 
SELF=${BASH_SOURCE[0]}
ENVDIR=$PWD

############################################
echo ==== Installing binaries
JARLIB=$PWD/jar
mkdir -p $PWD/bin
mkdir -p $JARLIB

### Trimmomatic
# must supply absolute paths
TRIMDIR=/home/birte/IGZ_data/software/Trimmomatic-0.39
printf '#!/usr/bin/env bash \njava -jar $TRIMDIR/trimmomatic-0.39.jar "$@"'>$ENVDIR/bin/trimmomatic




### HISAT2
ln -sf /home/birte/IGZ_data/software/hisat2-2.1.0/* $ENVDIR/bin
### picard for dedup
#ln -sf /home/Program_NGS_sl-pw-srv01/picard-tools-1.103/*.jar $JARLIB
ln -sf /home/birte/IGZ_data/software/picard.jar $JARLIB #Birte: different from before logic, no picard-tools folder anymore
### StringTie
ln -sf /home/birte/IGZ_data/software/stringtie-2.1.1.Linux_x86_64/stringtie $ENVDIR/bin
### Samtools
ln -sf /home/birte/IGZ_data/software/samtools-1.10/samtools $ENVDIR/bin #Birte: not tested yet if this works
### FASTQC
ln -sf /home/birte/IGZ_data/software/FASTQC/fastqc $ENVDIR/bin #Birte: not tested yet if this works

#     ##### Assumed installed
#     # fastqc
# pip install --user pyfaidx
echo ---- Installing binaries
############################################



# ############################################
# echo ==== Preparing different FASTA files =====
# #### Prepare adapter fasta
# mkdir -p $PWD/adapters
# ln -sf $TRIMDIR/adapters/* adapters
# cd adapters
# if [ ! -e "TruSeq3-PE-all.fa" ]; then
# #     :
# # else
#     cat TruSeq3-PE*.fa >TruSeq3-PE-all.fa
# fi
# cd ..

# #### Index genome.fa
# mkdir -p $PWD/ref
# #ln -s /home/ref_genew/Brachypodium_Bd21_v3.1/assembly/Bdistachyon_314_v3.0.fa ref/genome.fa
# ln -sf /home/ref_genew/Brachypodium_Bd21_v3.1/* ref
# ln -sf $PWD/ref/assembly/*.fa ref/genome.fa
# faidx ref/genome.fa -i chromsizes > ref/genome.sizes
# echo ---- Preparing different FASTA files ----
# ############################################


ORIGIN=`readlink -f ${SELF%/*}`
cp -u $ORIGIN/activate.sh bin/activate
cp -u $ORIGIN/*.sh bin/
cp -uR $ORIGIN/config config
echo export ORIGIN=$ORIGIN >> bin/activate



