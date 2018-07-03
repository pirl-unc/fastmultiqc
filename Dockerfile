# https://hub.docker.com/r/maxulysse/multiqc/~/dockerfile/
# debbian jesse background
FROM openjdk:8

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

# setup user for lbgcluster
RUN groupadd -g 1000 lbg \
   && groupadd -g 1026 nextgenseq \
   && groupadd -g 1062 seqgroup \
   && groupadd -g 1063 clinseq \
   && groupadd -g 1075 datasharing \
   && groupadd -g 2650 lbginrc \
   && groupadd -g 2782 lbgseq \
   && groupadd -g 2790 seq-in \
   && groupadd -g 2791 seq-out \
   && groupadd -g 3011 lccc_instrument \
   && groupadd -g 3026 lccc_gpath \
   && groupadd -g 3029 bioinf \
   && groupadd -g 3035 lccc_ram \
   && useradd -u 209755 -g 1000 \
              -G 1026,1062,1063,1075,2650,2782,2790,2791,3011,3026,3029,3035 \
              -s /bin/bash -N -c "Service account for Sequencing" seqware

RUN mkdir -p /home/seqware \
   && chown seqware /home/seqware \
   && chgrp lbg /home/seqware \
   && chmod 775 /home/seqware

USER seqware

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