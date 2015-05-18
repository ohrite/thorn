module Thorn
  class Evaluator < $ThornEvaluator ||= Struct.new(:expression)
    class LiteralEvaluator < Struct.new(:expression)
      def evaluate(context)
        expression.evaluate(context)
      end
    end

    class DefineEvaluator < Struct.new(:expression)
      def evaluate(context)
        context[name.evaluate(context)] = value.evaluate(context)
      end

      def name
        Evaluator.new(expression.statements[1])
      end

      def value
        Evaluator.new(expression.statements[2])
      end
    end

    class QuoteEvaluator < Struct.new(:expression)
      def evaluate(context)
        expression.statements[1]
      end
    end

    class ConditionalEvaluator < Struct.new(:expression)
      def evaluate(context)
        result = predicate.evaluate(context) ? consequence : alternative
        result.evaluate(context)
      end

      def predicate
        Evaluator.new(expression.statements[1])
      end

      def consequence
        Evaluator.new(expression.statements[2])
      end

      def alternative
        Evaluator.new(expression.statements[3])
      end
    end

    class ImmediateEvaluator < Struct.new(:expression)
      def evaluate(context)
        procedure_reference = procedure.evaluate(context)
        argument_values = arguments.map { |a| a.evaluate(context) }
        procedure_reference.call(*argument_values)
      end

      def procedure
        Evaluator.new(expression.statements[0])
      end

      def arguments
        expression.statements[1..-1].map { |s| Evaluator.new(s) }
      end
    end

    def evaluate(context = {})
      keyword = statements[0].evaluate(context) if statements.any?
      evaluator = {
        'define' => DefineEvaluator,
        'quote' => QuoteEvaluator,
        'if' => ConditionalEvaluator,
        nil => LiteralEvaluator,
      }.fetch(keyword, ImmediateEvaluator)
      evaluator.new(expression).evaluate(context)
    end

    def statements
      expression.statements
    end
  end
end
