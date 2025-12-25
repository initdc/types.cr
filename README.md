# types

Bring the Rust [Result Option] types to Crystal

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     types:
       github: initdc/types.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "types"

s = Some[0]
n = None(Int32)[]

r = Ok(Int32, String)[0]
e = Err(Int32, String)["error"]

puts "s: #{s}"
puts "n: #{n}"
puts "r: #{r}"
puts "e: #{e}"

arr = [0, 1, 2]

p arr[0]
p Option.from(arr[0])
p arr[10]?
p Option.from?(arr[10]?)
p Option.from! { arr[10] }
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/initdc/types.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [initdc](https://github.com/initdc) - creator and maintainer
