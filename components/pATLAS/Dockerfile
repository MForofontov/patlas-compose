FROM ubuntu:22.04

# Create pATLAS folder
WORKDIR /pATLAS/

#Added to fix script getting stuck at configuration of tzdata
ENV TZ=Europe/Lisbon
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# Install general dependencies
RUN apt-get update && apt-get install -y git curl sudo gcc g++ make \
                                software-properties-common \
                                postgresql postgresql-contrib wget
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get install -y yarn python3.9 python3-pip build-essential tcl libssl-dev libffi-dev python3.9-dev

# Install pipenv
RUN pip3 install pipenv

# Clone flowcraft-webapp
WORKDIR /pATLAS/
RUN git clone https://github.com/MForofontov/pATLAS.git

WORKDIR /pATLAS/pATLAS/patlas/db_manager/db_app/static/
RUN yarn install

RUN node_modules/webpack/bin/webpack.js entry-point.js

WORKDIR /pATLAS/pATLAS/patlas/db_manager

# Get and extract pATLAS db
# Release 1.5.2
RUN wget https://github.com/MForofontov/test_files/raw/main/plasmid_db_dev_final.tar.gz
RUN tar xf plasmid_db_dev_final.tar.gz
RUN rm plasmid_db_dev_final.tar.gz

# Install Backend dependencies
WORKDIR /pATLAS/pATLAS/
#fix error
RUN apt install libpq-dev
#---------
RUN pip install -r requirements.txt

# Set final WORKDIR
WORKDIR /pATLAS/pATLAS/patlas/db_manager

# Set required changes on db configuration file and patlas service starting script
COPY db_config.py config_default.py
COPY run.py run.py
RUN chmod +x run.py

# Copy entrypoint for patlas to the image
COPY patlas_entrypoint.sh patlas_entrypoint.sh
RUN chmod +x patlas_entrypoint.sh

ENTRYPOINT ["/pATLAS/pATLAS/patlas/db_manager/patlas_entrypoint.sh"]
