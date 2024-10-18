FROM python:3.6-slim-buster

# Set pip default timeout
ENV PIP_DEFAULT_TIMEOUT=60

# Install dependencies
RUN apt-get update \
 && apt-get install -y bzip2 xz-utils zlib1g libxml2-dev libxslt1-dev libgomp1 libpopt0 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create directory for scancode sources
RUN mkdir scancode-toolkit

# Copy sources into docker container
COPY . scancode-toolkit

# Set workdir
WORKDIR scancode-toolkit

# Install required packages (including fingerprints)
RUN pip install "fingerprints>=0.6.0"  # Adjust based on your needs
# Run scancode for initial configuration
RUN ./scancode --reindex-licenses

# Add scancode to path
ENV PATH=$HOME/scancode-toolkit:$PATH

# Set entrypoint to be the scancode command
ENTRYPOINT ["./scancode"]
