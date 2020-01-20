
TODO:
This has been pulling twice the number of cpu that are requested.  Need to set 
srun to twice as many threads as the docker run command.  Alan said this could 
be a java garbage collection problem. 

When logged in to login.bioinf.unc.edu pasting the following code in the terminal 
will run fastqc and then multiqc on all of the contents in a directory:  

``` bash
INPUT_DIR="/your/input/folder"  
OUTPUT_DIR="/your/output/folder"  
BASE_FILE_NAME="base_name"  
TITLE="Title of report"  
FASTQ_ENDING="*.fastq.gz"  
THREAD_NUM=8

mkdir -p ${OUTPUT_DIR}  

srun --pty -c ${THREAD_NUM} --mem-per-cpu 1g -p docker \
docker run --rm=true \
-v /datastore:/datastore:shared \
-e INPUT_DIR="${INPUT_DIR}" \
-e OUTPUT_DIR="${OUTPUT_DIR}" \
-e BASE_FILE_NAME="${BASE_FILE_NAME}" \
-e TITLE="${TITLE}" \
-e FASTQ_ENDING="${FASTQ_ENDING}" \
-e THREAD_NUM="${THREAD_NUM}" \
dockerreg.bioinf.unc.edu:5000/fastmultiqc:3
```

OR...
  
``` bash
srun --pty -c 8 --mem-per-cpu 1g -p docker \
docker run --rm=true \
-v /datastore:/datastore:shared \
-e INPUT_DIR=/datastore/nextgenout4/HTSF/IMGF/170510_UNC21_0420_000000000-B5RJV \
-e OUTPUT_DIR=/datastore/alldata/shiny-server/rstudio-common/dbortone/docker/fastmultiqc/test \
-e BASE_FILE_NAME=base_name \
-e TITLE="Title of report" \
-e FASTQ_ENDING="*.fastq.gz" \
-e THREAD_NUM=8 \
dockerreg.bioinf.unc.edu:5000/fastmultiqc:3
```

The default values are:  
INPUT_DIR="."  
OUTPUT_DIR="."  
BASE_FILE_NAME="fastmultiqc"  
TITLE="FastMultiQC"  
FASTQ_ENDING=".fastq.gz"  
THREAD_NUM=1

So you can just get away with:  
``` bash
srun --pty -c 1 --mem-per-cpu 1g -p docker \
docker run --rm=true \
-v /datastore:/datastore:shared \
-e INPUT_DIR=/datastore/nextgenout4/HTSF/IMGF/170510_UNC21_0420_000000000-B5RJV \
-e OUTPUT_DIR=/datastore/alldata/shiny-server/rstudio-common/dbortone/docker/fastmultiqc/test \
dockerreg.bioinf.unc.edu:5000/fastmultiqc:2
```
