module Thorn
  class Parser < $ThornParser ||= Struct.new(:tokens)
    class ExpressionStart < Struct.new(:expression)
      def handle(token)
        new_expression = Expression.at_level(expression.level + 1, expression)
        expression.statements << new_expression
        new_expression
      end
    end

    class ExpressionEnd < Struct.new(:expression)
      def handle(token)
        expression.parent
      end
    end

    class Statement < Struct.new(:expression)
      def handle(token)
        expression.statements << Atom.new(token)
        expression
      end
    end

    class Atom < Struct.new(:token)
      def evaluate(context = {})
        return Integer(token) rescue ArgumentError
        return Float(token) rescue ArgumentError
        return {'true' => true, 'false' => false}.fetch(token) rescue KeyError
        context.fetch(token, token)
      end

      def to_ast
        evaluate
      end

      def statements
        []
      end
    end

    class Expression < Struct.new(:level, :statements, :parent)
      def self.root
        at_level(0)
      end

      def self.at_level(level, parent = nil)
        new(level, [], parent)
      end

      def process(token)
        {
          '(' => ExpressionStart,
          ')' => ExpressionEnd,
        }.fetch(token, Statement).new(self).handle(token)
      end

      def to_ast
        statements.map(&:to_ast)
      end
    end

    def statements
      tokens.reduce(Expression.root) { |e, token| e.process(token) }.statements
    end

    def to_ast
      statements.map(&:to_ast)
    end
  end
end
