require "./spec_helper"

describe Result do
  it "is_ok" do
    x : Result(Int32, String) = Ok(Int32, String)[-3]
    x.is_ok.should be_true

    y : Result(Int32, String) = Err(Int32, String)["error"]
    y.is_ok.should be_false
  end

  it "is_ok_and" do
    x = Ok(Int32, String)[2]
    x.is_ok_and { |x| x > 1 }.should be_true

    y = Ok(Int32, String)[0]
    y.is_ok_and { |x| x > 1 }.should be_false

    z = Err(Int32, String)["error"]
    z.is_ok_and { |x| x > 1 }.should be_false

    a = Ok(String, String)["hello"]
    a.is_ok_and { |x| x.size > 1 }.should be_true
  end

  it "is_err" do
    x = Ok(Int32, String)[-3]
    x.is_err.should be_false

    y = Err(Int32, String)["error"]
    y.is_err.should be_true
  end

  it "is_err_and" do
    x = Err(Int32, File::Error)[File::NotFoundError.new("", file: "")]
    x.is_err_and { |x| x.is_a? File::NotFoundError }.should be_true

    y = Err(Int32, File::Error)[File::AccessDeniedError.new("", file: "")]
    y.is_err_and { |x| x.is_a? File::NotFoundError }.should be_false

    z = Ok(Int32, File::Error)[123]
    z.is_err_and { |x| x.is_a? File::NotFoundError }.should be_false

    a = Err(Int32, String)["hello"]
    a.is_err_and { |x| x.size > 1 }.should be_true
  end

  it "ok" do
    x = Ok(Int32, String)[2]
    x.ok.should eq(Some(Int32).new(2))

    y = Err(Int32, String)["error"]
    y.ok.should eq(None(Int32).new)
  end

  it "err" do
    x = Ok(Int32, String)[2]
    x.err.should eq(None(String).new)

    y = Err(Int32, String)["error"]
    y.err.should eq(Some(String).new("error"))
  end

  it "map" do
    x = Ok(Int8, String)[1_i8]
    x.map { |x| (x + 1).to_i32 }.should eq(Ok(Int32, String)[2])

    y = Err(Int8, String)["error"]
    y.map { |x| (x + 1).to_i32 }.should eq(Err(Int32, String)["error"])
  end

  it "map_or" do
    x = Ok(String, String)["foo"]
    x.map_or(42) { |x| x.size }.should eq(3)

    y = Err(String, String)["error"]
    y.map_or(42) { |x| x.size }.should eq(42)
  end

  it "map_or_else" do
    k = 21
    x = Ok(String, String)["foo"]

    f1 = ->(e : String) { k * 2 }
    f2 = ->(v : String) { v.size }
    x.map_or_else(f1, f2).should eq(3)

    y = Err(String, String)["error"]
    y.map_or_else(f1, f2).should eq(42)
  end

  it "map_err" do
    x = Ok(Int32, Char)[1]
    x.map_err { |e| e + "!" }.should eq(Ok(Int32, String)[1])

    y = Err(Int32, Char)['e']
    y.map_err { |e| e + "!" }.should eq(Err(Int32, String)["e!"])
  end

  it "inspect" do
    x = Ok(Int32, String)[1]
    x.inspect { |x| x + 1 }.should eq Ok(Int32, String)[1]

    y = Err(Int32, String)["error"]
    y.inspect { |x| x + 1 }.should eq Err(Int32, String)["error"]
  end

  it "inspect_err" do
    x = Ok(Int32, String)[1]
    x.inspect_err { |e| e + "!" }.should eq Ok(Int32, String)[1]

    y = Err(Int32, String)["error"]
    y.inspect_err { |e| e + "!" }.should eq Err(Int32, String)["error"]
  end

  it "expect" do
    x = Ok(Int32, String)[1]
    x.expect("test").should eq(1)

    y = Err(Int32, String)["error"]
    expect_raises(Result::UnwrapOnErr) { y.expect("test") }
  end

  it "unwrap" do
    x = Ok(Int32, String)[1]
    x.unwrap.should eq(1)

    y = Err(Int32, String)["error"]
    expect_raises(Result::UnwrapOnErr) { y.unwrap }
  end

  it "expect_err" do
    x = Ok(Int32, String)[1]
    expect_raises(Result::UnwrapErrOnOk) { x.expect_err("test") }

    y = Err(Int32, String)["error"]
    y.expect_err("test").should eq("error")
  end

  it "unwrap_err" do
    x = Ok(Int32, String)[1]
    expect_raises(Result::UnwrapErrOnOk) { x.unwrap_err }

    y = Err(Int32, String)["error"]
    y.unwrap_err.should eq("error")
  end

  it "and" do
    x1 = Ok(Int32, String)[1]
    y1 = Err(String, String)["error"]
    x1.and(y1).should eq(Err(String, String)["error"])

    x2 = Err(Int32, String)["error"]
    y2 = Ok(String, String)["hello"]
    x2.and(y2).should eq(Err(String, String)["error"])

    x3 = Err(Int32, String)["not a 2"]
    y3 = Err(String, String)["error"]
    x3.and(y3).should eq(Err(String, String)["not a 2"])

    x4 = Ok(Int32, String)[2]
    y4 = Ok(String, String)["hello"]
    x4.and(y4).should eq(Ok(String, String)["hello"])
  end

  it "and_then" do
    x = Ok(Int32, String)[1]
    x.and_then { |x| Ok(String, String)[x.to_s] }.should eq(Ok(String, String)["1"])

    x = Err(Int32, String)["error"]
    x.and_then { |x| Ok(String, String)[x.to_s] }.should eq(Err(String, String)["error"])
  end

  it "or" do
    x = Ok(Int32, Char)[2]
    y = Err(Int32, String)["error"]
    x.or(y).should eq(Ok(Int32, String)[2])

    x = Err(Int32, Char)['e']
    y = Ok(Int32, String)[2]
    x.or(y).should eq(Ok(Int32, String)[2])

    x = Err(Int32, Char)['e']
    y = Err(Int32, String)["error"]
    x.or(y).should eq(Err(Int32, String)["error"])

    x = Ok(Int32, Char)[2]
    y = Ok(Int32, String)[100]
    x.or(y).should eq(Ok(Int32, String)[2])
  end

  it "or_else" do
    sq = ->(x : Int32) { Ok(Int32, Int32)[x * x] }
    err = ->(x : Int32) { Err(Int32, Int32)[x] }

    x = Ok(Int32, Int32)[2]
    y = Err(Int32, Int32)[3]

    x.or_else(sq).or_else(sq).should eq(Ok(Int32, Int32)[2])
    x.or_else(err).or_else(sq).should eq(Ok(Int32, Int32)[2])
    y.or_else(sq).or_else(err).should eq(Ok(Int32, Int32)[9])
    y.or_else(err).or_else(err).should eq(Err(Int32, Int32)[3])
  end

  it "unwrap_or" do
    x = Ok(Int32, String)[1]
    x.unwrap_or(2).should eq(1)

    y = Err(Int32, String)["error"]
    y.unwrap_or(2).should eq(2)
  end

  it "unwrap_or_else" do
    x = Ok(Int32, String)[1]
    x.unwrap_or_else { |e| e.size }.should eq(1)

    y = Err(Int32, String)["foo"]
    y.unwrap_or_else { |e| e.size }.should eq(3)
  end

  it "from" do
    Result.from_or("error", true).should eq(Ok(Bool, String)[true])
    Result.from_or("error", false).should eq(Err(Bool, String)["error"])

    Result(String, Bool).from_or?(false, ENV["USER"]?).should eq(Ok(String, Bool)[%x(whoami).chomp])
    Result(String, Bool).from_or?(false, ENV["NOT_EXISTING"]?).should eq(Err(String, Bool)[false])

    Result.from_or!(false) { ENV["USER"] }.should eq(Ok(String, Bool)[%x(whoami).chomp])
    Result.from_or!(false) { ENV["NOT_EXISTING"] }.should eq(Err(String, Bool)[false])

    env_user = -> { ENV["USER"] }
    env_not_existing = -> { ENV["NOT_EXISTING"] }
    Result.from_or!(false, env_user).should eq(Ok(String, Bool)[%x(whoami).chomp])
    Result.from_or!(false, env_not_existing).should eq(Err(String, Bool)[false])
  end
end
