#!/bin/bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

lid=false # whether to use language id as additional label

train_set="train_mr"
train_dev="dev_mr"
test_set="test_mr"

asr_config=conf/train.yaml
inference_config=conf/decode.yaml

ngpu=1

./asr.sh \
    --stage 1 \
    --stop_stage 20 \
    --ngpu ${ngpu} \
    --nj 80 \
    --inference_nj 256 \
    --gpu_inference true \
    --inference_args "--batch_size 1" \
    --use_lm false \
    --token_type bpe \
    --nbpe 1000 \
    --feats_type raw \
    --asr_config "${asr_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${train_dev}" \
    --test_sets "${test_set}" \
    --feats_normalize uttmvn \
    --lm_train_text "data/${train_set}/text" \
    --local_score_opts "--score_lang_id ${lid}" "$@"
