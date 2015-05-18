require "spec_helper"

RSpec.describe Thorn::Repl do
  subject(:repl) { Thorn::Repl.new("prompt> ") }

  describe "#read" do
    it "prompts for input" do
      expect(repl).to receive(:print).with("prompt> ")
      expect(STDIN).to receive(:gets).and_return("beans\n")
      expect(repl.read).to eq("beans")
    end
  end

  describe "#evaluate_and_print" do
    it "retains state and prints output" do
      expect(repl).to receive(:puts).with("loco")
      repl.evaluate_and_print("(define taco loco)")
      expect(repl).to receive(:puts).with("loco")
      repl.evaluate_and_print("taco")
    end
  end
end
