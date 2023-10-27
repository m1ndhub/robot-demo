FROM python:slim
ENV ROBOT_VERSION=6.1.1
ENV DISPLAY :99
ARG TEST_CASE=""
ENV TEST_CASE_ENV=${TEST_CASE}

# Update pip to the latest version
RUN pip install --upgrade pip

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    python3-pip \
    wget \
    unzip \
    bzip2 \
    libxtst6 \
    libgtk-3-0 \
    libx11-xcb-dev \
    libdbus-glib-1-2 \
    libxt6 \
    libpci-dev \
    xvfb \
    fonts-liberation \
    libasound2 \
    libcurl4 \
    libgbm1 \
    libnspr4 \
    libnss3 \
    libu2f-udev \
    libvulkan1 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/* \
    && pip install robotframework==${ROBOT_VERSION} \
                   robotframework-seleniumlibrary \
                   robotframework-requests \
                   robotframework-crypto \
                   selenium

# Install webdrivermanager without build isolation
# RUN pip install --no-build-isolation webdrivermanager

WORKDIR /app
COPY command.sh command.sh
COPY TEST_SUITE ./TEST_SUITE

CMD sh ./command.sh && robot -d ./report -o report.html TEST_SUITE/${TEST_CASE_ENV}
