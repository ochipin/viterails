# Ruby 3.2.2 & Node 20.10 の環境を構築する
# 1. イメージのビルド
#    docker build . -t viterails -f .devcontainer/Dockerfile --build-arg USERID=$(id -u) --build-arg GROUPID=$(id -g)
# 2. コンテナ実行
#    docker run -it --rm viterails bash -p 3000:3000 -p 5173:5173 -v ...
ARG UBUNTU_VERSION=latest
FROM ubuntu:${UBUNTU_VERSION}

#
# 1. コンテナ管理ユーザの作成
# -----------------------------------------------------------------------------
# ビルド時に渡されたユーザIDとグループIDを受け取る(--build-argの値)
ARG USERID
ARG GROUPID

# "container"というユーザIDで、コンテナの管理者を作成する
RUN groupadd -g $GROUPID container && \
  useradd container --uid $USERID -g container -m -s /bin/bash

#
# 2. 必須モジュールのインストール
# -----------------------------------------------------------------------------
# tzdata インストール時に場所の入力が求められるため、インストールが停止してしまう。
# 下記環境変数を設定し入力待ちでブロックしないようにする
ENV DEBIAN_FRONTEND=noninteractive

# Rubyのインストールに必要なモジュールをインストールする
RUN apt update && apt install -y git curl build-essential tzdata gcc bison iputils-ping \
  libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev
# インストールエラーが発生しないよう、curlライブラリは順番にインストールする
RUN apt install -y libcurl4-openssl-dev && \
  apt install -y libcurl4-nss-dev && \
  apt install -y libcurl4-gnutls-dev
# Railsでデータベースを使用する際に必要になるモジュール
RUN apt install -y libpq-dev libmysqlclient-dev libmecab-dev
# YJITを有効にするために、rustをインストールする
RUN apt install -y rustc && update-ca-certificates --fresh

# Docker Docsでは非推奨のため、必要なモジュールインストール完了後は "DEBIAN_FRONTEND" の値を元に戻す.
ENV DEBIAN_FRONTEND=newt

#
# 3. Ruby on Rails, Nodeインストールの準備
# -----------------------------------------------------------------------------
# Rails, Nodeはコンテナを実行したユーザ権限で取り扱いため、作成したユーザになり替わる
USER container

# 作業ディレクトリをホーム直下に変更する
WORKDIR /home/container

#
# 4. Rubyをインストール
# -----------------------------------------------------------------------------
ARG RUBY_VERSION=3.2.2
# rbenvをインストールする
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
  echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc && \
  git clone https://github.com/rbenv/ruby-build.git .rbenv/plugins/ruby-build
# ruby・railsをインストールし、LSP補完用にSolargraphをインストールする
RUN .rbenv/bin/rbenv install ${RUBY_VERSION} && \
  .rbenv/bin/rbenv global ${RUBY_VERSION} && \
  .rbenv/shims/gem install rails solargraph

#
# 5. Node, yarnのインストール
# -----------------------------------------------------------------------------
# Node・yarnをインストールする
ARG NODE_VERSION=20.10
RUN curl https://get.volta.sh | bash && \
  /home/container/.volta/bin/volta install node@${NODE_VERSION} && \
  /home/container/.volta/bin/volta install yarn@1.22.21

#
# 6. 作業ディレクトリの設定
# -----------------------------------------------------------------------------
# 作業ディレクトリの作成
RUN mkdir -p workspace

# ホーム直下の"workspace"へ作業ディレクトリを変更する
WORKDIR /home/container/workspace

#
# 7. 使用ポート番号の設定
# -----------------------------------------------------------------------------
# Railsポート
EXPOSE 3000
# ViteでのVueポート
EXPOSE 5173
