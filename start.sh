#!/bin/bash

usage="-- Initialize a mimic OpenAI API server --

Arguments
-h | --help                         Show help
--repo=<REPO>                       HuggingFace repo's name
--file=<FILE>                       file from given repo
--n_ctx=<N_CTX>                     Number of tokens used in context (larger is better, but each model has its limit and our hardware has also)"

REPO_NAME="TheBloke/Mixtral-8x7B-v0.1-GGUF"
FILE_NAME="mixtral-8x7b-v0.1.Q4_K_M.gguf"
N_CTX=1024

while [[ $# -gt 0 ]]; do
    case $1 in
        --repo=*)
            REPO_NAME="${1#*=}"
            shift
            ;;
        --file=*)
            FILE_NAME="${1#*=}"
            shift
            ;;
        --n_ctx=*)
            N_CTX="${1#*=}"
            shift
            ;;
        -h|--help)
            echo "${usage}"
            exit
            ;;
    esac
done

if [ -f ./models/$FILE_NAME ] 
then
    python3 -m llama_cpp.server --model ./models/$FILE_NAME --host 0.0.0.0 --n_ctx $N_CTX --n_gpu_layers -1   
else
    huggingface-cli download $REPO_NAME $FILE_NAME --local-dir ./models --local-dir-use-symlinks False
    python3 -m llama_cpp.server --model ./models/$FILE_NAME --host 0.0.0.0 --n_ctx $N_CTX --n_gpu_layers -1
fi