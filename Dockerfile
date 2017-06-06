FROM library/alpine:3.5

WORKDIR /usr/src/app

# Install the needed packages.
RUN apk add --no-cache \
	asciidoc \
	autoconf \
	automake \
	build-base \
	docbook-xsl \
	git \
	ncurses-dev \
	xmlto

# Copy the workspace
COPY . .

RUN make configure
RUN ./configure
RUN make all
RUN make doc-html
RUN make doc-man

RUN make DESTDIR=./dist \
         install \
         install-doc-html \
         install-doc-man

FROM library/alpine:3.5
WORKDIR /tmp/workspace

RUN apk add --no-cache \
	git \
	ncurses \
	readline

COPY --from=0 /usr/src/app/dist / 

ENTRYPOINT [ "tig" ]
CMD [ "--help" ]

VOLUME /usr/local/etc/tigrc
VOLUME /tmp/workspace

