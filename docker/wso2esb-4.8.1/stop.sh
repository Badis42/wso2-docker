#!/bin/bash
# --------------------------------------------------------------
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# --------------------------------------------------------------

# Stop the ESB docker cluster
memberId=1

stopMySQLServer(){
	name="esb-mysql-db-server"
	docker stop ${name}
	echo "ESB MySQL Server stopped: [name] ${name}"
	sleep 1
}
stopSVNServer() {
	name="esb-dep-sync-svn"
	docker stop ${name}
	echo "ESB Dep-sync SVN Server stopped: [name] ${name}"
	sleep 1
}

stopWkaMember() {
	name="wso2esb-${memberId}-wka"
	docker stop ${name}
	memberId=$((memberId + 1))
	echo "ESB wka member stopped: [name] ${name}"
	sleep 1
}

stopMember() {
	name="wso2esb-${memberId}"
	docker stop ${name}
	memberId=$((memberId + 1))
	echo "ESB member stopped: [name] ${name}"
	sleep 1
}

echo "Stopping ESB docker cluster..."

stopMySQLServer
stopSVNServer
stopWkaMember
stopMember
stopMember