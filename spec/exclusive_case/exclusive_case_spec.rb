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

    context "with 'of' parameter" do
      it "validates that all cases belong to the 'of' list" do
        result = exhaustive_case("A", of: %w[A B C]) do
          on("A") { "handled A" }
          on("B") { "handled B" }
          on("C") { "handled C" }
        end

        expect(result).to eq("handled A")
      end

      it "raises InvalidCaseError when a case is not in the 'of' list" do
        expect do
          exhaustive_case("A", of: %w[A B C]) do
            on("A") { "handled A" }
            on("D") { "handled D" } # D is not in the 'of' list
          end
        end.to raise_error(ExclusiveCase::InvalidCaseError, /Invalid case\(s\): "D"/)
      end

      it "raises MissingCaseError when not all 'of' values are handled" do
        expect do
          exhaustive_case("A", of: %w[A B C]) do
            on("A") { "handled A" }
            on("B") { "handled B" }
            # Missing case for "C"
          end
        end.to raise_error(ExclusiveCase::MissingCaseError, /Missing case\(s\): "C"/)
      end

      it "allows multiple values in a single 'on' clause when using 'of'" do
        result = exhaustive_case("B", of: %w[A B C]) do
          on("A") { "handled A" }
          on("B", "C") { "handled B or C" }
        end

        expect(result).to eq("handled B or C")
      end

      it "works with different data types in 'of' list" do
        result = exhaustive_case(:success, of: %i[success failure pending]) do
          on(:success) { "Operation succeeded" }
          on(:failure) { "Operation failed" }
          on(:pending) { "Operation pending" }
        end

        expect(result).to eq("Operation succeeded")
      end

      it "raises error for multiple invalid cases" do
        expect do
          exhaustive_case("A", of: %w[A B C]) do
            on("A") { "handled A" }
            on("D", "E") { "handled D or E" } # Both D and E are not in the 'of' list
          end
        end.to raise_error(ExclusiveCase::InvalidCaseError, /Invalid case\(s\): "D", "E"/)
      end
    end
  end
end
