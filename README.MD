# Wordcloud as a Docker image

[![CircleCI](https://circleci.com/gh/koenighotze/wordcloud-docker/tree/master.svg?style=svg)](https://circleci.com/gh/koenighotze/wordcloud-docker/tree/master)

This repo encapsulates [Wordcloud](https://github.com/amueller/word_cloud) as a simple Docker image.

The current version at Docker Hub is 1.6. Just `docker pull koenighotze/wordcloud:1.6` to get started.

## Building

Building from scratch is easy as:

```bash
$ docker build -t koenighotze/wordcloud .
...
Step 17/17 : CMD ["--help"]
 ---> Using cache
 ---> e743d10ddadc
Successfully built e743d10ddadc
Successfully tagged koenighotze/wordcloud:latest
```

## Running

The entrypoint is set to `wordcloud_cli`. To see to online help, run the image as

```bash
$ docker run --rm=true  koenighotze/wordcloud:1.6

usage: wordcloud_cli [-h] [--text file] [--regexp regexp] [--stopwords file]
...
  --include_numbers include_numbers
                        include numbers in wordcloud?
  --min_word_length min_word_length
                        only include words with more than X letters
  --version             show program's version number and exit
```

Let's create the word cloud based on the Bash manual. We paste the manual into a text file and use a bind volume to expose that text file to the container. Then we ask Wordcloud to generate the cloud-image and store it in the same bind-volume.

Note, that since the entrypoint of the image is `wordcloud_cli`, we can pass any arguments directly to the running container.

```bash
$ man bash > sample/bash_man.txt
# sample/bash_man.txt contains the complete manual for the Bash shell, now
$ docker run \
    --rm=true  \
    # remove the container after execution - no need to keep it around
    -v $(PWD)/sample:/data/ \
    # we mount the sample directory at /data/ within the container using a bind
    # volume.
    koenighotze/wordcloud:1.6 \
    --min_word_length 5 \
    # exclude any words shorter than 5 characters in length
    --text /data/bash_man.txt \
    # location of the text used for generating the word cloud
    --imagefile /data/wordcloud.png
    # location of the generated image
```

We can now open the image, e.g. on Mac using `open ./sample/wordcloud.png`.