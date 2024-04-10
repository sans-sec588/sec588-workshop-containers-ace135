FROM debian:bookworm

ENV LANG en_US.utf8
ENV PATH="${PATH}:/root/bin:/root/go/bin"

RUN apt-get update \
        && apt-get install -y locales curl \
				git golang \
				jq \
				python3 python3-pip \
				python3.11-venv unzip \
				wget \
        && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

WORKDIR /root

RUN cd /root; curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    	&& unzip awscliv2.zip \
	&& ./aws/install

RUN python3 -m pip install s3-account-search --break-system-packages

COPY files/install-tools.sh /root/install-tools.sh

RUN bash /root/install-tools.sh

RUN mkdir /root/bin \
		&& cd /root/bin \
		&& wget https://github.com/projectdiscovery/subfinder/releases/download/v2.6.6/subfinder_2.6.6_linux_amd64.zip \
		&& unzip subfinder_2.6.6_linux_amd64.zip \
		&& chmod a+x /root/bin/subfinder \
		&& rm -Rf /root/bin/subfinder*.zip

RUN go install -v github.com/sa7mon/s3scanner@latest