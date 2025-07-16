FROM node:22.14.0-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    ca-certificates \
    chromium \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils \
    apt-transport-https \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Set path for puppeteer-real-browser (usually /usr/bin/chromium)
ENV CHROME_BIN=/usr/bin/chromium

# Install pnpm globally
RUN npm install -g pnpm

WORKDIR /usr/src/app

# Copy package files and install dependencies using pnpm
COPY package*.json ./
COPY . .

RUN pnpm install --frozen-lockfile

# Copy remaining application code and build
RUN pnpm run build

EXPOSE 8080
ENV NODE_ENV=production

CMD ["pnpm", "run", "start"]