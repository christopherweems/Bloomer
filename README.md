# Bloomer

A rudimentary bloom filter implementation for Swift.
Maybe one day I will optimize it.

~The API is here to stay.~


## Usage

```
var filter = BloomFilter<String>(..)
  
filter.add("BloomFilter is generic over any hashable value.")

if filter.contains("BloomFilter is generic over any hashable value.") {
  print("The filter has seen the string before.")
  
}
```
