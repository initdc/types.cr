require "./src/option"

s = Some[0]
n = None(Int32)[]

r = Ok(Int32, String)[0]
e = Err(Int32, String)["error"]

puts "s: #{s}"
puts "n: #{n}"
puts "r: #{r}"
puts "e: #{e}"
