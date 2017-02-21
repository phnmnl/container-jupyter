FROM jupyter/datascience-notebook:387f29b6ca83
MAINTAINER PhenoMeNal-H2020 Project <phenomenal-h2020-users@googlegroups.com>

LABEL Description="Custom Jupyter stack for PhenoMeNal."
LABEL software="Jupyter"
LABEL software.version="387f29b6ca83-pheno"
LABEL version="0.1"

USER root

RUN pip install git+https://github.com/mcapuccini/luigi.git@feature/k8s-task
