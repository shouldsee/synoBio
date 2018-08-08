## Redirection

The two following components have been split since August 8th 2018 for modularity.

-  See [rnaclu](https://github.com/shouldsee/rnaclu) for python2 package that clusters trancript abundance matrix,

-  See [synotil](https://github.com/shouldsee/synotil), for command-line pipelines that process raw NGS `.fastq`, 

## Usage

- Create a new environment:

```sh
ORIG=$PWD
mkdir myEnv
cd myEnv
source $ORIG/src/init.sh
```

- Activate your environment

```sh
source myEnv/activate.sh
```

- Align your samples 

```sh
mkdir -p temp; cd temp
pipeline_rnaseq.sh $ORIG/test/test_R1_.fastq $ORIG/test/test_R1_.fastq
```
