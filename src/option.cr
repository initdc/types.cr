abstract struct Option(T)
  class WrapNil < Exception; end

  class UnwrapNone < Exception; end

  macro inherited
    @[AlwaysInline]
    def is_some : Bool
      case self
      when Some
        true
      else
        false
      end
    end

    @[AlwaysInline]
    def is_some_and(&block : T -> Bool) : Bool
      case self
      when Some
        block.call(self.@value)
      else
        false
      end
    end

    @[AlwaysInline]
    def is_some_and(block : T -> Bool) : Bool
      case self
      when Some
        block.call(self.@value)
      else
        false
      end
    end

    @[AlwaysInline]
    def is_none : Bool
      case self
      when Some
        false
      else
        true
      end
    end

    @[AlwaysInline]
    def is_none_or(&block : T -> Bool) : Bool
      case self
      when Some
        block.call(self.@value)
      else
        true
      end
    end

    @[AlwaysInline]
    def is_none_or(block : T -> Bool) : Bool
      case self
      when Some
        block.call(self.@value)
      else
        true
      end
    end

    @[AlwaysInline]
    def expect(msg : String) : T
      case self
      when Some
        self.@value
      else
        raise UnwrapNone.new(msg)
      end
    end

    @[AlwaysInline]
    def unwrap : T
      case self
      when Some
        self.@value
      else
        raise UnwrapNone.new("Called unwrap on None")
      end
    end

    @[AlwaysInline]
    def unwrap_or(default : T) : T
      case self
      when Some
        self.@value
      else
        default
      end
    end

    @[AlwaysInline]
    def unwrap_or_else(&block : -> T) : T
      case self
      when Some
        self.@value
      else
        block.call
      end
    end

    @[AlwaysInline]
    def unwrap_or_else(block : -> T) : T
      case self
      when Some
        self.@value
      else
        block.call
      end
    end

    @[AlwaysInline]
    def map(&block : T -> U) : Option(U) forall U
      case self
      when Some
        Some(U).new(block.call(self.@value))
      else
        None(U).new
      end
    end

    @[AlwaysInline]
    def map(block : T -> U) : Option(U) forall U
      case self
      when Some
        Some(U).new(block.call(self.@value))
      else
        None(U).new
      end
    end

    @[AlwaysInline]
    def inspect(&block : T ->) : Option(T)
      case self
      when Some
        value = self.@value
        block.call(value)
      else
      end
      self
    end

    @[AlwaysInline]
    def inspect(block : T ->) : Option(T)
      case self
      when Some
        value = self.@value
        block.call(value)
      else
      end
      self
    end

    @[AlwaysInline]
    def map_or(default : U, &block : T -> U) : U forall U
      case self
      when Some
        block.call(self.@value)
      else
        default
      end
    end

    @[AlwaysInline]
    def map_or(default : U, block : T -> U) : U forall U
      case self
      when Some
        block.call(self.@value)
      else
        default
      end
    end

    @[AlwaysInline]
    def map_or_else(default : -> U, &block : T -> U) : U forall U
      case self
      when Some
        block.call(self.@value)
      else
        default.call
      end
    end

    @[AlwaysInline]
    def map_or_else(default : -> U, block : T -> U) : U forall U
      case self
      when Some
        block.call(self.@value)
      else
        default.call
      end
    end

    @[AlwaysInline]
    def ok_or(error : E) : Result(T, E) forall E
      case self
      when Some
        Ok(T, E).new(self.@value)
      else
        Err(T, E).new(error)
      end
    end

    @[AlwaysInline]
    def ok_or_else(&block : -> E) : Result(T, E) forall E
      case self
      when Some
        Ok(T, E).new(self.@value)
      else
        Err(T, E).new(block.call)
      end
    end

    @[AlwaysInline]
    def ok_or_else(block : -> E) : Result(T, E) forall E
      case self
      when Some
        Ok(T, E).new(self.@value)
      else
        Err(T, E).new(block.call)
      end
    end

    @[AlwaysInline]
    def and(other : Option(U)) : Option(U) forall U
      case self
      when Some
        other
      else
        None(U).new
      end
    end

    @[AlwaysInline]
    def and_then(&block : T -> Option(U)) : Option(U) forall U
      case self
      when Some
        block.call(self.@value)
      else
        None(U).new
      end
    end

    @[AlwaysInline]
    def and_then(block : T -> Option(U)) : Option(U) forall U
      case self
      when Some
        block.call(self.@value)
      else
        None(U).new
      end
    end

    @[AlwaysInline]
    def filter(&block : T -> Bool) : Option(T)
      case self
      when Some
        value = self.@value
        if block.call(value)
          self
        else
          None(T).new
        end
      else
        self
      end
    end

    @[AlwaysInline]
    def filter(block : T -> Bool) : Option(T)
      case self
      when Some
        value = self.@value
        if block.call(value)
          self
        else
          None(T).new
        end
      else
        self
      end
    end

    @[AlwaysInline]
    def or(other : Option(T)) : Option(T)
      case self
      when Some
        self
      else
        other
      end
    end

    @[AlwaysInline]
    def or_else(&block : -> Option(T)) : Option(T)
      case self
      when Some
        self
      else
        block.call
      end
    end

    @[AlwaysInline]
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
      raise WrapNil.new("typeof #{{{ Some }}} cannot includes Nil")
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
      raise WrapNil.new("typeof #{{{ None }}} cannot includes Nil")
    {% end %}
  end

  def self.[]
    new
  end
end
