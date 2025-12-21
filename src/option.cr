require "./result"

abstract struct Option(T)
  class WrapingNil < Exception; end

  class UnwrapNone < Exception; end

  macro inherited
    {% type = @type.name(generic_args: false) %}

    def is_some : Bool
    {% if type == "Some" %}
      true
    {% else %}
      false
    {% end %}
    end

    def is_some_and(&block : T -> Bool) : Bool
    {% if type == "None" %}
      false
    {% elsif type == "Some" %}
      block.call(@value)
    {% end %}
    end

    def is_some_and(block : T -> Bool) : Bool
    {% if type == "None" %}
      false
    {% elsif type == "Some" %}
      block.call(@value)
    {% end %}
    end

    def is_none : Bool
    {% if type == "None" %}
      true
    {% else %}
      false
    {% end %}
    end

    def is_none_or(&block : T -> Bool) : Bool
    {% if type == "None" %}
      true
    {% elsif type == "Some" %}
      block.call(@value)
    {% end %}
    end

    def is_none_or(block : T -> Bool) : Bool
    {% if type == "None" %}
      true
    {% elsif type == "Some" %}
      block.call(@value)
    {% end %}
    end

    def expect(msg : String) : T
    {% if type == "Some" %}
      @value
    {% elsif type == "None" %}
      raise UnwrapNone.new(msg)
    {% end %}
    end

    def unwrap : T
    {% if type == "Some" %}
      @value
    {% elsif type == "None" %}
      raise UnwrapNone.new("Called unwrap on None")
    {% end %}
    end

    def unwrap_or(default : T) : T
    {% if type == "Some" %}
      @value
    {% elsif type == "None" %}
      default
    {% end %}
    end

    def unwrap_or_else(&block : -> T) : T
    {% if type == "Some" %}
      @value
    {% elsif type == "None" %}
      block.call
    {% end %}
    end

    def unwrap_or_else(block : -> T) : T
    {% if type == "Some" %}
      @value
    {% elsif type == "None" %}
      block.call
    {% end %}
    end

    def map(&block : T -> U) : Option(U) forall U
    {% if type == "Some" %}
      Some(U).new(block.call(@value))
    {% elsif type == "None" %}
      None(U).new
    {% end %}
    end

    def map(block : T -> U) : Option(U) forall U
    {% if type == "Some" %}
      Some(U).new(block.call(@value))
    {% elsif type == "None" %}
      None(U).new
    {% end %}
    end

    def inspect(&block : T ->) : Option(T)
    {% if type == "Some" %}
      value = @value
      block.call(value)
    {% end %}
      self
    end

    def inspect(block : T ->) : Option(T)
    {% if type == "Some" %}
      value = @value
      block.call(value)
    {% end %}
      self
    end

    def map_or(default : U, &block : T -> U) : U forall U
    {% if type == "Some" %}
      block.call(@value)
    {% elsif type == "None" %}
      default
    {% end %}
    end

    def map_or(default : U, block : T -> U) : U forall U
    {% if type == "Some" %}
      block.call(@value)
    {% elsif type == "None" %}
      default
    {% end %}
    end

    def map_or_else(default : -> U, &block : T -> U) : U forall U
    {% if type == "Some" %}
      block.call(@value)
    {% elsif type == "None" %}
      default.call
    {% end %}
    end

    def map_or_else(default : -> U, block : T -> U) : U forall U
    {% if type == "Some" %}
      block.call(@value)
    {% elsif type == "None" %}
      default.call
    {% end %}
    end

    def ok_or(error : E) : Result(T, E) forall E
    {% if type == "Some" %}
      Ok(T, E).new(@value)
    {% elsif type == "None" %}
      Err(T, E).new(error)
    {% end %}
    end

    def ok_or_else(&block : -> E) : Result(T, E) forall E
    {% if type == "Some" %}
      Ok(T, E).new(@value)
    {% elsif type == "None" %}
      Err(T, E).new(block.call)
    {% end %}
    end

    def ok_or_else(block : -> E) : Result(T, E) forall E
    {% if type == "Some" %}
      Ok(T, E).new(@value)
    {% elsif type == "None" %}
      Err(T, E).new(block.call)
    {% end %}
    end

    def and(other : Option(U)) : Option(U) forall U
    {% if type == "Some" %}
      other
    {% elsif type == "None" %}
      None(U).new
    {% end %}
    end

    def and_then(&block : T -> Option(U)) : Option(U) forall U
    {% if type == "Some" %}
      block.call(@value)
    {% elsif type == "None" %}
      None(U).new
    {% end %}
    end

    def and_then(block : T -> Option(U)) : Option(U) forall U
    {% if type == "Some" %}
      block.call(@value)
    {% elsif type == "None" %}
      None(U).new
    {% end %}
    end

    def filter(&block : T -> Bool) : Option(T)
    {% if type == "Some" %}
      if block.call(@value)
        self
      else
        None(T).new
      end
    {% elsif type == "None" %}
      self
    {% end %}
    end

    def filter(block : T -> Bool) : Option(T)
    {% if type == "Some" %}
      if block.call(@value)
        self
      else
        None(T).new
      end
    {% elsif type == "None" %}
      self
    {% end %}
    end

    def or(other : Option(T)) : Option(T)
    {% if type == "Some" %}
      self
    {% elsif type == "None" %}
      other
    {% end %}
    end

    def or_else(&block : -> Option(T)) : Option(T)
    {% if type == "Some" %}
      self
    {% elsif type == "None" %}
      block.call
    {% end %}
    end

    def or_else(block : -> Option(T)) : Option(T)
    {% if type == "Some" %}
      self
    {% elsif type == "None" %}
      block.call
    {% end %}
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

  def self.from(value : T) : Option(T)
    Some(T).new(value)
  end

  def self.from?(value : T | Nil) : Option(T)
    value.nil? ? None(T).new : Some(T).new(value)
  end

  def self.from!(&block : -> T) : Option(T)
    Some(T).new(block.call)
  rescue
    None(T).new
  end

  def self.from!(block : -> T) : Option(T)
    Some(T).new(block.call)
  rescue
    None(T).new
  end
end

struct Some(T) < Option(T)
  @value : T

  def initialize(value : T)
    {% if T.nilable? %}
      raise WrapingNil.new("typeof #{{{Some}}} cannot includes Nil")
    {% end %}

    @value = value
  end

  def self.[](value : T)
    new(value)
  end
end

struct None(T) < Option(T)
  def initialize
    {% if T.nilable? %}
      raise WrapingNil.new("typeof #{{{None}}} cannot includes Nil")
    {% end %}
  end

  def self.[]
    new
  end
end
