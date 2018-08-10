This runs fastqc and then multiqc on all of the contents in a directory  

INPUT_DIR="/datastore/nextgenout4/HTSF/IMGF/171103_UNC22_0401_000000000-BC7BY"  
OUTPUT_DIR="/datastore/alldata/shiny-server/rstudio-common/dbortone/fastmultiqc/test"  
BASE_FILE_NAME="base_name"  
TITLE="Title of report"  
FASTQ_ENDING=".fastq.gz"  

mkdir -p ${OUTPUT_DIR}  
srun --pty -c 1 --mem 1g -p docker docker run --rm=true \
-v /datastore:/datastore:shared \
-e INPUT_DIR="${INPUT_DIR}" \
-e OUTPUT_DIR="${OUTPUT_DIR}" \
-e BASE_FILE_NAME="${BASE_FILE_NAME}" \
-e TITLE="${TITLE}" \
-e FASTQ_ENDING="${FASTQ_ENDING}" \
dockerreg.bioinf.unc.edu:5000/fastmultiqc:1


The default values are:  
ENV INPUT_DIR "."  
ENV OUTPUT_DIR "."  
ENV BASE_FILE_NAME "fastmultiqc"  
ENV TITLE "FastMultiQC"  
ENV FASTQ_ENDING ".fastq.gz"  


So you can just get away with:  
srun --pty -c 1 --mem 1g -p docker docker run --rm=true \
-v /datastore:/datastore:shared \
-e INPUT_DIR="${INPUT_DIR}" \
-e OUTPUT_DIR="${OUTPUT_DIR}" \
dockerreg.bioinf.unc.edu:5000/fastmultiqc:1
