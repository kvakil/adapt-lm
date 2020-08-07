# `adapt-lm`

Tool for adapting pretrained [language
models](https://en.wikipedia.org/wiki/Language_model) to include a user corpus.

## Prerequisites

You will need macOS or Linux, as well as Docker installed. The script `tune.sh`
can be adapted to work on Windows as well.

## Usage with [Talon Beta](https://talonvoice.com/)

**WARNING:** This is a third-party tool and not officially blessed by the Talon
creators. It may not work in future versions. If you are reporting an issue to
upstream Talon, please make sure to reproduce the issue with one of the
included langage models. Thanks!

### Gathering Data

In order to record your speech patterns so that a custom language model can be
trained, you need to accumulate data of your typical sentences. There are two
possible ways to do so:

1. The included script `adapt_lm_log.py` logs your sentences into an `adapt-log` file. Copy it into
your Talon user directory. On macOS, this is typically `~/.talon/user`:

```bash
# Replace ~/.talon/user with your Talon user directory.
$ cp adapt_lm_log.py ~/.talon/user
```

2. If you already use `record.py` (from the Talon beta Slack), you can gather
a log from the filenames of the saved files:

```bash
$ ls -1 ~/.talon/recordings | awk '{ gsub("(-[0-9]+)?.flac", ""); print }' > ~/.talon/record-log
```

The first method is recommended, since it lets you edit incorrect entries
by hand and is also less wasteful from a resource perspective. The second
method is good if you already have a lot of recordings you want to include.

### Tuning

Once the file has at least 10000 lines, it is reasonable to begin training a
language model based on it. To do so, run the following:

```bash
# This command will take a while!
$ docker pull docker.pkg.github.com/kvakil/adapt-lm/train-original:latest
# Replace ~/.talon/ with your Talon home directory.
# (This command will probably take longer.)
$ ./tune.sh ~/.talon/adapt-log
```

It should take roughly 30 minutes to finish, go grab a coffee in the meantime.

After it's all done, the resulting model should be in `output/lm-ngram.bin`.
You'll need to copy it into the directory for your Talon speech engine, which
is somewhere under `w2l`. I recommend you make a backup of the old
`lm-ngram.bin`, although that can always be redownloaded from official sources.

```bash
$ cp output/lm-ngram.bin ~/.talon/w2l/en_US-sconv-beta4/
```

Finally, start and stop Talon.
