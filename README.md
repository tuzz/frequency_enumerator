## Frequency Enumerator

Yields hashes that correlate with the given frequency distribution.

## Concept

If you're using brute-force search to solve some problem, it makes sense to carry out some frequency analysis on the problem first.

Consider a simple example of trying to figure out which combinations of items cost a known total:

```
Total: £2.00

Item prices: Tea (£0.20), Coffee (£0.30), Biscuit (£0.15)
```

We could use *maths* to solve this problem. Or we could brute-force it.

For the latter, you'd go through every combination of these items and see which totalled £2.00. In this example, that'd take no time at all, but what if we're dealing with huge sums of money, or there are dozens of items? What if we're brute-forcing passwords?

It helps to do some [frequency analysis](https://github.com/cpatuzzo/frequency_analyser) first.

You might discover, that in fact, almost no one drinks tea and everyone loves biscuits. You might ask a couple of hundred people and end up with a frequency distribution like this:

```ruby
{ :tea => 25, :coffee => 60, :biscuit => 115 }
```

It'd be nice if we could brute-force the problem, but be more intelligent about the order in which we do so. We should use make use of our valuable, newfound knowledge.

And that's exactly what Frequency Enumerator does. (I got there in the end!)

You simply feed it a frequency distribution and it does its best to spew out 'attempts' that correlate with the given distribution. In our case, we'd do something like this:

## Usage

```ruby
# gem install frequency_enumerator

require 'frequency_enumerator'

distribution = { :tea => 25, :coffee => 60, :biscuit => 115 }
bits_required = 4 # 0..15 should be enough for our simple problem

FrequencyEnumerator.new(distribution, :bit_count => bits_required).each do |hash|
  # ...
end
```

The first 10 attempts yielded to the block are:

```ruby
{ :tea=>0, :coffee=>0, :biscuit=>0 }
{ :tea=>0, :coffee=>0, :biscuit=>1 }
{ :tea=>0, :coffee=>0, :biscuit=>2 }
{ :tea=>0, :coffee=>0, :biscuit=>3 }
{ :tea=>0, :coffee=>1, :biscuit=>0 }
{ :tea=>0, :coffee=>1, :biscuit=>1 }
{ :tea=>0, :coffee=>1, :biscuit=>2 }
{ :tea=>0, :coffee=>1, :biscuit=>3 }
{ :tea=>0, :coffee=>0, :biscuit=>4 }
{ :tea=>0, :coffee=>0, :biscuit=>5 }
```

As you can see, most of attempts change the number of biscuits, whilst we haven't even explored the possibility that tea might be in the solution yet.

# Limit

All attempts are guaranteed to be unique and appear in a deterministic order. The 'limit' method calculates the number of unique enumerations for the search space (zero-offset).

```ruby
  enum = FrequencyEnumerator.new(distribution, :bit_count => 4)
  enum.limit #=> 4095
```

So there will be 4096 enumerations yielded to the block.

## Options

You can set 'from' and 'to' to explore different portions of the search space:

```ruby
  FrequencyEnumerator.new(distribution, :from => 100, :to => 199)
```

This might be useful for multi-threading, map-reduce, or carrying on from where you left off if you're exploring a large search space.

## Real-world example

My motivation for building this gem is to more intelligently brute-force the problem of finding [self-enumerating pangrams](http://en.wikipedia.org/wiki/Pangram#Self-enumerating_pangrams) by using classical literature to build a frequency distribution of English text.

In theory, mutating the E's, T's, A's, O's and I's first should result in attempts that correlate with English text and therefore are more likely to be solutions.

## Contribution

Feel free to contribute. No commit is too small.

If you're good at optimisation, this project might be for you.

You should follow me: [@cpatuzzo](https://twitter.com/cpatuzzo)
