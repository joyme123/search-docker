#这是这个搜索引擎的开发运行环境的Dockerfile
#author:jiangpengfei
#date:2017-04-28

FROM ubuntu:16.04
#安装必要组件
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 \
    && sudo apt-get install libboost-all-dev \
    && sudo apt-get install libmysql++-dev \
    && apt-get autoremove
    && apt-get autoclean

##创建必要目录


##
COPY library /home/

RUN cd /home/library/glog \
    && ./configure \
    && make \
    && make install \
    && export GLOG_log_dir=log \
    && export GLOG_minloglevel=1 \
    && export GLOG_stderrthreshold=1 \
    && export GLOG_v=3 \
    && export GLOG_max_log_size=1 \
    && cd /home/library/cgicc-3.2.9 \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    && cd /home/library/mysql-connector-cpp \
    && git checkout 1.1 \
    && cmake . \
    && make \
    && make install \
    && cp libmysqlcppconn.so* /usr/local/lib/ \
    && cd /home/library/cpp_redis \
    && git submodule init && git submodule update \
    && mkdir build && cd build \
    && cmake .. -DCMAKE_BUILD_TYPE=Release \
    && make \
    && make install \
    # && cd /home/library/libbson \
    # && git checkout r1.6 \
    # && ./autogen.sh \
    # && cd build \
    # && cmake .. \
    # && make \
    # && make install \
    && cd /home/library/mongo-c-driver \
    && git checkout r1.6 \
    && ./autogen.sh --with-libbson=bundled \
    && make \
    && make install \
    # 安装mongo-cxx-driver
    && cd /home/library/mongo-cxx-driver \
    && git checkout releases/stable \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DBSONCXX_POLY_USE_BOOST=1 \
    -DCMAKE_INSTALL_PREFIX=/usr/local .. \
    && make \
    && make install \