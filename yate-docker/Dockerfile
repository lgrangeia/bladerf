# Yate / YateBTS for BladeRF x40 
FROM ubuntu:latest

MAINTAINER Luis Grangeia version: 0.1

RUN apt-get update && apt-get install -y build-essential software-properties-common git telnet apache2 php libapache2-mod-php libusb-1.0-0 libusb-1.0-0-dbg libusb-1.0-0-dev libgsm1 libgsm1-dev cmake automake supervisor 

# Add bladerf repositories and install CLI tools (not necessary for yate, but useful):
RUN add-apt-repository ppa:bladerf/bladerf
RUN apt-get update && apt-get install -y bladerf libbladerf-dev

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Build and install Yate:
WORKDIR /build
ADD http://yate.null.ro/tarballs/yate5/yate-5.5.0-1.tar.gz .
RUN tar xvfz yate-5.5.0-1.tar.gz
WORKDIR /build/yate
RUN ./autogen.sh && ./configure --prefix=/usr/local
RUN make && make install && ldconfig
WORKDIR / 
RUN rm -rf /build

# Build and install YateBTS:
WORKDIR /build
ADD http://yate.null.ro/tarballs/yatebts5/yate-bts-5.0.0-1.tar.gz .
RUN tar xvfz yate-bts-5.0.0-1.tar.gz
WORKDIR /build/yate-bts
RUN ./autogen.sh && ./configure --prefix=/usr/local --enable-bladerf
RUN make && make install && ldconfig
WORKDIR /
RUN rm -rf /build

# Configure Yate Web frontend:
RUN ln -s /usr/local/share/yate/nib_web /var/www/html/nib 

RUN touch /usr/local/etc/yate/snmp_data.conf /usr/local/etc/yate/tmsidata.conf

COPY yate_configs/*.conf /usr/local/etc/yate/
RUN chmod -R a+rw /usr/local/etc/yate/

# Configure supervisord to start apache2 and yate
RUN mkdir -p /var/lock/apache2
RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 5038

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
