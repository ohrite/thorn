module Thorn
  class Tokenizer < $ThornTokenizer ||= Struct.new(:input)
    def to_a
      input.gsub('(', ' ( ')
           .gsub(')', ' ) ')
           .split(/\s+/)
           .reject(&:empty?)
    end
  end
end
