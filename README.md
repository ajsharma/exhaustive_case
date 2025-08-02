# Exclusive Case

## The problem

If/else statements can easily lead to mistake flows when introducing new cases across the systems.

For instance, with a constant set of inputs `['A', 'B', 'C']`:

```ruby
if letter == 'A'
  // handle a
elsif letter == 'B'
  // handle b
else // implicit c
  // handle c 
end
```

However, if a new entry `D` is introduced to the system, now:

```ruby
if letter == 'A'
  // code to handle a (whoops!)
elsif letter == 'B'
  // code to handle b (whoops!)
else // implicit c and d
  // code to handle c  (whoops!)
end
```

This kind of code does not reveal itself in tests, providing no feedback to the developer that that a new flow is needed.

We can address this with a more explicit initial switch:

```ruby
if letter == 'A'
  // handle a
elsif letter == 'B'
  // handle b
elsif letter == 'C'
  // handle c
else 
  raise "Unknown letter #{letter}"
end
```

Now, a new letter would trigger the runtime error, alerting the developer to address this gap.

Note: for these examples, we're using an if/elsif/else chain, but the same concepts apply for `case/when/else` statements:

```ruby
case letter
when 'A'
  // handle a
when 'B'
  // handle b
when 'C'
  // handle c
else 
  raise "Unknown letter #{letter}"
end
```

This new syntax is better, but leaves some gaps:

1. Engineers taught to use the class `if/else` structure constantly introduce these problems.
2. The final raise statement is often "impossible" to access via testing, it's nature preventing access without mocking (especially when these types of clauses are part of private functions).

## The solution

But what if had a new type of case statement that could both ensure that all cases are correctly implemented and provide feedback if a new case has been introduced but not implemented?

Enter exhaustive case:

```ruby
exhaustive_case letter do 
  on('A') { // handle A }
  on('B') { // handle B }
  on('C') { // handle C }
end
```

with the new syntax, `exhaustive_case` handles the final else statement and raises and error if there's an unexpected.

`exhaustive_case` also tries to provide a syntax simple to the native Ruby `case` switch, with multiple matchers supported.


```ruby
exhaustive_case letter do 
  on('A') { // handle A }
  on('B', 'C') { // handle B or C }
end
```

