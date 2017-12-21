FROM ragetti/alpine-poco

MAINTAINER ragetti

RUN mkdir -p /app
WORKDIR /app

RUN   \
  apk --no-cache --no-progress add libstdc++ libgcc openssl && \
  apk --no-cache --no-progress --virtual .build-deps add cmake g++ make openssl-dev glib git linux-headers && \
  git clone https://github.com/Creepsky/creepMiner.git creepMiner.git && \
  cd creepMiner.git && \
  cmake CMakeLists.txt -DCMAKE_BUILD_TYPE=RELEASE && \
  make && \
  cp -r ./bin/* /app/ && \
  cd .. && \
  rm -r creepMiner.git && \
  apk --no-cache --no-progress del .build-deps && \
  echo "Build complete"

