#!/bin/bash

# docker pull ubuntu で取得するイメージのバージョン (https://hub.docker.com/_/ubuntu)
UBUNTU_VERSION=22.04
# docker pull postgres で取得するイメージのバージョン (https://hub.docker.com/_/postgres)
POSTGRES_VERSION=16.1
# インストールするRubyバージョン (https://www.ruby-lang.org/ja/downloads)
RUBY_VERSION=3.2.2
# インストールするNodeバージョン (https://nodejs.org)
NODE_VERSION=20.10

# 環境変数ファイル .env を作成する
echo UID=$(id -u) > .env
echo GID=$(id -g) >> .env
echo UBUNTU_VERSION=${UBUNTU_VERSION} >> .env
echo POSTGRES_VERSION=${POSTGRES_VERSION} >> .env
echo RUBY_VERSION=${RUBY_VERSION} >> .env
echo NODE_VERSION=${NODE_VERSION} >> .env

# mount に必要なディレクトリを作成する
mkdir -p database vscode-server workspace
# database -> PostgreSQL, MySQL等で使用する
# vscode-server -> コンテナ内でのVSCodeプラグインを管理する
# workspace -> RailsやNodeのプロジェクト本体を管理する
