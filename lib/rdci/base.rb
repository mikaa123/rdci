# Inspired by Steen Lehmann's source code for DCI ruby implementation

class String
  def underscore
    gsub(/[A-Z]/) { |p| "_" + p.downcase }[1..-1]
  end
end


module Rdci

  module ContextAccessor
    def context
      Thread.current[:context]
    end
  end

  module Role
    def self.included(base)
      base.extend ContextAccessor
      base.extend ClassMethods
    end

    # This code takes unknown constant names and looks-up an
    # instance variable with the same name in the current context
    module ClassMethods
      def const_missing(name)
        self.context.send name.to_s.underscore
      end
    end
  end

  module Context
    include ContextAccessor

    def context=(ctx)
      Thread.current[:context] = ctx
    end

    # Pass a block to this to have it executed with this context set
    def in_context
      old_context = self.context
      self.context = self
      yield
      self.context = old_context
    end
  end

end
