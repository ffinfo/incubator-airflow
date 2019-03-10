# -*- coding: utf-8 -*-
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
from airflow.models import DagRun, TaskInstance, Pool, DagModel, errors, Variable
from airflow.models.connection import Connection
from airflow.models.slamiss import SlaMiss
from airflow.utils.db import create_session


def clear_db_runs():
    with create_session() as session:
        session.query(DagRun).delete()
        session.query(TaskInstance).delete()


def clear_db_dags():
    with create_session() as session:
        session.query(DagModel).delete()


def clear_db_sla_miss():
    with create_session() as session:
        session.query(SlaMiss).delete()


def clear_db_errors():
    with create_session() as session:
        session.query(errors.ImportError).delete()


def clear_db_pools():
    with create_session() as session:
        session.query(Pool).delete()


def clear_db_conections():
    with create_session() as session:
        session.query(Connection).delete()


def clear_db_variables():
    with create_session() as session:
        session.query(Variable).delete()
