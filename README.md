## Redirection

The two following components have been split since August 8th 2018 for modularity.

-  See [rnaclu](https://github.com/shouldsee/rnaclu) for python2 package that clusters trancript abundance matrix,

-  See [synoBio](https://github.com/shouldsee/synoBio), for command-line pipelines that process raw NGS `.fastq`, 

## Usage

- Create a new environment:

```sh
git clone https://github.com/shouldsee/synoBio /tmp/synoBio_src
mkdir /tmp/myEnv
cd /tmp/myEnv
source /tmp/synoBio_src/init.sh
```

- Activate your environment

```sh
source /tmp/myEnv/activate.sh
```

- Align your samples 

```sh
SRC=/tmp/synoBio_src
mkdir -p ./temp_job; cd ./temp_job
/tmp/myEnv/bin/pipeline_rnaseq.sh $SRC/examples/data/test_R1_.fastq $SRC/examples/data/test_R1_.fastq
```
