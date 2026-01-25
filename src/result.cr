abstract struct Result(T, E)
  class WrapNil < Exception; end

  class UnwrapOnErr < Exception; end

  class UnwrapErrOnOk < Exception; end

  macro inherited
    @[AlwaysInline]
    def is_ok : Bool
      case self
      when Ok
        true
      else
        false
      end
    end

    @[AlwaysInline]
    def is_ok_and(&block : T -> Bool) : Bool
      case self
      when Ok
        block.call(self.@value)
      else
        false
      end
    end

    @[AlwaysInline]
    def is_ok_and(block : T -> Bool) : Bool
      case self
      when Ok
        block.call(self.@value)
      else
        false
      end
    end

    @[AlwaysInline]
    def is_err : Bool
      case self
      when Ok
        false
      else
        true
      end
    end

    @[AlwaysInline]
    def is_err_and(&block : E -> Bool) : Bool
      case self
      when Ok
        false
      else
        block.call(self.@error)
      end
    end

    @[AlwaysInline]
    def is_err_and(block : E -> Bool) : Bool
      case self
      when Ok
        false
      else
        block.call(self.@error)
      end
    end

    @[AlwaysInline]
    def ok : Option(T)
      case self
      when Ok
        Some(T).new(self.@value)
      else
        None(T).new
      end
    end

    @[AlwaysInline]
    def err : Option(E)
      case self
      when Ok
        None(E).new
      else
        Some.new(self.@error)
      end
    end

    @[AlwaysInline]
    def map(&block : T -> U) : Result(U, E) forall U
      case self
      when Ok
        Ok(U, E).new(block.call(self.@value))
      else
        Err(U, E).new(self.@error)
      end
    end

    @[AlwaysInline]
    def map(block : T -> U) : Result(U, E) forall U
      case self
      when Ok
        Ok(U, E).new(block.call(self.@value))
      else
        Err(U, E).new(self.@error)
      end
    end

    @[AlwaysInline]
    def map_or(default : U, &block : T -> U) : U forall U
      case self
      when Ok
        block.call(self.@value)
      else
        default
      end
    end

    @[AlwaysInline]
    def map_or(default : U, block : T -> U) : U forall U
      case self
      when Ok
        block.call(self.@value)
      else
        default
      end
    end

    @[AlwaysInline]
    def map_or_else(default : E -> U, &block : T -> U) : U forall U
      case self
      when Ok
        block.call(self.@value)
      else
        default.call(self.@error)
      end
    end

    @[AlwaysInline]
    def map_or_else(default : E -> U, block : T -> U) : U forall U
      case self
      when Ok
        block.call(self.@value)
      else
        default.call(self.@error)
      end
    end

    @[AlwaysInline]
    def map_err(&block : E -> F) : Result(T, F) forall F
      case self
      when Ok
        Ok(T, F).new(self.@value)
      else
        Err(T, F).new(block.call(self.@error))
      end
    end

    @[AlwaysInline]
    def map_err(block : E -> F) : Result(T, F) forall F
      case self
      when Ok
        Ok(T, F).new(self.@value)
      else
        Err(T, F).new(block.call(self.@error))
      end
    end

    @[AlwaysInline]
    def inspect(&block : T ->) : Result(T, E)
      case self
      when Ok
        value = self.@value
        block.call(value)
      else
      end
      self
    end

    @[AlwaysInline]
    def inspect(block : T ->) : Result(T, E)
      case self
      when Ok
        value = self.@value
        block.call(value)
      else
      end
      self
    end

    @[AlwaysInline]
    def inspect_err(&block : E ->) : Result(T, E)
      case self
      when Ok
      else
        error = self.@error
        block.call(error)
      end
      self
    end

    @[AlwaysInline]
    def inspect_err(block : E ->) : Result(T, E)
      case self
      when Ok
      else
        error = self.@error
        block.call(error)
      end
      self
    end

    @[AlwaysInline]
    def expect(msg : String) : T
      case self
      when Ok
        self.@value
      else
        raise UnwrapOnErr.new(msg)
      end
    end

    @[AlwaysInline]
    def expect_err(msg : String) : E
      case self
      when Ok
        raise UnwrapErrOnOk.new(msg)
      else
        self.@error
      end
    end

    @[AlwaysInline]
    def unwrap : T
      case self
      when Ok
        self.@value
      else
        raise UnwrapOnErr.new("Called unwrap on Err")
      end
    end

    @[AlwaysInline]
    def unwrap_err : E
      case self
      when Ok
        raise UnwrapErrOnOk.new("called `Result#unwrap_err` on an `Ok` value")
      else
        self.@error
      end
    end

    @[AlwaysInline]
    def unwrap_or(default : T) : T
      case self
      when Ok
        self.@value
      else
        default
      end
    end

    @[AlwaysInline]
    def unwrap_or_else(&block : E -> T) : T
      case self
      when Ok
        self.@value
      else
        block.call(self.@error)
      end
    end

    @[AlwaysInline]
    def unwrap_or_else(block : E -> T) : T
      case self
      when Ok
        self.@value
      else
        block.call(self.@error)
      end
    end

    @[AlwaysInline]
    def and(other : Result(U, E)) : Result(U, E) forall U
      case self
      when Ok
        other
      else
        Err(U, E).new(self.@error)
      end
    end

    @[AlwaysInline]
    def and_then(&block : T -> Result(U, E)) : Result(U, E) forall U
      case self
      when Ok
        block.call(self.@value)
      else
        Err(U, E).new(self.@error)
      end
    end

    @[AlwaysInline]
    def and_then(block : T -> Result(U, E)) : Result(U, E) forall U
      case self
      when Ok
        block.call(self.@value)
      else
        Err(U, E).new(self.@error)
      end
    end

    @[AlwaysInline]
    def or(other : Result(T, F)) : Result(T, F) forall F
      case self
      when Ok
        Ok(T, F).new(self.@value)
      else
        other
      end
    end

    @[AlwaysInline]
    def or_else(&block : E -> Result(T, F)) : Result(T, F) forall F
      case self
      when Ok
        Ok(T, F).new(self.@value)
      else
        block.call(self.@error)
      end
    end

    @[AlwaysInline]
    def or_else(block : E -> Result(T, F)) : Result(T, F) forall F
      case self
      when Ok
        Ok(T, F).new(self.@value)
      else
        block.call(self.@error)
      end
    end
  end

  def self.from_or(value : T, error : E) : Result(T, E)
    Ok(T, E).new(value)
  end

  def self.from_or?(value : T | Nil, error : E) : Result(T, E)
    value.nil? ? Err(T, E).new(error) : Ok(T, E).new(value)
  end

  def self.from_or!(block : -> T, error : E) : Result(T, E)
    Ok(T, E).new(block.call)
  rescue
    Err(T, E).new(error)
  end
end

struct Ok(T, E) < Result(T, E)
  @value : T

  def initialize(value : T)
    {% if T.nilable? || E.nilable? %}
      raise WrapNil.new("typeof #{{{ Ok }}} cannot includes Nil")
    {% end %}

    @value = value
  end

  def self.[](value : T)
    new(value)
  end
end

struct Err(T, E) < Result(T, E)
  @error : E

  def initialize(error : E)
    {% if T.nilable? || E.nilable? %}
      raise WrapNil.new("typeof #{{{ Err }}} cannot includes Nil")
    {% end %}

    @error = error
  end

  def self.[](error : E)
    new(error)
  end
end
