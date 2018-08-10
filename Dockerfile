# https://hub.docker.com/r/maxulysse/multiqc/~/dockerfile/
# debbian jesse background
FROM openjdk:8

USER root

#Install libraries
RUN \
  apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    python-dev \
    perl \
    unzip \
  && rm -rf /var/lib/apt/lists/*

#Setup ENV variables
ENV MULTIQC_VERSION v0.9

#Install pip
RUN \
  curl -fsSL https://bootstrap.pypa.io/get-pip.py -o /opt/get-pip.py && \
  python /opt/get-pip.py && \
  rm /opt/get-pip.py

#install multiqc
RUN pip install git+git://github.com/ewels/MultiQC.git@$MULTIQC_VERSION

# Download FastQC
ADD http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip /tmp/

# Install FastQC
RUN cd /usr/local && \
    unzip /tmp/fastqc_*.zip && \
    chmod 755 /usr/local/FastQC/fastqc && \
    ln -s /usr/local/FastQC/fastqc /usr/local/bin/fastqc && \
    rm -rf /tmp/fastqc_*.zip

COPY /import/* /import/

ENV INPUT_DIR "."
ENV OUTPUT_DIR "."
ENV BASE_FILE_NAME "fastmultiqc"
ENV TITLE "FastMultiQC"
ENV FASTQ_ENDING ".fastq.gz"

CMD \
  bash -c 'source /import/fastmultiqc.sh -i "${INPUT_DIR}" -o "${OUTPUT_DIR}" -f "${BASE_FILE_NAME}" -t "${TITLE}"'
    
    
#INPUT_DIR="/datastore/nextgenout4/HTSF/IMGF/171117_UNC21_0483_000000000-BFMHB"
#OUTPUT_DIR="/datastore/alldata/shiny-server/rstudio-common/dbortone/projects/fastmultiqc/results/Sharpless_IP61_Reseq"
#BASE_FILE_NAME="Sharpless_IP61_Reseq"
#TITLE="Sharpless Reseqencing"
#FASTQ_ENDING=".fastq.gz"

#mkdir -p ${OUTPUT_DIR}
#chmod 777 ${OUTPUT_DIR}
#docker run --rm=true \
#-v /datastore:/datastore:shared \
#-e INPUT_DIR="${INPUT_DIR}" \
#-e OUTPUT_DIR="${OUTPUT_DIR}" \
#-e BASE_FILE_NAME="${BASE_FILE_NAME}" \
#-e TITLE="${TITLE}" \
#-e FASTQ_ENDING="${FASTQ_ENDING}" \
#fastmultiqc:1