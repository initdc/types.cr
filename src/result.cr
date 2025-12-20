abstract struct Result(T, E)
  class UnwrapOnErr < Exception; end

  class UnwrapErrOnOk < Exception; end

  macro inherited
    {% type = @type.name(generic_args: false).stringify %}

    def is_ok : Bool
    {% if type == "Ok" %}
      true
    {% else %}
      false
    {% end %}
    end

    def is_ok_and(&block : T -> Bool) : Bool
    {% if type == "Err" %}
      false
    {% elsif type == "Ok" %}
      block.call(@value)
    {% end %}
    end

    def is_ok_and(block : T -> Bool) : Bool
    {% if type == "Err" %}
      false
    {% elsif type == "Ok" %}
      block.call(@value)
    {% end %}
    end

    def is_err : Bool
    {% if type == "Err" %}
      true
    {% else %}
      false
    {% end %}
    end

    def is_err_and(&block : E -> Bool) : Bool
    {% if type == "Ok" %}
      false
    {% elsif type == "Err" %}
      block.call(@error)
    {% end %}
    end

    def is_err_and(block : E -> Bool) : Bool
    {% if type == "Ok" %}
      false
    {% elsif type == "Err" %}
      block.call(@error)
    {% end %}
    end

    def ok : Option(T)
    {% if type == "Ok" %}
      Some(T).new(@value)
    {% elsif type == "Err" %}
      None(T).new
    {% end %}
    end

    def err : Option(E)
    {% if type == "Ok" %}
      None(E).new
    {% elsif type == "Err" %}
      Some.new(@error)
    {% end %}
    end

    def map(&block : T -> U) : Result(U, E) forall U
    {% if type == "Ok" %}
      Ok(U, E).new(block.call(@value))
    {% elsif type == "Err" %}
      Err(U, E).new(@error)
    {% end %}
    end

    def map(block : T -> U) : Result(U, E) forall U
    {% if type == "Ok" %}
      Ok(U, E).new(block.call(@value))
    {% elsif type == "Err" %}
      Err(U, E).new(@error)
    {% end %}
    end

    def map_or(default : U, &block : T -> U) : U forall U
    {% if type == "Ok" %}
      block.call(@value)
    {% elsif type == "Err" %}
      default
    {% end %}
    end

    def map_or(default : U, block : T -> U) : U forall U
    {% if type == "Ok" %}
      block.call(@value)
    {% elsif type == "Err" %}
      default
    {% end %}
    end

    def map_or_else(default : E -> U, &block : T -> U) : U forall U
    {% if type == "Ok" %}
      block.call(@value)
    {% elsif type == "Err" %}
      default.call(@error)
    {% end %}
    end

    def map_or_else(default : E -> U, block : T -> U) : U forall U
    {% if type == "Ok" %}
      block.call(@value)
    {% elsif type == "Err" %}
      default.call(@error)
    {% end %}
    end

    def map_err(&block : E -> F) : Result(T, F) forall F
    {% if type == "Ok" %}
      Ok(T, F).new(@value)
    {% elsif type == "Err" %}
      Err(T, F).new(block.call(@error))
    {% end %}
    end

    def map_err(block : E -> F) : Result(T, F) forall F
    {% if type == "Ok" %}
      Ok(T, F).new(@value)
    {% elsif type == "Err" %}
      Err(T, F).new(block.call(@error))
    {% end %}
    end

    def inspect(&block : T ->) : Result(T, E)
    {% if type == "Ok" %}
      value = @value
      block.call(value)
    {% end %}
      self
    end

    def inspect(block : T ->) : Result(T, E)
    {% if type == "Ok" %}
      value = @value
      block.call(value)
    {% end %}
      self
    end

    def inspect_err(&block : E ->) : Result(T, E)
    {% if type == "Err" %}
      error = @error
      block.call(error)
    {% end %}
      self
    end

    def inspect_err(block : E ->) : Result(T, E)
    {% if type == "Err" %}
      error = @error
      block.call(error)
    {% end %}
      self
    end

    def expect(msg : String) : T
    {% if type == "Ok" %}
      @value
    {% elsif type == "Err" %}
      raise UnwrapOnErr.new(msg)
    {% end %}
    end

    def expect_err(msg : String) : E
    {% if type == "Ok" %}
      raise UnwrapErrOnOk.new(msg)
    {% elsif type == "Err" %}
      @error
    {% end %}
    end

    def unwrap : T
    {% if type == "Ok" %}
      @value
    {% elsif type == "Err" %}
      raise UnwrapOnErr.new("Called unwrap on Err")
    {% end %}
    end

    def unwrap_err : E
    {% if type == "Ok" %}
      raise UnwrapErrOnOk.new("called `Result#unwrap_err` on an `Ok` value")
    {% elsif type == "Err" %}
      @error
    {% end %}
    end

    def unwrap_or(default : T) : T
    {% if type == "Ok" %}
      @value
    {% elsif type == "Err" %}
      default
    {% end %}
    end

    def unwrap_or_else(&block : E -> T) : T
    {% if type == "Ok" %}
      @value
    {% elsif type == "Err" %}
      block.call(@error)
    {% end %}
    end

    def unwrap_or_else(block : E -> T) : T
    {% if type == "Ok" %}
      @value
    {% elsif type == "Err" %}
      block.call(@error)
    {% end %}
    end

    def and(other : Result(U, E)) : Result(U, E) forall U
    {% if type == "Ok" %}
      other
    {% elsif type == "Err" %}
      Err(U, E).new(@error)
    {% end %}
    end

    def and_then(&block : T -> Result(U, E)) : Result(U, E) forall U
    {% if type == "Ok" %}
      block.call(@value)
    {% elsif type == "Err" %}
      Err(U, E).new(@error)
    {% end %}
    end

    def and_then(block : T -> Result(U, E)) : Result(U, E) forall U
    {% if type == "Ok" %}
      block.call(@value)
    {% elsif type == "Err" %}
      Err(U, E).new(@error)
    {% end %}
    end

    def or(other : Result(T, F)) : Result(T, F) forall F
    {% if type == "Ok" %}
      Ok(T, F).new(@value)
    {% elsif type == "Err" %}
      other
    {% end %}
    end

    def or_else(&block : E -> Result(T, F)) : Result(T, F) forall F
    {% if type == "Ok" %}
      Ok(T, F).new(@value)
    {% elsif type == "Err" %}
      block.call(@error)
    {% end %}
    end

    def or_else(block : E -> Result(T, F)) : Result(T, F) forall F
    {% if type == "Ok" %}
      Ok(T, F).new(@value)
    {% elsif type == "Err" %}
      block.call(@error)
    {% end %}
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
end

struct Err(T, E) < Result(T, E)
  @error : E

  def initialize(@error : E)
  end

  def self.[](error : E)
    new(error)
  end
end
