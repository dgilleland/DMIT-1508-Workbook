# About Transactions

If you have a stored procedure that needs to do **more than one** `INSERT`/`UPDATE`/`DELETE` statement, then you should do these as a **Transaction**.

We start a transaction with the `BEGIN TRANSACTION` statement. We have to finish off the transaction with either a `ROLLBACK TRANSACTION` (to reverse any changes to the database) or a `COMMIT TRANSACTION`.

Your transaction should have one *BEGIN* and one *COMMIT*, but it will typically have at least two or more *ROLLBACK* statements. You should structure your logic so that after every DML statement, you check for any problems (with the global variables). If there are no problems, continue with the next DML statement. Repeat until all your DML statements are done. The final `ELSE` block should have your `COMMIT` statement.

```csharp
{
    if(ParamCheck) // params are NULL
    {
        //  - report error
    }
    else
    {
        // BEGIN TRANSACTION
        // Single DML statement
        if(Problem) 
        {
            // report error
            // ROLLBACK
        }
        else
        {
            // Single DML statement
            if(Problem) 
            {
                // report error
                // ROLLBACK
            }
            else
            {
                // Single DML statement
                if(Problem) 
                {
                    // report error
                    // ROLLBACK
                }
                else
                {
                    // COMMIT
                }
            }
        }
    }
}
```

The logic above shows the sample nesting that would occur in your logic (as compared to C#).
