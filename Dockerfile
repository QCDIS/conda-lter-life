FROM condaforge/mambaforge:23.3.1-1

RUN conda install -c conda-forge conda-merge conda-pack
RUN wget https://raw.githubusercontent.com/QCDIS/NaaVRE/main/docker/lter-life/environment.yaml
RUN mamba env create -f environment.yaml

ENV PATH /opt/conda/envs/venv/bin:$PATH
SHELL ["conda", "run", "-n", "venv", "/bin/bash", "-c"]
RUN echo "conda activate venv" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

RUN Rscript --version
RUN which Rscript

# test R
COPY install-and-load-the-climwinb-packages-dev-user-name-at-domain-com.R .
RUN Rscript install-and-load-the-climwinb-packages-dev-user-name-at-domain-com.R
RUN rm install-and-load-the-climwinb-packages-dev-user-name-at-domain-com.R


COPY consume-climwin-dev-user-name-at-domain-com.R .
RUN Rscript consume-climwin-dev-user-name-at-domain-com.R
RUN rm consume-climwin-dev-user-name-at-domain-com.R


RUN conda-pack -n venv -o /tmp/env.tar && \
    mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
    rm /tmp/env.tar
RUN /venv/bin/conda-unpack

