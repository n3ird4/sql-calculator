# sql-calculator

This script displays crucial information about MySQL in the same way as [mysqlcalculator](www.mysqlcalculator.com)

It is **highly** inspired by [check_mysql_memory_usage.sh](https://gist.github.com/fernandoaleman/5e693838f82a6858c11a534acb0f98d5) :pray:

:warning: **WARNINGS** :warning:

Be aware of [mysql-maria-memory-calculation-usage-creep](https://superuser.com/questions/1411800/mysql-maria-memory-calculation-usage-creep):
>bloc quote
"tmp_table_size Should be included in the PER-CONNECTION calculations and not in the BASE_MEMORY calculations.
The **base-memory** variables are those that are listed above the max_connections
The **per-connection** variables are listed below"


```bash
  key_buffer_size
+ query_cache_size
+ tmp_table_size  <=============================> /!\
+ innodb_buffer_pool_size
+ innodb_additional_mem_pool_size <=============> /!\
+ innodb_log_buffer_size
+ (max_connections x ( sort_buffer_size
                       + read_buffer_size
                       + read_rnd_buffer_size
                       + join_buffer_size
                       + thread_stack
                       + binlog_cache_size))
```

#### Moreover for MySQL5.7 please be aware of:

* MySQL query cache is deprecated as of MySQL 5.7.20, and is removed in MySQL 8.0
_( Source: https://dev.mysql.com/doc/refman/5.7/en/query-cache-configuration.html )_

* innodb_use_sys_malloc and innodb_additional_mem_pool_size were deprecated in MySQL 5.6 and removed in MySQL 5.7
_( Source: https://dev.mysql.com/doc/refman/5.7/en/innodb-performance-use_sys_malloc.html)_

* The innodb_buffer_pool_size configuration option can be set dynamically using a SET statement
_( Source: https://dev.mysql.com/doc/refman/5.7/en/innodb-buffer-pool-resize.html )_

* This new feature also introduced a new variable — innodb_buffer_pool_chunk_size
_( Source: https://www.percona.com/blog/2018/06/19/chunk-change-innodb-buffer-pool-resizing/ )_

* A list of the Limits in MySQL
_( Source: http://mysql.rjweb.org/doc.php/limits )_

* Allocating RAM for MySQL - The Short Answer
_( Source: http://mysql.rjweb.org/doc.php/memory )_

#### How to

* git clone https://github.com/n3ird4/sql-calculator.git on your BDD server
* chmod +x sql-calculator.sh
* bash sql-calculator.sh

```bash
w00t@n3ird4 /space/univers # bash sql-calculator.sh
+---------------------------------+--------------------+
|                 key_buffer_size |          64.000 MB |
|                query_cache_size |          96.000 MB |
|         innodb_buffer_pool_size |        2048.000 MB |
|          innodb_log_buffer_size |           8.000 MB |
+---------------------------------+--------------------+
|                    BASE MEMORY$ |        2216.000 MB |
+---------------------------------+--------------------+
|                sort_buffer_size |           1.000 MB |
|                read_buffer_size |           1.000 MB |
|            read_rnd_buffer_size |           4.000 MB |
|                join_buffer_size |           2.000 MB |
|                    thread_stack |           0.125 MB |
|               binlog_cache_size |           0.031 MB |
|                  tmp_table_size |        2560.000 MB |
+---------------------------------+--------------------+
|           MEMORY PER CONNECTION |        2568.156 MB |
+---------------------------------+--------------------+
|            Max_used_connections |                  9 |
|                 max_connections |                 80 |
+---------------------------------+--------------------+
|                     TOTAL (MIN) |       25329.406 MB |
|                     TOTAL (MAX) |      207668.500 MB |
+---------------------------------+--------------------+

```
