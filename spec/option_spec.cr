require "./spec_helper"

describe Option do
  it "is_some" do
    x : Option(Int32) = Some.new(2)
    x.is_some.should be_true

    y : Option(Int32) = None(Int32).new
    y.is_some.should be_false
  end

  it "is_some_and" do
    x = Some[2]
    x.is_some_and { |x| x > 1 }.should be_true

    y = Some[0]
    y.is_some_and { |x| x > 1 }.should be_false

    z = None(Int32).new
    z.is_some_and { |x| x > 1 }.should be_false

    a = Some["hello"]
    a.is_some_and { |x| x.size > 1 }.should be_true
  end

  it "is_none" do
    x = Some[2]
    x.is_none.should be_false

    y = None(Int32).new
    y.is_none.should be_true
  end

  it "is_none_or" do
    x = Some[2]
    x.is_none_or { |x| x > 1 }.should be_true

    y = Some[0]
    y.is_none_or { |x| x > 1 }.should be_false

    z = None(Int32).new
    z.is_none_or { |x| x > 1 }.should be_true

    a = Some["hello"]
    a.is_none_or { |x| x.size > 1 }.should be_true
  end

  it "expect" do
    x = Some["value"]
    x.expect("error").should eq("value")

    y = None(Int32).new
    expect_raises(Option::UnwrapNone) { y.expect("error") }
  end

  it "unwrap" do
    x = Some["value"]
    x.unwrap.should eq("value")

    y = None(Int32).new
    expect_raises(Option::UnwrapNone) { y.unwrap }
  end

  it "unwrap_or" do
    x = Some["value"]
    x.unwrap_or("default").should eq("value")

    y = None(Int32).new
    y.unwrap_or(2).should eq(2)
  end

  it "unwrap_or_else" do
    k = 10
    x = Some[4]
    x.unwrap_or_else(-> { 2*k }).should eq(4)

    y = None(Int32).new
    y.unwrap_or_else(-> { 2*k }).should eq(20)
  end

  it "map" do
    x = Some["hello"]
    x.map { |x| x.size }.should eq(Some[5])
    x.map(->(x : String) { x.size }).should eq(Some[5])

    y = None(String).new
    y.map { |x| x.size }.should eq(None(Int32).new)
  end

  it "inspect" do
    x = Some[0]
    x.inspect { |x| x + 1 }.should eq Some[0]

    y = None(Int32)[]
    y.inspect { |x| x + 1 }.should eq None(Int32)[]
  end

  it "map_or" do
    x = Some["foo"]
    x.map_or(42, ->(x : String) { x.size }).should eq(3)

    y = None(String).new
    y.map_or(42, ->(x : String) { x.size }).should eq(42)
  end

  it "map_or_else" do
    k = 21
    x = Some["foo"]
    x.map_or_else(-> { 2*k }, ->(x : String) { x.size }).should eq(3)

    y = None(String).new
    y.map_or_else(-> { 2*k }, ->(x : String) { x.size }).should eq(42)
  end

  it "ok_or" do
    x = Some["foo"]
    x.ok_or(0).should eq(Ok(String, Int32)["foo"])

    y = None(String).new
    y.ok_or(0).should eq(Err(String, Int32)[0])
  end

  it "ok_or_else" do
    x = Some["foo"]
    x.ok_or_else { 0 }.should eq(Ok(String, Int32)["foo"])

    y = None(String).new
    y.ok_or_else { 0 }.should eq Err(String, Int32)[0]
  end

  it "and" do
    x1 = Some[2]
    y1 = None(String)[]
    x1.and(y1).should eq None(String)[]

    x2 = None(Int32)[]
    y2 = Some["foo"]
    x2.and(y2).should eq None(String)[]

    x3 = Some[2]
    y3 = Some["foo"]
    x3.and(y3).should eq Some["foo"]

    x4 = None(Int32)[]
    y4 = None(String)[]
    x4.and(y4).should eq None(String)[]
  end

  it "and_then" do
    x = Some[2]
    y = Some["foo"]
    z = None(Int32).new

    x.and_then { |x| Some.new(x.to_s) }.should eq(Some["2"])
    x.and_then { None(Int32).new }.should eq(None(Int32).new)
    y.and_then { |x| Some[x.size] }.should eq(Some[3])
    z.and_then { |x| Some.new(x.to_s) }.should eq(None(String).new)
  end

  it "filter" do
    even = ->(x : Int32) { x % 2 == 0 }

    None(Int32)[].filter(even).should eq(None(Int32)[])
    Some[3].filter(even).should eq(None(Int32)[])
    Some[4].filter(even).should eq(Some[4])
  end

  it "or" do
    x1 = Some[2]
    y1 = None(Int32)[]
    x1.or(y1).should eq(Some[2])

    x2 = None(Int32)[]
    y2 = Some[100]
    x2.or(y2).should eq(Some[100])

    x3 = Some[2]
    y3 = Some[100]
    x3.or(y3).should eq(Some[2])

    x4 = None(Int32)[]
    y4 = None(Int32)[]
    x4.or(y4).should eq(None(Int32)[])
  end

  it "or_else" do
    nobody = -> { None(String)[] }
    vikings = -> { Some["vikings"] }

    Some["barbarians"].or_else(nobody).should eq(Some["barbarians"])
    None(String)[].or_else(vikings).should eq(Some["vikings"])
    None(String)[].or_else(nobody).should eq(None(String)[])
  end

  it "xor" do
    x1 = Some[2]
    y1 = None(Int32)[]
    x1.xor(y1).should eq(Some[2])

    x2 = None(Int32)[]
    y2 = Some[2]
    x2.xor(y2).should eq(Some[2])

    x3 = Some[2]
    y3 = Some[2]
    x3.xor(y3).should eq(None(Int32)[])

    x4 = None(Int32)[]
    y4 = None(Int32)[]
    x4.xor(y4).should eq(None(Int32)[])
  end

  it "new" do
    expect_raises(Option::WrapingNil) { Some[nil] }
    expect_raises(Option::WrapingNil) { None(Nil)[] }
    expect_raises(Option::WrapingNil) { Some(Bool?)[false] }
    expect_raises(Option::WrapingNil) { None(Bool?)[] }
  end
end
