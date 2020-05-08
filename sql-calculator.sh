#!/bin/bash
# Auteur: n3ird4
# Date: Fri May  8 00:42:42 CEST 2020
#

mysql -e "SHOW VARIABLES; SHOW STATUS" | awk '
{
VAR[$1]=$2
}
END {
MAX_CONN = VAR["max_connections"]
MAX_USED_CONN = VAR["Max_used_connections"]
BASE_MEM=VAR["key_buffer_size"] + VAR["query_cache_size"] + VAR["innodb_buffer_pool_size"] + VAR["innodb_additional_mem_pool_size"] + VAR["innodb_log_buffer_size"]
MEM_PER_CONN=VAR["read_buffer_size"] + VAR["read_rnd_buffer_size"] + VAR["sort_buffer_size"] + VAR["join_buffer_size"] + VAR["binlog_cache_size"] + VAR["thread_stack"] + VAR["tmp_table_size"]
MEM_TOTAL_MIN=BASE_MEM + MEM_PER_CONN*MAX_USED_CONN
MEM_TOTAL_MAX=BASE_MEM + MEM_PER_CONN*MAX_CONN
printf "+---------------------------------+--------------------+\n"
printf "| %31s | %15.3f MB |\n", "key_buffer_size", VAR["key_buffer_size"]/1048576
printf "| %31s | %15.3f MB |\n", "key_buffer_size", VAR["key_buffer_size"]
#
# query cache is deprecated as of MySQL 5.7.20
printf "| %31s | %15.3f MB |\n", "query_cache_size", VAR["query_cache_size"]/1048576
printf "| %31s | %15.3f MB |\n", "innodb_buffer_pool_size", VAR["innodb_buffer_pool_size"]/1048576
#
# innodb_additional_mem_pool_size is removed in MySQL 5.7
printf "| %31s | %15.3f MB |\n", "innodb_additional_mem_pool_size", VAR["innodb_additional_mem_pool_size"]/1048576
printf "| %31s | %15.3f MB |\n", "innodb_log_buffer_size", VAR["innodb_log_buffer_size"]/1048576
printf "+---------------------------------+--------------------+\n"
printf "| %31s | %15.3f MB |\n", "BASE MEMORY$", BASE_MEM/1048576
printf "+---------------------------------+--------------------+\n"
printf "| %31s | %15.3f MB |\n", "sort_buffer_size", VAR["sort_buffer_size"]/1048576
printf "| %31s | %15.3f MB |\n", "read_buffer_size", VAR["read_buffer_size"]/1048576
printf "| %31s | %15.3f MB |\n", "read_rnd_buffer_size", VAR["read_rnd_buffer_size"]/1048576
printf "| %31s | %15.3f MB |\n", "join_buffer_size", VAR["join_buffer_size"]/1048576
printf "| %31s | %15.3f MB |\n", "thread_stack", VAR["thread_stack"]/1048576
printf "| %31s | %15.3f MB |\n", "binlog_cache_size", VAR["binlog_cache_size"]/1048576
printf "| %31s | %15.3f MB |\n", "tmp_table_size", VAR["tmp_table_size"]/1048576
printf "+---------------------------------+--------------------+\n"
printf "| %31s | %15.3f MB |\n", "MEMORY PER CONNECTION", MEM_PER_CONN/1048576
printf "+---------------------------------+--------------------+\n"
printf "| %31s | %18d |\n", "Max_used_connections", MAX_USED_CONN
printf "| %31s | %18d |\n", "max_connections", MAX_CONN
printf "+---------------------------------+--------------------+\n"
printf "| %31s | %15.3f MB |\n", "TOTAL (MIN)", MEM_TOTAL_MIN/1048576
printf "| %31s | %15.3f MB |\n", "TOTAL (MAX)", MEM_TOTAL_MAX/1048576
printf "+---------------------------------+--------------------+\n"
}'
