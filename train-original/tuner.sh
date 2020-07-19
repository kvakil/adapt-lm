#!/bin/bash
set -Eeuox pipefail

# Split the data into train and tune.
# TODO(kvakil): add test dataset.
awk '{
r=rand()
if (r < 0.65) { print > "/build/user.train" }
else { print > "/build/user.tune" }
}' < /data/user

cd /build
# Using --discount_fallback here because most user data seems too small.
# TODO(kvakil): do nested cross-validation to find good discount fallback
# weights. For now, most input is unlikely to benefit from 5-grams so the
# weights don't matter too much. We could also consider training the base
# DeepSpeech LM with order 4.
kenlm/bin/lmplz --intermediate user.intermediate --prune 0 0 1 -o 5 --discount_fallback < /build/user.train

kenlm/bin/interpolate --model user.intermediate lm.intermediate -t /build/user.tune > combined.arpa

# Use all of the words in the user vocabulary in the final language model.
tr '\0' '\n' < user.intermediate.vocab > user-vocab.txt
cat user-vocab.txt vocab-500000.txt | sort -u > combined-vocab.txt
kenlm/bin/filter single model:combined.arpa filtered.arpa < combined-vocab.txt

# Make sure to use the container for the temporary directory, we don't have to
# transfer over the model to the host until the end.
# TODO(kvakil): is there any advantage to using a probing hash table instead of
# a regular trie--generally should I try to tune these parameters?
kenlm/bin/build_binary -T /tmp -a 255 -q 8 -v trie filtered.arpa /model/lm-ngram.bin
