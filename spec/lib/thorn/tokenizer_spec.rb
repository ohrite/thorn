require "spec_helper"

RSpec.describe Thorn::Tokenizer do
  let(:input) { "(ham 1)" }

  subject(:tokenizer) { Thorn::Tokenizer.new(input) }

  describe "#to_a" do
    it "turns an expression into a list of tokens" do
      expect(tokenizer.to_a).to eq(%w[( ham 1 )])
    end
  end
end
