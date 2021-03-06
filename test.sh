#!/bin/bash

YOUR_FQDN=localhost

# Zookeeper
echo "ls /" | zkCli.sh

# HDFS
dd if=/dev/zero of=/tmp/test.txt bs=130M count=1
hdfs dfs -put /tmp/test.txt /tmp
hdfs dfs -ls /tmp/test.txt
hdfs dfs -rm -skipTrash /tmp/test.txt
rm -f /tmp/test.txt

# YARN and MapReduce
yarn jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.3.jar pi 3 100

# Spark
spark-submit --class org.apache.spark.examples.SparkPi --deploy-mode client --master yarn /opt/spark/examples/jars/spark-examples_2.11-2.0.2.jar 50

# HBase
hbase shell <<EOF
create 'test', 'f1'
put 'test', 'row1', 'f1', 'value1'
put 'test', 'row2', 'f1', 'value2'
put 'test', 'row3', 'f1', 'value3'
scan 'test'
disable 'test'
drop 'test'
EOF

# Hive
beeline -u "jdbc:hive2://$YOUR_FQDN:10000/default" -nroot -e "create table test (id int); insert into test values (1), (2), (3); select count(*) from test; drop table test;"
