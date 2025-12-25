require "./src/types"
# require "types"

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
