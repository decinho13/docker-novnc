FROM decinho13/ros-vnc:latest
RUN apt-get update
RUN apt-get install -y ros-kinetic-moveit wget

# installing gzweb
RUN curl -sL https://deb.nodesource.com/setup | bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libjansson-dev nodejs libboost-dev imagemagick libtinyxml-dev mercurial cmake build-essential
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y byobu nano

RUN cd /root && \
    git clone git://github.com/c9/core.git c9sdk && \
    cd c9sdk && \
    scripts/install-sdk.sh && \
    sed -i -e 's_127.0.0.1_0.0.0.0_g' /root/c9sdk/configs/standalone.js

RUN python3 get-pip.py && \
    pip3 install --upgrade packaging jupyter && \
    pip3 install --upgrade jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --system --symlink && \
    mkdir -p /root/.jupyter && \
    jupyter nbextension enable toc2/main

COPY jupyter_notebook_config.py /root/.jupyter/

RUN pip3 install --upgrade packaging jupyter

RUN pip3 install --upgrade \
tensorflow \
keras \
h5py \
sklearn \
bokeh \
bayesian-optimization \
pandas \
numpy \
matplotlib \
scikit-learn \
scikit-image \
scipy \
seaborn \
sympy \
cython \
h5py \
protobuf \
xlrd
RUN mkdir -p /workspace/src && \
    cd /workspace/

COPY . /workspace/src/

# cleanup
# cleanup
RUN rm -rf /var/lib/apt/lists/*

# setup entrypoint
COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
EXPOSE 7000 8181 8888 7681
