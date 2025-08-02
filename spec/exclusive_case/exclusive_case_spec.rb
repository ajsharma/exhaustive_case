# frozen_string_literal: true

RSpec.describe ExclusiveCase do
  include described_class

  describe "#exhaustive_case" do
    it "handles single value matches" do
      result = exhaustive_case("A") do
        on("A") { "handled A" }
        on("B") { "handled B" }
      end

      expect(result).to eq("handled A")
    end

    it "handles multiple value matches" do
      result = exhaustive_case("B") do
        on("A") { "handled A" }
        on("B", "C") { "handled B or C" }
      end

      expect(result).to eq("handled B or C")
    end

    it "raises UnhandledCaseError for unmatched values" do
      expect do
        exhaustive_case("D") do
          on("A") { "handled A" }
          on("B") { "handled B" }
        end
      end.to raise_error(ExclusiveCase::UnhandledCaseError, 'No case handled value: "D"')
    end

    it "returns the result of the matched block" do
      result = exhaustive_case(42) do
        on(42) { "the answer" }
        on(0) { "zero" }
      end

      expect(result).to eq("the answer")
    end

    it "handles different data types" do
      result = exhaustive_case(:symbol) do
        on(:symbol) { "it's a symbol" }
        on("string") { "it's a string" }
      end

      expect(result).to eq("it's a symbol")
    end
  end
end
