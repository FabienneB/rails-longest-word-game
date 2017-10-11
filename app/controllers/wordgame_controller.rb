class WordgameController < ApplicationController
  def game
    @grid_size = 9;
    @my_grid = Array.new(@grid_size) { ('A'..'Z').to_a[rand(26)] }
    @start_time = Time.now
  end

  def exist?(word)
    url = "https://wagon-dictionary.herokuapp.com/" + word
    response = open(url).read
    result = JSON.parse(response)
    return result["found"]
  end

  def word_in_grid?(word, grid)
    new_word = word.upcase.split("")
    if new_word.size <= grid.size
      grid.each do |letter|
        if new_word.include?(letter)
          i = new_word.index(letter)
          new_word.delete_at(i)
        end
      end
    end
    return new_word.empty?
  end

  def score
    @end_time = Time.now
    @start_time = Time.parse(params[:start_time])
    @time = @end_time - @start_time
    @word = params[:query]
    @my_grid = params[:my_grid].split("")
    @message = ""
    if exist?(@word) && word_in_grid?(@word, @my_grid)
      @score = ((1 + @word.length.fdiv(@my_grid.length)) * @word.length).fdiv(@time.to_f) * 100
      @message = "Bien ouej !"
    elsif !exist?(@word)
      @score = 0
      @message = "Your word doesn't exist !"
    elsif !word_in_grid?(@word, @my_grid)
      @score = 0
      @message = "Your word is not in the grid !"
    end
  end
end

