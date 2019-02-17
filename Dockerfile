#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM python:3.6-slim

ARG AIRFLOW_HOME=/usr/local/airflow
ARG AIRFLOW_DEPS="all"
ARG PYTHON_DEPS=""
ARG buildDeps="freetds-dev libkrb5-dev libssl-dev libffi-dev libpq-dev git"
ARG APT_DEPS="libsasl2-dev freetds-bin build-essential default-libmysqlclient-dev apt-utils curl rsync netcat locales"

ENV PATH="$HOME/.npm-packages/bin:$PATH"

RUN if [ -n "${APT_DEPS}" ]; then apt install -y $APT_DEPS; fi \
    && apt autoremove -yqq --purge \
    && apt clean

COPY . /opt/airflow/

WORKDIR /opt/airflow
RUN set -x \
    && apt update \
    && if [ -n "${buildDeps}" ]; then apt install -y $buildDeps; fi \
    && curl -sL https://deb.nodesource.com/setup_11.x | bash - \
    && apt install -y nodejs \
    && if [ -n "${PYTHON_DEPS}" ]; then pip install --no-cache-dir ${PYTHON_DEPS}; fi \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --no-use-pep517 -e .[$AIRFLOW_DEPS] \
    && apt purge --auto-remove -yqq $buildDeps \
    && apt autoremove -yqq --purge \
    && apt clean \
    && cd /opt/airflow/airflow/www \
    && npm install \
    && npm run prod

WORKDIR $AIRFLOW_HOME
RUN mkdir -p $AIRFLOW_HOME
ENV AIRFLOW_HOME=$AIRFLOW_HOME
COPY scripts/docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
