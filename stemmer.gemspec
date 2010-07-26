require 'lib/stemmer'

TITLE = 'Stemmer'
MAIN_RDOC = 'README.rdoc'

TEST_FILES       = Dir['test/**/test_*.rb']
EXTRA_RDOC_FILES = ['README.rdoc', 'HISTORY.txt']

Gem::Specification.new do |spec|
  spec.author                = 'Bob Nadler, Jr.'
  spec.description           = 'A Ruby implementation of the Porter ' +
                               'stemming algorithm.'
  spec.email                 = 'thethirdswitch [at] gmail'
  spec.extra_rdoc_files      = EXTRA_RDOC_FILES
  spec.files                 = `git ls-files`.split("\n") - ['.gitignore']
  spec.has_rdoc              = true
  spec.homepage              = 'http://bobnadler.com/stem'
  spec.name                  = 'stemmer'
  spec.required_ruby_version = '>=1.8.7'
  spec.test_files            = TEST_FILES
  spec.version               = '0.1.0' #Stemmer::VERSION
  spec.rubyforge_project     = 'stemmer' # required for validation

  spec.summary = <<-SUMMARY
This is a Ruby implementation of the Porter stemming algorithm. This version 
is based on the original written by Ray Pereda [1].

[1] http://tartarus.org/~martin/PorterStemmer/ruby.txt
SUMMARY

  spec.rdoc_options << '--title' << TITLE <<
                       '--main' << MAIN_RDOC

  spec.add_development_dependency('rake', '>=0.8.7')
  spec.add_development_dependency('relevance-rov', '>=0.9.2.1')
end
