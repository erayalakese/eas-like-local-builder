FROM ubuntu:jammy

# Set environment variables for Java
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin

# Install essential packages and Java 17
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    build-essential \
    openjdk-17-jdk \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add the official Git PPA
RUN add-apt-repository ppa:git-core/ppa
# Update package list and install the latest stable Git version
RUN apt-get update && apt-get install -y git

# Install Node.js 18.18.0
RUN wget https://nodejs.org/dist/v18.18.0/node-v18.18.0-linux-x64.tar.xz \
    && tar -xJf node-v18.18.0-linux-x64.tar.xz -C /usr/local --strip-components=1 \
    && rm node-v18.18.0-linux-x64.tar.xz

# Update npm to 9.8.1 and install Yarn, pnpm, node-gyp, and eas-cli
RUN npm install -g npm@9.8.1 \
    && npm install -g yarn@1.22.21 pnpm@9.3.0 node-gyp@10.1.0 eas-cli

# Install Bun 1.1.13
ENV BUN_INSTALL /usr/local
RUN curl -fsSL https://bun.sh/install | bash -s "bun-v1.1.13"

# Install Android NDK r26b
RUN wget https://dl.google.com/android/repository/android-ndk-r26b-linux.zip \
    && unzip android-ndk-r26b-linux.zip -d /opt \
    && rm android-ndk-r26b-linux.zip

ENV NDK_HOME /opt/android-ndk-r26b

# Install Android SDK command-line tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip \
    && mkdir -p /opt/android-sdk/cmdline-tools \
    && unzip commandlinetools-linux-7583922_latest.zip -d /opt/android-sdk/cmdline-tools \
    && mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest \
    && rm commandlinetools-linux-7583922_latest.zip

# Set environment variables for Android SDK
ENV ANDROID_HOME /opt/android-sdk
ENV PATH $PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Install required Android SDK components
RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
