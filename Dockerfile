FROM condaforge/mambaforge:23.3.1-1

RUN conda install -c conda-forge conda-merge conda-pack
RUN wget https://raw.githubusercontent.com/QCDIS/NaaVRE/1031-cant-install-climwin/docker/lter-life/environment.yaml
RUN mamba env create -f environment.yaml

ENV PATH /opt/conda/envs/venv/bin:$PATH
SHELL ["conda", "run", "-n", "venv", "/bin/bash", "-c"]
RUN echo "conda activate venv" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

# test packages
COPY test_climwin.R .
RUN Rscript test_climwin.R
RUN rm test_climwin.R


RUN conda-pack -n venv -o /tmp/env.tar && \
    mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
    rm /tmp/env.tar
RUN /venv/bin/conda-unpack

