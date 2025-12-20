require "./result"

abstract struct Option(T)
  class UnwrapNone < Exception; end

  macro inherited
    def is_some
      self.is_a?(Some)
    end

    def is_none
      self.is_a?(None)
    end

    def and(other : Option(U)) : Option(U) forall U
      case self
      when Some
        other
      else
        None(U).new
      end
    end

    def or(other : Option(T)) : Option(T)
      case self
      when Some
        self
      else
        other
      end
    end

    def or_else(&block : -> Option(T)) : Option(T)
      case self
      when Some
        self
      else
        block.call
      end
    end

    def or_else(block : -> Option(T)) : Option(T)
      case self
      when Some
        self
      else
        block.call
      end
    end

    def xor(other : Option(T)) : Option(T)
      case {self, other}
      when {Some, None}
        self
      when {None, Some}
        other
      else
        None(T).new
      end
    end
  end
end

struct Some(T) < Option(T)
  @value : T

  def initialize(@value : T)
  end

  def self.[](value : T)
    new(value)
  end

  def is_some_and(&block : T -> Bool) : Bool
    block.call(@value)
  end

  def is_some_and(block : T -> Bool) : Bool
    block.call(@value)
  end

  def is_none_or(&block : T -> Bool) : Bool
    block.call(@value)
  end

  def is_none_or(block : T -> Bool) : Bool
    block.call(@value)
  end

  def expect(msg : String) : T
    @value
  end

  def unwrap : T
    @value
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

  def map(&block : T -> U) : Option(U) forall U
    Some.new(block.call(@value))
  end

  def map(block : T -> U) : Option(U) forall U
    Some.new(block.call(@value))
  end

  def inspect(&block : T ->) : Option(T)
    value = @value
    block.call(value)
    self
  end

  def inspect(block : T ->) : Option(T)
    value = @value
    block.call(value)
    self
  end

  def map_or(default : U, &block : T -> U) : U forall U
    block.call(@value)
  end

  def map_or(default : U, block : T -> U) : U forall U
    block.call(@value)
  end

  def map_or_else(default : -> U, &block : T -> U) : U forall U
    block.call(@value)
  end

  def map_or_else(default : -> U, block : T -> U) : U forall U
    block.call(@value)
  end

  def ok_or(error : E) : Result(T, E) forall E
    Ok(T, E).new(@value)
  end

  def ok_or_else(&block : -> E) : Result(T, E) forall E
    Ok(T, E).new(@value)
  end

  def ok_or_else(block : -> E) : Result(T, E) forall E
    Ok(T, E).new(@value)
  end

  def and_then(&block : T -> Option(U)) : Option(U) forall U
    block.call(@value)
  end

  def and_then(block : T -> Option(U)) : Option(U) forall U
    block.call(@value)
  end

  def filter(&block : T -> Bool) : Option(T)
    if block.call(@value)
      self
    else
      None(T).new
    end
  end

  def filter(block : T -> Bool) : Option(T)
    if block.call(@value)
      self
    else
      None(T).new
    end
  end
end

struct None(T) < Option(T)
  def initialize
  end

  def self.[]
    new
  end

  def is_some_and(&block : T -> Bool) : Bool
    false
  end

  def is_some_and(block : T -> Bool) : Bool
    false
  end

  def is_none_or(&block : T -> Bool) : Bool
    true
  end

  def is_none_or(block : T -> Bool) : Bool
    true
  end

  def expect(msg : String) : T
    raise UnwrapNone.new(msg)
  end

  def unwrap : T
    raise UnwrapNone.new("Called unwrap on None")
  end

  def unwrap_or(default : T) : T
    default
  end

  def unwrap_or_else(&block : -> T) : T
    block.call
  end

  def unwrap_or_else(block : -> T) : T
    block.call
  end

  def map(&block : T -> U) : Option(U) forall U
    None(U).new
  end

  def map(block : T -> U) : Option(U) forall U
    None(U).new
  end

  def inspect(&block : T ->) : Option(T)
    self
  end

  def inspect(block : T ->) : Option(T)
    self
  end

  def map_or(default : U, &block : T -> U) : U forall U
    default
  end

  def map_or(default : U, block : T -> U) : U forall U
    default
  end

  def map_or_else(default : -> U, &block : T -> U) : U forall U
    default.call
  end

  def map_or_else(default : -> U, block : T -> U) : U forall U
    default.call
  end

  def ok_or(error : E) : Result(T, E) forall E
    Err(T, E).new(error)
  end

  def ok_or_else(&block : -> E) : Result(T, E) forall E
    Err(T, E).new(block.call)
  end

  def ok_or_else(block : -> E) : Result(T, E) forall E
    Err(T, E).new(block.call)
  end

  def and_then(&block : T -> Option(U)) : Option(U) forall U
    None(U).new
  end

  def and_then(block : T -> Option(U)) : Option(U) forall U
    None(U).new
  end

  def filter(&block : T -> Bool) : Option(T)
    self
  end

  def filter(block : T -> Bool) : Option(T)
    self
  end
end
