FROM ubuntu:xenial
MAINTAINER Thomas B. Mooney <tmooney@genome.wustl.edu>

LABEL \
    description="Image for tools used in RnaSeq"

RUN apt-get update -y && apt-get install -y \
    build-essential \
    bzip2 \
    default-jdk \
    git \
    libnss-sss \
    nodejs \
    python-dev \
    python-pip \
    unzip \
    wget

##############
#HISAT2 2.0.5#
##############

RUN mkdir /opt/hisat2/ \
    && wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.0.5-Linux_x86_64.zip \
    && unzip -d /opt/hisat2/ hisat2-2.0.5-Linux_x86_64.zip \
    && ln -s /opt/hisat2/hisat2-2.0.5/hisat2 /usr/bin/hisat2 \
    && rm hisat2-2.0.5-Linux_x86_64.zip

#################
#Sambamba v0.6.4#
#################

RUN mkdir /opt/sambamba/ \
    && wget https://github.com/lomereiter/sambamba/releases/download/v0.6.4/sambamba_v0.6.4_linux.tar.bz2 \
    && tar --extract --bzip2 --directory=/opt/sambamba --file=sambamba_v0.6.4_linux.tar.bz2 \
    && ln -s /opt/sambamba/sambamba_v0.6.4 /usr/bin/sambamba

##############
#Picard 2.9.0#
##############

RUN mkdir /opt/picard/ \
    && wget https://github.com/broadinstitute/picard/releases/download/2.9.0/picard.jar \
    && mv picard.jar /opt/picard/

######
#Toil#
######
RUN pip install --upgrade pip \
    && pip install toil[cwl]==3.6.0 \
    && sed -i 's/select\[type==X86_64 && mem/select[mem/' /usr/local/lib/python2.7/dist-packages/toil/batchSystems/lsf.py

# Define a timezone so Java works properly
RUN ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && echo "America/Chicago" > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata
