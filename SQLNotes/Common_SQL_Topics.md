# SQl Questions and Answers

## When are we going to use truncate and delete?

1. TRUNCATE is a DDL command, whereas DELETE is a DML command.
1. We can’t execute a trigger in case of TRUNCATE whilst with DELETE, we can accomplish a trigger.
1. TRUNCATE is quicker than DELETE, for the reason that when we use DELETE to delete the data, at that time it store the whole statistics in the rollback gap on or after where we can get the data back after removal. In case of TRUNCATE, it will not store data in rollback gap and will unswervingly rub it out. TRUNCATE do not recover the deleted data.
1. We can use any condition in WHERE clause using DELETE but it is not possible with TRUNCATE.5.If a table is referenced by any foreign key constraints, then TRUNCATE won’t work.