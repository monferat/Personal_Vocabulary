module Checker

  def checker
    @correct_words = {}
    File.open('./lib/assets/words.txt') do |file|
      file.each do |line|
        @correct_words[line.strip] = true
      end
    end
    @correct_words
  end

end
