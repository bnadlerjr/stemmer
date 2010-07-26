require "test/unit"
require "stemmer"

class TestStemmer < Test::Unit::TestCase
  def setup
    @dictionary = {}
    data_dir = File.join(File.dirname(__FILE__), 'data')
    words = File.open(File.join(data_dir, 'words.txt')).readlines
    stems = File.open(File.join(data_dir, 'stems.txt')).readlines
    words.each_with_index do |word, index|
      @dictionary[word.chomp] = stems[index].chomp
    end
  end

  def test_word_dictionary
    @dictionary.each do |k,v|
      assert_equal v, k.stem
    end
  end
end
