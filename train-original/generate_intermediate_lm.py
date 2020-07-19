# TODO(kvakil): this file should probably be replaced with a bash script.
# WE don't really get much from reusing DeepSpeech code here.

import generate_lm


class AttributeDict(dict):
    __getattr__ = dict.__getitem__
    __setattr__ = dict.__setitem__


if __name__ == "__main__":
    data_lower, vocab_str = generate_lm.convert_and_filter_topk(
        AttributeDict(
            {
                "output_dir": ".",
                "input_txt": "/data/librispeech-lm-norm.txt.gz",
                "top_k": 500000,
            }
        )
    )
    generate_lm.build_intermediate_lm(
        AttributeDict(
            {
                "output_dir": ".",
                "arpa_order": 5,
                "arpa_prune": "0|0|1",
                "max_arpa_memory": "85%",
                "kenlm_bins": "/build/kenlm/bin",
                "discount_fallback": False,
            }
        ),
        data_lower,
    )
