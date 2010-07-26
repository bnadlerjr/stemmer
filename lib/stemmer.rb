require 'lib/stemmer/porter'

module Stemmer
  VERSION = '1.0.1'

  def stem(algorithm=:porter, downcase=false)
    Porter.new.stem(self)
  end
end

class String
  include Stemmer
end
