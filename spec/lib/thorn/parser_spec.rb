require "spec_helper"

RSpec.describe Thorn::Parser do
  let(:input) { "(begin (define r 10) (* pi (* r r)))" }
  let(:tokens) { Thorn::Tokenizer.new(input).to_a }

  subject(:parser) { Thorn::Parser.new(tokens) }

  describe "#to_ast" do
    it "turns tokenized input into a nested structure" do
      expect(parser.to_ast).to eq([
        ["begin", ["define", "r", 10], ["*", "pi", ["*", "r", "r"]]]
      ])
    end
  end
end
