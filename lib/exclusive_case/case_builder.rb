# frozen_string_literal: true

module ExclusiveCase
  class CaseBuilder
    def initialize(value, of)
      @value = value
      @of = of
      @cases = []
      @matched = false
    end

    def on(*matchers, &block)
      validate_matchers(matchers) if @of
      @cases << { matchers: matchers, block: block }
    end

    def execute
      validate_completeness if @of
      
      @cases.each do |case_def|
        if case_def[:matchers].any? { |matcher| matcher == @value }
          @matched = true
          return case_def[:block].call
        end
      end

      raise UnhandledCaseError, "No case handled value: #{@value.inspect}"
    end

    private

    def validate_matchers(matchers)
      invalid_matchers = matchers.reject { |matcher| @of.include?(matcher) }
      return if invalid_matchers.empty?

      raise InvalidCaseError, "Invalid case(s): #{invalid_matchers.map(&:inspect).join(', ')}. " \
                              "Must be one of: #{@of.map(&:inspect).join(', ')}"
    end

    def validate_completeness
      declared_cases = @cases.flat_map { |case_def| case_def[:matchers] }.uniq
      missing_cases = @of - declared_cases
      return if missing_cases.empty?

      raise MissingCaseError, "Missing case(s): #{missing_cases.map(&:inspect).join(', ')}. " \
                              "All values from 'of' must be handled: #{@of.map(&:inspect).join(', ')}"
    end
  end
end
