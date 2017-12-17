FROM ragetti/alpine-poco

MAINTAINER ragetti

RUN mkdir -p /app
WORKDIR /app

RUN   \
  git clone https://github.com/Creepsky/creepMiner.git creepMiner.git && \
  cd creepMiner.git && \
  cmake CMakeLists.txt -DCMAKE_BUILD_TYPE=RELEASE -DNO_GPU=ON && \
  make && \
  cp -r ./bin/* /app/ && \
  cd .. && \
  rm -r creepMiner.git
