# SQL Queries

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

## ERD for A01-School

![](IQSchool-ERD.png)

