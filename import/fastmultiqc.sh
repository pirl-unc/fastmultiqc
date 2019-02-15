while getopts i:o:f:t:e:p: option
do
 case "${option}"
 in
 i) INPUT_DIR=${OPTARG};;
 o) OUTPUT_DIR=${OPTARG};;
 f) BASE_FILE_NAME=${OPTARG};;
 t) TITLE=${OPTARG};;
 e) FASTQ_ENDING=${OPTARG};;
 p) THREAD_NUM=${THREAD_NUM};;
 esac
done

echo "INPUT_DIR: ${INPUT_DIR}"
echo "OUTPUT_DIR: ${OUTPUT_DIR}"
echo "BASE_FILE_NAME: ${BASE_FILE_NAME}"
echo "TITLE: ${TITLE}"
echo "FASTQ_ENDING: ${FASTQ_ENDING}"
echo "THREAD_NUM: ${THREAD_NUM}"
echo ""
echo "Running FastQC on the following folder:"
echo ${INPUT_DIR}

# TODO: get it to detect the number of threads available
# my_threads=$(nproc --all) this does the whole node
# echo $my_threads

run_fastqc() {
  path=$1
  file_name=$(basename $path)
  echo "Running FastQC on ${file_name}"
  sample_base_name=${file_name%$FASTQ_ENDING}
  output_subdir=${OUTPUT_DIR}/${sample_base_name}
  mkdir -p ${output_subdir}
  fastqc --outdir=${output_subdir} $path &> ${output_subdir}/fastqc_stdouterr.txt
}

export -f run_fastqc

find -L "${INPUT_DIR}" -type f -name "${FASTQ_ENDING}" -print0 | xargs -0 -P ${THREAD_NUM} -n 1 -I {} bash -c 'run_fastqc "$@"' _ {}

multiqc_output_dir=${OUTPUT_DIR}/multiqc/
mkdir -p ${multiqc_output_dir}

multiqc -f \
  -i "${TITLE}" \
  -c /import/multiqc_config.yaml \
  -o ${multiqc_output_dir} \
  -n ${BASE_FILE_NAME} \
  ${OUTPUT_DIR}; wait
