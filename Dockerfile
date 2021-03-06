FROM jupyter/base-notebook:387f29b6ca83
MAINTAINER PhenoMeNal-H2020 Project <phenomenal-h2020-users@googlegroups.com>

LABEL Description="Custom Jupyter stack for PhenoMeNal."
LABEL software="Jupyter"
LABEL software.version="387f29b6ca83"
LABEL version="0.4"

USER root

RUN chown -R root /home/jovyan
# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

# Add cran R backport
RUN echo "deb http://cloud.r-project.org/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 381BA480

# Install
RUN apt-get -y update && apt-get -y install --no-install-recommends \
    apt-transport-https git gcc pkg-config python-dev python-pip libav-tools libxrender1 fonts-dejavu && \
    conda config --add channels r && \
    conda install --quiet --yes \
    'r-base=3.3.2' \
    'r-irkernel=0.7*' \
    'r-plyr=1.8*' \
    'r-ggplot2=2.2*' \
    'r-lattice=0.20*' \
    'r-data.table=1.10*' \
    'r-shiny=0.14*' \
    'r-rmarkdown=1.2*' \
    'r-reshape2=1.4*' \
    'r-caret=6.0*' \
    'r-cairo=1.5_9' \
    'r-rcurl=1.95*' && \
    conda clean -tipsy && \
    conda install --quiet --yes \
    'ipywidgets=5.2*' && \
    conda clean -tipsy && \
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 \
    'ipython=4.2*' \
    'ipywidgets=5.2*' && \
    conda clean -tipsy && \
    ln -s $CONDA_DIR/envs/python2/bin/pip $CONDA_DIR/bin/pip2 && \
    ln -s $CONDA_DIR/bin/pip $CONDA_DIR/bin/pip3 && \
    pip install --upgrade pip && \
    pip install kernda --no-cache && \
    $CONDA_DIR/envs/python2/bin/python -m ipykernel install && \
    kernda -o -y /usr/local/share/jupyter/kernels/python2/kernel.json && \
    pip uninstall kernda -y && \
    pip install git+https://github.com/spotify/luigi.git#egg=luigi pykube jupyter && \
    pip uninstall -y pip && apt-get -y purge gcc libfreetype6-dev libpng-dev pkg-config python-pip python-dev && \
    apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Configure Luigi
RUN mkdir /etc/luigi
RUN echo "[kubernetes]" > /etc/luigi/client.cfg && \
    echo "auth_method=service-account" >> /etc/luigi/client.cfg

# Add password hash generation logic
COPY generate-jupyter-hashed-password.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/generate-jupyter-hashed-password.sh
