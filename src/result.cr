abstract struct Result(T, E)
  class UnwrapOnErr < Exception; end

  class UnwrapErrOnOk < Exception; end

  macro inherited
    def is_ok
      self.is_a?(Ok)
    end

    def is_err
      self.is_a?(Err)
    end
  end
end

struct Ok(T, E) < Result(T, E)
  @value : T

  def initialize(@value : T)
  end

  def self.[](value : T)
    new(value)
  end

  def is_ok_and(&block : T -> Bool) : Bool
    block.call(@value)
  end

  def is_ok_and(block : T -> Bool) : Bool
    block.call(@value)
  end

  def is_err_and(&block : E -> Bool) : Bool
    false
  end

  def is_err_and(block : E -> Bool) : Bool
    false
  end

  def ok : Option(T)
    Some(T).new(@value)
  end

  def err : Option(E)
    None(E).new
  end

  def expect(msg : String) : T
    @value
  end

  def expect_err(msg : String) : E
    raise UnwrapErrOnOk.new(msg)
  end

  def unwrap : T
    @value
  end

  def unwrap_err : E
    raise UnwrapErrOnOk.new("called `Result#unwrap_err` on an `Ok` value")
  end

  def unwrap_or(default : T) : T
    @value
  end

  def unwrap_or_else(&block : -> T) : T
    @value
  end

  def unwrap_or_else(block : -> T) : T
    @value
  end

  def map(&block : T -> U) : Result(U, E) forall U
    Ok(U, E).new(block.call(@value))
  end

  def map(block : T -> U) : Result(U, E) forall U
    Ok(U, E).new(block.call(@value))
  end

  def map_or(default : U, &block : T -> U) : U forall U
    block.call(@value)
  end

  def map_or(default : U, block : T -> U) : U forall U
    block.call(@value)
  end

  def map_or_else(default : E -> U, &block : T -> U) : U forall U
    block.call(@value)
  end

  def map_or_else(default : E -> U, block : T -> U) : U forall U
    block.call(@value)
  end

  def map_err(&block : E -> F) : Result(T, F) forall F
    Ok(T, F).new(@value)
  end

  def map_err(block : E -> F) : Result(T, F) forall F
    Ok(T, F).new(@value)
  end

  def inspect(&block : T ->) : Result(T, E)
    value = @value
    block.call(value)
    self
  end

  def inspect(block : T ->) : Result(T, E)
    value = @value
    block.call(value)
    self
  end

  def inspect_err(&block : E ->) : Result(T, E)
    self
  end

  def inspect_err(block : E ->) : Result(T, E)
    self
  end

  def and(other : Result(U, E)) : Result(U, E) forall U
    other
  end

  def and_then(&block : T -> Result(U, E)) : Result(U, E) forall U
    block.call(@value)
  end

  def and_then(block : T -> Result(U, E)) : Result(U, E) forall U
    block.call(@value)
  end

  def or(other : Result(T, F)) : Result(T, F) forall F
    Ok(T, F).new(@value)
  end

  def or_else(&block : E -> Result(T, F)) : Result(T, F) forall F
    Ok(T, F).new(@value)
  end

  def or_else(block : E -> Result(T, F)) : Result(T, F) forall F
    Ok(T, F).new(@value)
  end
end

struct Err(T, E) < Result(T, E)
  @error : E

  def initialize(@error : E)
  end

  def self.[](error : E)
    new(error)
  end

  def is_ok_and(&block : T -> Bool) : Bool
    false
  end

  def is_ok_and(block : T -> Bool) : Bool
    false
  end

  def is_err_and(&block : E -> Bool) : Bool
    block.call(@error)
  end

  def is_err_and(block : E -> Bool) : Bool
    block.call(@error)
  end

  def ok : Option(T)
    None(T).new
  end

  def err : Option(E)
    Some.new(@error)
  end

  def expect(msg : String) : T
    raise UnwrapOnErr.new(msg)
  end

  def expect_err(msg : String) : E
    @error
  end

  def unwrap : T
    raise UnwrapOnErr.new("Called unwrap on Err")
  end

  def unwrap_err : E
    @error
  end

  def unwrap_or(default : T) : T
    default
  end

  def unwrap_or_else(&block : E -> T) : T
    block.call(@error)
  end

  def unwrap_or_else(block : E -> T) : T
    block.call(@error)
  end

  def map(&block : T -> U) : Result(U, E) forall U
    Err(U, E).new(@error)
  end

  def map(block : T -> U) : Result(U, E) forall U
    Err(U, E).new(@error)
  end

  def map_or(default : U, &block : T -> U) : U forall U
    default
  end

  def map_or(default : U, block : T -> U) : U forall U
    default
  end

  def map_or_else(default : E -> U, &block : T -> U) : U forall U
    default.call(@error)
  end

  def map_or_else(default : E -> U, block : T -> U) : U forall U
    default.call(@error)
  end

  def map_err(&block : E -> F) : Result(T, F) forall F
    Err(T, F).new(block.call(@error))
  end

  def map_err(block : E -> F) : Result(T, F) forall F
    Err(T, F).new(block.call(@error))
  end

  def inspect(&block : T ->) : Result(T, E)
    self
  end

  def inspect(block : T ->) : Result(T, E)
    self
  end

  def inspect_err(&block : E ->) : Result(T, E)
    error = @error
    block.call(error)
    self
  end

  def inspect_err(block : E ->) : Result(T, E)
    error = @error
    block.call(error)
    self
  end

  def and(other : Result(U, E)) : Result(U, E) forall U
    Err(U, E).new(@error)
  end

  def and_then(&block : T -> Result(U, E)) : Result(U, E) forall U
    Err(U, E).new(@error)
  end

  def and_then(block : T -> Result(U, E)) : Result(U, E) forall U
    Err(U, E).new(@error)
  end

  def or(other : Result(T, F)) : Result(T, F) forall F
    other
  end

  def or_else(&block : E -> Result(T, F)) : Result(T, F) forall F
    block.call(@error)
  end

  def or_else(block : E -> Result(T, F)) : Result(T, F) forall F
    block.call(@error)
  end
end
