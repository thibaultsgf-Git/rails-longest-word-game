require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @word = params[:word].to_s.upcase
    @letters = params[:letters].to_s.split

    unless buildable?(@word, @letters)
      @message = "Sorry but #{@word} can't be built out of #{@letters.join(', ')}"
      return
    end

    result = dictionary_lookup(@word)

    unless result["found"]
      @message = "Sorry but #{@word} does not seem to be a valid English word"
      return
    end

    @score = @word.length
    @message = "Congratulations! #{@word} is a valid English word! Your score is #{@score}."
  end

  private

  def buildable?(word, letters)
    letters_copy = letters.dup

    word.chars.all? do |char|
      idx = letters_copy.index(char)
      idx ? letters_copy.delete_at(idx) : false
    end
  end

  def dictionary_lookup(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    JSON.parse(response)
  end
end
