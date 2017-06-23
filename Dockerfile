FROM ubuntu:16.04

MAINTAINER Thomas Schmidt

ENV ANDROID_HOME /opt/android-sdk

# Get the latest version from https://developer.android.com/studio/index.html
ENV ANDROID_SDK_VERSION="25.2.5"

ENV LANG en_US.UTF-8
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen $LANG

COPY README.md /README.md

WORKDIR /tmp

# Installing packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        autoconf \
        git \
        file \
        curl \
        wget \
        lib32stdc++6 \
        lib32z1 \
        lib32z1-dev \
        lib32ncurses5 \
        libc6-dev \
        libgmp-dev \
        libmpc-dev \
        libmpfr-dev \
        libxslt-dev \
        libxml2-dev \
        m4 \
        ncurses-dev \
        ocaml \
        openssh-client \
        pkg-config \
        python-software-properties \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev && \
    apt-add-repository -y ppa:openjdk-r/ppa && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/ && \
    apt-get clean

# Install Android SDK
RUN wget -q -O tools.zip https://dl.google.com/android/repository/tools_r${ANDROID_SDK_VERSION}-linux.zip && \
    unzip -q tools.zip && \
    rm -fr $ANDROID_HOME tools.zip && \
    mkdir -p $ANDROID_HOME && \
    mv tools $ANDROID_HOME/tools && \

    # Install Android components
    cd $ANDROID_HOME && \

    echo "Install android-21" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-21 && \
    echo "Install android-22" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-22 && \
    echo "Install android-23" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-23 && \
    echo "Install android-24" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-24 && \
    echo "Install android-25" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-25 && \
    echo "Install android-26" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-26 && \

    echo "Install platform-tools" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter platform-tools && \

    echo "Install build-tools-25" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-25 && \
    echo "Install build-tools-25.0.1" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-25.0.1 && \
    echo "Install build-tools-25.0.2" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-25.0.2 && \
    echo "Install build-tools-25.0.3" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-25.0.3 && \
    echo "Install build-tools-26.0.0" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-26.0.0 && \

    echo "Install extra-android-m2repository" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter extra-android-m2repository && \

    echo "Install extra-google-google_play_services" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter extra-google-google_play_services && \

    echo "Install extra-google-m2repository" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter extra-google-m2repository

# Add android commands to PATH
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH $PATH:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools


# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS "-Xms512m -Xmx1024m"
ENV GRADLE_OPTS "-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"
