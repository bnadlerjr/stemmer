class Porter

  STEP_2_LIST = {
    'ational'=>'ate', 'tional'=>'tion', 'enci'=>'ence', 'anci'=>'ance',
    'izer'=>'ize', 'bli'=>'ble',
    'alli'=>'al', 'entli'=>'ent', 'eli'=>'e', 'ousli'=>'ous',
    'ization'=>'ize', 'ation'=>'ate',
    'ator'=>'ate', 'alism'=>'al', 'iveness'=>'ive', 'fulness'=>'ful',
    'ousness'=>'ous', 'aliti'=>'al',
    'iviti'=>'ive', 'biliti'=>'ble', 'logi'=>'log'
  }
  
  STEP_3_LIST = {
    'icate'=>'ic', 'ative'=>'', 'alize'=>'al', 'iciti'=>'ic',
    'ical'=>'ic', 'ful'=>'', 'ness'=>''
  }

  SUFFIX_1_REGEXP = /(
                    ational  |
                    tional   |
                    enci     |
                    anci     |
                    izer     |
                    bli      |
                    alli     |
                    entli    |
                    eli      |
                    ousli    |
                    ization  |
                    ation    |
                    ator     |
                    alism    |
                    iveness  |
                    fulness  |
                    ousness  |
                    aliti    |
                    iviti    |
                    biliti   |
                    logi)$/x

  SUFFIX_2_REGEXP = /(
                      al       |
                      ance     |
                      ence     |
                      er       |
                      ic       | 
                      able     |
                      ible     |
                      ant      |
                      ement    |
                      ment     |
                      ent      |
                      ou       |
                      ism      |
                      ate      |
                      iti      |
                      ous      |
                      ive      |
                      ize)$/x

  C = "[^aeiou]"         # consonant
  V = "[aeiouy]"         # vowel
  CC = "#{C}(?>[^aeiouy]*)"  # consonant sequence
  VV = "#{V}(?>[aeiou]*)"    # vowel sequence

  MGR0 = /^(#{CC})?#{VV}#{CC}/o                # [cc]vvcc... is m>0
  MEQ1 = /^(#{CC})?#{VV}#{CC}(#{VV})?$/o       # [cc]vvcc[vv] is m=1
  MGR1 = /^(#{CC})?#{VV}#{CC}#{VV}#{CC}/o      # [cc]vvccvvcc... is m>1
  VOWEL_IN_STEM   = /^(#{CC})?#{V}/o                      # vowel in stem

  # Porter stemmer in Ruby.
  #
  # This is the Porter stemming algorithm, ported to Ruby from the
  # version coded up in Perl.  It's easy to follow against the rules
  # in the original paper in:
  #
  #   Porter, 1980, An algorithm for suffix stripping, Program, Vol. 14,
  #   no. 3, pp 130-137,
  #
  # Original version by Ray Pereda.
  #
  # See also http://www.tartarus.org/~martin/PorterStemmer
  def self.stem(word)

    # make a copy of the given object and convert it to a string.
    w = word.dup.to_str
    
    return w if w.length < 3
    
    # now map initial y to Y so that the patterns never treat it as vowel
    w[0] = 'Y' if w[0] == ?y
    
    w = step_one(w)
    w = step_two(w)
    w = step_three(w)
    w = step_four(w)
    w = step_five(w)

    # and turn initial Y back to y
    w[0] = 'y' if w[0] == ?Y

    w
  end

  private

  def self.step_one(target)
    # Step 1a
    if target =~ /(ss|i)es$/
      target = $` + $1
    elsif target =~ /([^s])s$/ 
      target = $` + $1
    end

    # Step 1b
    if target =~ /eed$/
      target.chop! if $` =~ MGR0 
    elsif target =~ /(ed|ing)$/
      stem = $`
      if stem =~ VOWEL_IN_STEM 
        target = stem
	      case target
          when /(at|bl|iz)$/             then target << "e"
          when /([^aeiouylsz])\1$/       then target.chop!
          when /^#{CC}#{V}[^aeiouwxy]$/o then target << "e"
        end
      end
    end

    # Step 1c
    if target =~ /y$/ 
      stem = $`
      target = stem + "i" if stem =~ VOWEL_IN_STEM 
    end

    target
  end

  def self.step_two(target)
    if target =~ SUFFIX_1_REGEXP
      stem = $`
      suffix = $1
      if stem =~ MGR0
        target = stem + STEP_2_LIST[suffix]
      end
    end

    target
  end

  def self.step_three(target)
    if target =~ /(icate|ative|alize|iciti|ical|ful|ness)$/
      stem = $`
      suffix = $1
      if stem =~ MGR0
        target = stem + STEP_3_LIST[suffix]
      end
    end

    target
  end

  def self.step_four(target)
    if target =~ SUFFIX_2_REGEXP
      stem = $`
      if stem =~ MGR1
        target = stem
      end
    elsif target =~ /(s|t)(ion)$/
      stem = $` + $1
      if stem =~ MGR1
        target = stem
      end
    end

    target
  end

  def self.step_five(target)
    if target =~ /e$/ 
      stem = $`
      if (stem =~ MGR1) ||
          (stem =~ MEQ1 && stem !~ /^#{CC}#{V}[^aeiouwxy]$/o)
        target = stem
      end
    end

    if target =~ /ll$/ && target =~ MGR1
      target.chop!
    end

    target
  end
end
