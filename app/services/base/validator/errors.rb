# frozen_string_literal: true

module Base
  class Validator
    module Errors
      class InvalidParams < ArgumentError
        MESSAGE = 'Invalid parameters passed'

        attr_reader :extra

        def initialize(extra)
          super(MESSAGE)
          @extra = extra
        end

        def info
          { error: message }.tap do |hash|
            hash[:extra] = extra unless extra.empty?
          end
        end
      end
    end
  end
end
