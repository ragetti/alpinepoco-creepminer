FROM ragetti/alpine-poco

MAINTAINER ragetti

WORKDIR /app

RUN   \
  mkdir -p /app/log && \
  apk --no-cache --no-progress add libstdc++ libgcc openssl && \
  apk --no-cache --no-progress --virtual .build-deps add cmake g++ make openssl-dev glib git linux-headers 
py-pip && \
  pip install conan && \
  git clone https://github.com/Creepsky/creepMiner.git creepMiner.git && \
  cd creepMiner.git && \
  cmake CMakeLists.txt -DCMAKE_BUILD_TYPE=RELEASE -DNO_GPU=ON && \
  make && \
  cp -r ./bin/* /app/ && \
  cd .. && \
  rm -r creepMiner.git && \
  apk --no-cache --no-progress del .build-deps && \
  echo "Build complete"

