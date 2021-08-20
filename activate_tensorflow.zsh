#!/bin/zsh

NAME=TF_4_MAC
ENV_FILE=./test_environment.yml
SHOULD_LIST_CONDA_ENVS=0

TRUE_FLAG=1

while getopts ln:p:-: OPT;
do
    if [ "$OPT" = "-" ]; then
        OPT="${OPTARG%%=*}"
        OPTARG="${OPTARG#$OPT}"
        OPTARG="${OPTARG#=}"
    fi
    case "${OPT}" in
        n | name) NAME=${OPTARG};;
        p | path) ENV_FILE=${OPTARG};;
        l | list) SHOULD_LIST_CONDA_ENVS=${TRUE_FLAG}
    esac
done

if [[ $SHOULD_LIST_CONDA_ENVS == $TRUE_FLAG ]];
then
    conda env list
fi

# Obligatory for mac-tf-gpu
export SYSTEM_VERSION_COMPAT=0
# Create base environment without tensorflow
conda env create --file=${ENV_FILE} --name=${NAME}

# Manually install gpu-oriented tensorflow from apple github
conda run \
    --no-capture-output \
    -n ${NAME} \
        pip install \
            --upgrade \
            --force \
            --no-dependencies \
            https://github.com/apple/tensorflow_macos/releases/download/v0.1alpha3/tensorflow_macos-0.1a3-cp38-cp38-macosx_11_0_x86_64.whl \
            https://github.com/apple/tensorflow_macos/releases/download/v0.1alpha3/tensorflow_addons_macos-0.1a3-cp38-cp38-macosx_11_0_x86_64.whl