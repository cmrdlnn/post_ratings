# frozen_string_literal: true

require 'dry-validation'

module Base
  class Validator
    def self.contract
      @contract ||= self::Contract.new
    end

    def self.call(params, rest = {})
      new(params, rest).call
    end

    attr_reader :errors, :params

    def initialize(params, rest = {})
      params_to_validate = params.to_h.merge(rest)
      result = self.class.contract.call(params_to_validate)
      @errors = result.errors.to_h
      validate!
      @params = result.to_h
    end

    private

    def validate!
      return true if errors.blank?
      raise Errors::InvalidParams, errors
    end
  end
end
