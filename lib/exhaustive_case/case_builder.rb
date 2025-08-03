# frozen_string_literal: true

require "set"

module ExhaustiveCase
  # CaseBuilder handles the construction and execution of exhaustive case statements.
  # It validates cases against an optional 'of' list and ensures all required cases are handled.
  #
  # @api private
  class CaseBuilder
    def initialize(value, of)
      @value = value
      @of = of
      @cases = []
      @matched = false
      @declared_matchers = Set.new
    end

    def on(*matchers, &block)
      ensure_only_of_matchers(matchers) if @of
      ensure_unique_matchers(matchers)
      @cases << { matchers: matchers, block: block }
    end

    def execute
      # Important! Make sure this is run before executing a matcher, we need to validate
      # that the case structure is complete so we don't execute branches for an invalid
      # exhaustive case
      ensure_completeness if @of

      @cases.each do |case_def|
        if case_def[:matchers].any? { |matcher| matcher == @value }
          @matched = true
          return case_def[:block].call
        end
      end

      raise UnhandledCaseError, "No case handled value: #{@value.inspect}"
    end

    private

    def ensure_only_of_matchers(matchers)
      invalid_matchers = matchers.reject { |matcher| @of.include?(matcher) }
      return if invalid_matchers.empty?

      raise InvalidCaseError, "Invalid case(s): #{invalid_matchers.map(&:inspect).join(", ")}. " \
                              "Must be one of: #{@of.map(&:inspect).join(", ")}"
    end

    def ensure_unique_matchers(matchers)
      duplicate_matchers = matchers.select { |matcher| @declared_matchers.include?(matcher) }

      unless duplicate_matchers.empty?
        raise DuplicateCaseError, "Duplicate case(s): #{duplicate_matchers.map(&:inspect).join(", ")}. " \
                                  "Each case value can only be declared once."
      end

      @declared_matchers.merge(matchers)
    end

    def ensure_completeness
      declared_cases = @cases.flat_map { |case_def| case_def[:matchers] }.uniq
      missing_cases = @of - declared_cases
      return if missing_cases.empty?

      raise MissingCaseError, "Missing case(s): #{missing_cases.map(&:inspect).join(", ")}. " \
                              "All values from 'of' must be handled: #{@of.map(&:inspect).join(", ")}"
    end
  end
end
