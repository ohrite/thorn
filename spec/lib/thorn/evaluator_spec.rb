require "spec_helper"

RSpec.describe Thorn::Evaluator do
  let(:tokens) { Thorn::Tokenizer.new(input).to_a }
  let(:statements) { Thorn::Parser.new(tokens).statements }
  let(:context) { {} }

  subject(:evaluator) { Thorn::Evaluator.new(statements.first) }

  describe "#evaluate" do
    context "with a value" do
      let(:input) { "3.1415" }

      it "returns the value" do
        expect(evaluator.evaluate(context)).to eq(3.1415)
      end
    end

    context "with a define statement" do
      let(:input) { "(define pi 3.1415)" }

      it "sets the value in the context" do
        expect {
          evaluator.evaluate(context)
        }.to change { context["pi"] }.to(3.1415)
      end

      it "returns the defined value" do
        expect(evaluator.evaluate(context)).to eq(3.1415)
      end
    end

    context "with a define statement followed by a retrieval" do
      let(:input) { "(define pi 3.1415) (pi)" }

      it "sets the value in the context" do
        expect {
          evaluator.evaluate(context)
        }.to change { context["pi"] }.to(3.1415)
      end

      it "returns the defined value" do
        expect(evaluator.evaluate(context)).to eq(3.1415)
      end
    end

    context "with a quote command" do
      let(:input) { "(quote (define pi 3.1415))" }

      it "returns the value" do
        expect(evaluator.evaluate(context).to_ast).to eq(["define", "pi", 3.1415])
      end
    end

    context "with a truthy conditional" do
      let(:input) { "(if 1 taco loco)" }

      it "returns the value" do
        expect(evaluator.evaluate(context)).to eq("taco")
      end
    end

    context "with a falsy conditional" do
      let(:input) { "(if false taco loco)" }

      it "returns the other value" do
        expect(evaluator.evaluate(context)).to eq("loco")
      end
    end

    context "with a procedure call" do
      let(:input) { "(meow times)" }

      it "returns the result of the function" do
        context["times"] = 3
        context["meow"] = ->(times) { "#{times}x meow" }
        expect(evaluator.evaluate(context)).to eq("3x meow")
      end
    end
  end
end
