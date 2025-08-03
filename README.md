# Exclusive Case

[![Gem Version](https://badge.fury.io/rb/exhaustive_case.svg)](https://badge.fury.io/rb/exhaustive_case)
[![CI](https://github.com/ajsharma/exhaustive_case/actions/workflows/ci.yml/badge.svg)](https://github.com/ajsharma/exhaustive_case/actions/workflows/ci.yml)

Exhaustive case statements for Ruby to prevent bugs from unhandled cases when new values are added to a system.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exhaustive_case'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install exhaustive_case
```

## Usage

Include the module to get access to the `exhaustive_case` method:

```ruby
require 'exhaustive_case'
include ExhaustiveCase

# Now you can use exhaustive_case
result = exhaustive_case user_status do
  on(:active) { "User is active" }
  on(:inactive) { "User is inactive" }
  on(:pending) { "User is pending approval" }
end
```

or to avoid globally adding the module, it can be included in a class:

```ruby
require 'exhaustive_case'

class UserRenderer
  include ExhaustiveCase

  def handle_status(user_status)
    # Now you can use exhaustive_case
    result = exhaustive_case user_status do
      on(:active) { "User is active" }
      on(:inactive) { "User is inactive" }
      on(:pending) { "User is pending approval" }
    end
  end
end
```

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

## Enhanced validation with `of:` parameter

In situations where the central system relies on a series of strategies or an enumerated list, it's often unclear where a growing codebase new logic should be added.

By declaring explicitly the known list of forks, the list of forks can be centralized and then the test suite can provide feedback when a new entry to the list is added or removed.

For even stronger guarantees, you can specify the complete list of acceptable inputs using the `of:` parameter. This ensures that:

1. All declared cases must belong to the specified list
2. All values in the `of:` list must be handled by at least one case

```ruby
# Define all possible values upfront
VALID_LETTERS = ['A', 'B', 'C'].freeze

exhaustive_case letter, of: VALID_LETTERS do 
  on('A') { // handle A }
  on('B') { // handle B }
  on('C') { // handle C }
end
```

This will raise an `InvalidCaseError` if:
- You try to handle a case not in the `of:` list: `on('D') { ... }` 
- You forget to handle all cases: missing `on('C') { ... }`

The `of:` parameter is optional - without it, `exhaustive_case` works as before, only validating that the input value has a matching case.

### Examples with `of:`

```ruby
# Status handling with validation
STATUSES = [:pending, :success, :failure].freeze

result = exhaustive_case status, of: STATUSES do
  on(:pending) { "Processing..." }
  on(:success) { "Completed successfully" }
  on(:failure) { "Failed with error" }
end

# Multiple values per case still work
USER_TYPES = [:admin, :moderator, :user, :guest].freeze

permissions = exhaustive_case user_type, of: USER_TYPES do
  on(:admin) { [:read, :write, :delete, :manage] }
  on(:moderator, :user) { [:read, :write] }
  on(:guest) { [:read] }
end
```

if a new status is added to `STATUSES` a test suite should reveal that a case is missing.

## Error Handling

The following are the expected errors when using the gem:

- **`UnhandledCaseError`** - Raised when the input value doesn't match any `on` clause
- **`InvalidCaseError`** - Raised when using `of:` and an `on` clause contains a value not in the allowed list
- **`MissingCaseError`** - Raised when using `of:` and not all allowed values have corresponding `on` clauses

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ajsharma/exhaustive_case.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
