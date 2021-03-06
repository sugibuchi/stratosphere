#!/bin/bash
########################################################################################################################
# 
#  Copyright (C) 2014 by the Stratosphere project (http://stratosphere.eu)
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
#  the License. You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
#  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
#  specific language governing permissions and limitations under the License.
# 
########################################################################################################################


bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

# get stratosphere config
. "$bin"/config.sh

if [ "$STRATOSPHERE_IDENT_STRING" = "" ]; then
        STRATOSPHERE_IDENT_STRING="$USER"
fi

JVM_ARGS="$JVM_ARGS -Xmx512m"

# auxilliary function to construct a lightweight classpath for the
# Stratosphere CLI client
constructCLIClientClassPath() {

	for jarfile in $STRATOSPHERE_LIB_DIR/*.jar ; do
		if [[ $CC_CLASSPATH = "" ]]; then
			CC_CLASSPATH=$jarfile;
		else
			CC_CLASSPATH=$CC_CLASSPATH:$jarfile
		fi
	done
	echo $CC_CLASSPATH
}

CC_CLASSPATH=`manglePathList $(constructCLIClientClassPath)`

#log=$STRATOSPHERE_LOG_DIR/stratosphere-$STRATOSPHERE_IDENT_STRING-yarn-session-$HOSTNAME.log
#log_setting="-Dlog.file="$log" -Dlog4j.configuration=file:"$STRATOSPHERE_CONF_DIR"/log4j.properties"

export STRATOSPHERE_CONF_DIR
# $log_setting

$JAVA_RUN $JVM_ARGS  -classpath $CC_CLASSPATH eu.stratosphere.yarn.Client -ship ship/ -confDir $STRATOSPHERE_CONF_DIR -j $STRATOSPHERE_LIB_DIR/*yarn-uberjar.jar $*

