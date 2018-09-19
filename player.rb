class Player
  attr_accessor :random_word, :guessed_word, :misses, :current_turn

  def initialize
    @misses = []
    @current_turn = 1
  end
end
