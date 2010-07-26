require 'lib/stemmer/porter'

module Stemmer
  VERSION = '1.0.1'

  # Stems a word. Uses the Porter stemming algorithm by default.
  # algorithm:: The name of the algorithm to use as a symbol. Right now only 
  #             the <tt>:porter</tt> algorithm is supported.
  # downcase:: If true, the string will be downcased before being sent to the
  #            stemming algorithm. Default value is +false+.
  def stem(algorithm=:porter, downcase=false)
    downcase ? word = self.downcase : word = self
    Porter.stem(word)
  end
end

class String
  include Stemmer
end
