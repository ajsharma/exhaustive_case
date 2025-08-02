# frozen_string_literal: true

require_relative "exclusive_case/version"
require_relative "exclusive_case/case_builder"

module ExclusiveCase
  # Generic Error class for the gem
  class Error < StandardError; end

  # Indicates that an unknown input was passed into the system.
  #
  # Correct this by changing the input or know allowed values
  class UnhandledCaseError < Error; end

  # Indicates that a case was declared that is not in the allowed 'of' list
  class InvalidCaseError < Error; end

  # Indicates that one or more cases from the initial value list was not 
  # implemented
  class MissingCaseError < Error; end

  def exhaustive_case(value, of: nil, &block)
    builder = CaseBuilder.new(value, of)
    builder.instance_eval(&block)
    builder.execute
  end
end
