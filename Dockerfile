FROM rocker/tidyverse:3.6.1

# fix texlive-xetex issues
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    apt-utils \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libv8-dev \
    fonts-roboto \
    texlive-xetex \
    texlive-generic-recommended \
    texlive-latex-extra \
    texlive-fonts-recommended \
    lmodern \
    ssh \
    less

# download and install Shiny Server open source
RUN wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.12.933-amd64.deb" -O shiny-server.deb && \
    gdebi -n shiny-server.deb && \
    rm -f shiny-server.deb

# install R packages
COPY packages.R /opt/packages.R
RUN Rscript /opt/packages.R

# copy shiny server config
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY ./app /srv/shiny-server/

# make the app available at port 3838
EXPOSE 3838

# copy shiny server config scripts
COPY shiny-server.sh /usr/bin/shiny-server.sh

# run shiny server
CMD ["/usr/bin/shiny-server.sh"]
RUN ["chmod", "+x", "/usr/bin/shiny-server.sh"]
