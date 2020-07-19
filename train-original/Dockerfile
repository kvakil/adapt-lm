# TODO(kvakil): this includes the gzipped data in the final image, so we're a
# gigabyte or two larger than we need to be.
FROM kvakil/adapt-lm/data
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
RUN apt-get update && \
        apt-get install -y make cmake git g++ curl libboost-all-dev libbz2-dev liblzma-dev libz-dev libeigen3-dev python3 python3-pip

WORKDIR /source
COPY kenlm /source/kenlm

WORKDIR /build
RUN mkdir kenlm && \
    cd kenlm && \
    cmake /source/kenlm -DKENLM_MAX_ORDER=5 && \
    make -j$(nproc)

COPY DeepSpeech /source/DeepSpeech
RUN python3 -m pip install progressbar2 --no-cache-dir && cp /source/DeepSpeech/data/lm/generate_lm.py .

COPY generate_intermediate_lm.py .
RUN python3 generate_intermediate_lm.py

COPY tuner.sh .
CMD /build/tuner.sh
