FROM ubuntu

ARG LIBTORRENT_VER="0.13.7"
ARG RTORRENT_VER="0.9.7"

RUN apt update && \
	apt -y --no-install-recommends install ca-certificates curl autoconf automake libxmlrpc-core-c3-dev libcurl4-openssl-dev \
		build-essential zlib1g-dev libssl-dev libcppunit-dev pkg-config libtool git libncursesw5-dev

RUN git clone https://github.com/rakshasa/libtorrent.git && \
	cd libtorrent && \
	./autogen.sh && \
	./configure && \
	make && \
	make install && \
	cd .. && \
	rm -rf libtorrent

RUN curl -L -O https://github.com/rakshasa/rtorrent/releases/download/v${RTORRENT_VER}/rtorrent-${RTORRENT_VER}.tar.gz && \
	tar -xvf rtorrent-${RTORRENT_VER}.tar.gz && \
	cd rtorrent-${RTORRENT_VER} && \
	./configure  && \
	make && \
	make install && \
	cd .. && \
	rm -r rtorrent-${RTORRENT_VER}

RUN mkdir /config /downloads

RUN useradd -ms /bin/bash rtorrent

USER rtorrent
WORKDIR /home/rtorrent

COPY rtorrent.rc /home/rtorrent/.rtorrent.rc

EXPOSE 49164 6881

CMD ["/usr/local/bin/rtorrent"]
