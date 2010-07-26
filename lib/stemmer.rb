require 'lib/stemmer/porter'

class String
  include Stemmable
end

module Stemmer
  VERSION = '1.0.1'
end
