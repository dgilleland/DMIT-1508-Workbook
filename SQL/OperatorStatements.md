# Operations for WHERE and HAVING Clauses

- Some kind of **comparison** on our column(s) with "acceptable values"

## Arithmetic Operators

- `+`
- `-`
- `*`
- `/`

## Relational Operators

Relational Operators are "binary" operators because they have an "operand" on either side of the operator. For example, in `Cost > 0` the two operands are `Cost` and `0`. Relational operators result in a "boolean" value: `true` or `false`.

Here's another example that involves arithmetic and relational operators:

```sql
CHECK(Total = Subtotal + GST)
```

- `>`
- `<`
- `=` - is a "comparison" operator - "are they equal?"
- `>=`
- `<=`
- `<>` NOT Equal To (also `!=`)

```
<------------------------------>
      |    |    |    |    |
     -2   -1    0    1    2
                |
                 > 0
             `<=0
```

## Logical Operators

Logical operators work with the boolean data types/values of `true` and `false`

- `AND` - Binary operator that requires both sides (operands) to be `true` for the final result to be `true`.
- `OR` - Binary operator that requires only one side (operand) to be `true` for the final result to be `true`.
- `NOT` - Unary operator that preceeds one operand and "inverts" the value. A `NOT` in front of a `true` value produces a `false` value, and vice-versa.

## Additional Operations

- `BETWEEN` - Inclusive comparison of a range of values. For example, in `CHECK(Hours BETWEEN 60 AND 120)` the range is inclusive of 60 and 120.
- `IN` - Checks if the value matches one of the values in a comma-separated list of values. For example, `CHECK(Credits IN (3, 4.5, 6))` is the equivalent of writing

  ```sql
  CHECK(Credits = 3 OR Credits = 4.5 OR Credits = 6)
  ```

- `LIKE` - Used for "pattern-matching" comparisons on string. Examples of pattern-matching operators and symbols include
  - `%` - Wildcard for zero or more characters
  - `_` - Wildcard for a single character
  - `[]` - A single character matching in the square brackets
    - `[A-Z]` - Any single character from A through Z inclusive
    - `[0-9]` - Any single character from 0 through 9 inclusive
    - `[ABC]` - Either the character `A`, `B`, or `C`
  - An example of matching a phone number:
    ```sql
    CHECK(PhoneNumber LIKE '[1-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')`
    ```

    - It will match for `'780-222-1515'`
