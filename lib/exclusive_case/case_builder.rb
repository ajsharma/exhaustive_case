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
      @cases << { matchers: matchers, block: block }
    end

    def execute
      @cases.each do |case_def|
        if case_def[:matchers].any? { |matcher| matcher == @value }
          @matched = true
          return case_def[:block].call
        end
      end

      raise UnhandledCaseError, "No case handled value: #{@value.inspect}"
    end
  end
end
