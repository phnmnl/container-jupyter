FROM bitnami/minideb:jessie 
MAINTAINER PhenoMeNal-H2020 Project <phenomenal-h2020-users@googlegroups.com>

LABEL Description="Custom Jupyter stack for PhenoMeNal."
LABEL software="Jupyter"
LABEL software.version=""
LABEL version="0.1"

# Add cran R backport
RUN echo "deb http://cloud.r-project.org/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 381BA480

# Install 
RUN install_packages apt-transport-https git gcc libfreetype6-dev libpng-dev pkg-config python python-dev python2.7 python3 python-pip \
    r-cran-ggplot2 r-base=3.3.2-1~jessiecran.0 r-cran-lattice \
    python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose && \
    pip install --upgrade pip && pip install -U setuptools && \
    pip install git+https://github.com/mcapuccini/luigi.git@feature/k8s-task#egg=luigi pykube jupyter && \
    pip uninstall pip && apt-get -y purge gcc libfreetype6-dev libpng-dev pkg-config python-pip python-dev git && \ 
    apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Configure Luigi
RUN mkdir /etc/luigi
RUN echo -e "[kubernetes]\nauth_method=service-account" > /etc/luigi/client.cfg
