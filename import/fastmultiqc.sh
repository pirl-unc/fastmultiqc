while getopts i:o:f:t: option
do
 case "${option}"
 in
 i) INPUT_DIR=${OPTARG};;
 o) OUTPUT_DIR=${OPTARG};;
 f) BASE_FILE_NAME=${OPTARG};;
 t) TITLE=${OPTARG};;
 e) FASTQ_ENDING=${OPTARG};;
 esac
done

echo "INPUT_DIR: ${INPUT_DIR}"
echo "OUTPUT_DIR: ${OUTPUT_DIR}"
echo "BASE_FILE_NAME: ${BASE_FILE_NAME}"
echo "TITLE: ${TITLE}"
echo "FASTQ_ENDING: ${FASTQ_ENDING}"

echo "Running FastQC on the following folder:"
echo ${INPUT_DIR}
my_files=( $(find ${INPUT_DIR} -type f) )
my_files=${my_files[@]}

while IFS= read -r -d $'\0' path; do
  if [[ "$path" = *${FASTQ_ENDING} ]]; then
    file_name=$(basename $path)
    echo "Running FastQC on ${file_name}"
    sample_base_name=${file_name%$FASTQ_ENDING}
    output_subdir=${OUTPUT_DIR}/${sample_base_name}
    mkdir -p ${output_subdir}
    fastqc --outdir=${output_subdir} $path
  fi
done < <(find ${INPUT_DIR} -type f -print0)

multiqc_output_dir=${OUTPUT_DIR}/multiqc/
mkdir -p ${multiqc_output_dir}

multiqc -f \
  -i "${TITLE}" \
  -c /import/multiqc_config.yaml \
  -o ${multiqc_output_dir} \
  -n ${BASE_FILE_NAME} \
  ${OUTPUT_DIR}; wait
