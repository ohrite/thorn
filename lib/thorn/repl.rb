require "thorn/tokenizer"
require "thorn/parser"
require "thorn/evaluator"

module Thorn
  class Repl < $ThornRepl ||= Struct.new(:prompt)
    def loop
      while (input = self.read) != "exit"
        evaluate_and_print(input)
      end
    end

    def read
      print prompt
      STDIN.gets.chomp
    end

    def evaluate_and_print(input)
      tokens = Thorn::Tokenizer.new(input).to_a
      statements = Thorn::Parser.new(tokens).statements
      evaluators = statements.map { |s| Thorn::Evaluator.new(s) }
      evaluators.each { |e| puts e.evaluate(context) }
    end

    def context
      @context ||= {}
    end
  end
end
