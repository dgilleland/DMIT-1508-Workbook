# SQL Queries and Views

The samples and practice questions in this folder walk through the use of SQL Queries and Views and are based on the database A01-School. You can create the database with data by running the [install script](./A01-School.sql). The complete ERD for this database is found at the [end of this document](#erd-for-a01-school).

> A good reference for the grammar of [SQL Queries](https://dmarshnait.github.io/dmit1508/queries) and [Views](https://dmarshnait.github.io/dmit1508/views) can be found on [Dana Marsh's site](https://dmarshnait.github.io/dmit1508/).

The comments below on the supplied script files highlight notable points on the problem statements and their relation to generating SQL solutions.

----

## Overview

The idea of working with queries is to retrieve information from databases. It's the 'R' in CRUD (Create, Read, Update, and Delete).

Pulling information from a database makes no changes to the contents of the database tables - it's simply a way to get (and potentially "reshape") information that we are interested in.

`SELECT` statements have 6 clauses:

- **`SELECT` clause** - Identify the data we want to retrieve
- **`FROM` clause** - Identify where to get that data (one or more tables/views)
- **`WHERE` clause** - Filter the rows based on some condition
- **`GROUP BY` clause** - Group information (typically for Aggregation purposes: `AVG`, `COUNT`, `SUM`, etc.)
- **`HAVING` clause** - Filter the grouped information based on some aggregate value(s)
- **`ORDER BY` clause** - Sort the results

Once you know how the basics of `SELECT` statements work, you can begin making more complex queries through **subqueries**. Your queries can also be stored as part of the database in these things called **Views**. We can then turn around and use the Views we've created as the source of the information we want in the FROM clause of any new query we want to make.

Lastly, we'll looked at using the `UNION` keyword to bring together the results of two or more `SELECT` statements as a single result table.

----

## [`A - Simple Select Exercise.sql`](./A%20-%20Simple%20Select%20Exercise.sql)

This document begins the introduction to the `SELECT` statement in SQL with samples that use "literal" values and expressions. The SELECT statement is made up of six clauses:

```sql
SELECT clause   -- (Required) Identify the columns/data we want to retrieve
FROM clause     -- Identify the table(s) to look at for the data
WHERE clause    -- Filter the results of the search/query
GROUP BY clause -- Re-organize the rows into groups for some aggregation
HAVING clause   -- Filter the results of our grouping
ORDER BY clause -- Sort our final results
```

The remaining problem statements focus on using the SELECT to query the database for information in specific tables.

----

## [`B - Simple Select Exercise.sql`](./B%20-%20Simple%20Select%20Exercise.sql)

This document introduces the concept of Aggregate functions using single tables. The following problem statement from this document illustrates thinking of the COUNT() aggregate function.

> ```sql
> -- 10. How many students are in club 'CSS'?
> ```
> 
> This is a good example of having to refer to the ERD. The only place where "clubs" are mentioned are in the **Club** and **Activity** tables. Students appear in the **Activity** table too. So the place to look for the data is the Activity table.
>   
> Do a `SELECT *` on that table to see all the data and to see if it might have what you are looking for.
> 
> ![B10 Data](./Images/B-10-Data.png)


----

## [`C - Simple Select Exercise.sql`](./C%20-%20Simple%20Select%20Exercise.sql)

This document introduces the using the `GROUP BY` clause with aggregate functions using single tables. The following problem statements from this document illustrate reading a problem statement to discern the need for grouping.

> 10. Remember to jot notes or highlight parts of your problem statement. They can give direct clues to your solution, as in this sample problem.
> 
>     ![C10 Question](./Images/C-10-Question.png)
> 
>     The essense of this problem statement is that they want to see the correlation between course hours and average course costs.
> 
>     ![C10 Result](./Images/C-10-Result.png)
> 
> 11. Note that in this problem statement, we are told about the data that is needed and the sorting that has to be applied. Nothing explicit is mentioned about grouping, but the fact that both aggregate and non-aggregate data has to be retrieved should give us a hint that grouping by the `StaffID` is required.
> 
>     ![C11 Question](./Images/C-11-Question.png)

----

## [`D - Simple Joins Exercise.sql`](./D%20-%20Simple%20Joins%20Exercise.sql)

----

## [`E - String and Date functions.sql`](./E%20-%20String%20and%20Date%20functions.sql)

----

## [`F - Inner Joins with Aggregates.sql`](./F%20-%20Inner%20Joins%20with%20Aggregates.sql)

----

## [`G - Outer Joins.sql`](./G%20-%20Outer%20Joins.sql)

----

## [`H - Subqueries.sql`](./H%20-%20Subqueries.sql)

----

## [`I - Views.sql`](./I%20-%20Views.sql)

----

## [`J - Unions.sql`](./J%20-%20Unions.sql)

----

## ERD for A01-School

![ERD](./IQSchool-ERD.png)
