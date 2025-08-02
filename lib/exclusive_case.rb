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

  def exhaustive_case(value, of:, &block)
    builder = CaseBuilder.new(value, of)
    builder.instance_eval(&block)
    builder.execute
  end
end
