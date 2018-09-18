require './player.rb'
require './game.rb'

class Hangman
  def initialize
    game_start
    game_loop
  end

  def welcome_screen
    puts "\n\tWelcome to Hangman Game\t\n",
         "\nDo you want to: ",
         "\n1- Start a new game",
         '2- Load'
  end

  def choice
    choices = [1, 2]
    print "\n(1 / 2) ?\t"
    input = gets.chomp.to_i
    loop do
      break if choices.include?(input)
      puts 'Wrong input submit 1 or 2'
      input = gets.chomp.to_i
    end
    @choice = input
  end

  def game_start
    welcome_screen
    choice
    player = Player.new
    Game.new(player, @choice)
  end

  def play_again
    puts "\nGame over do you want to play again (Y/N)?"
    loop do
      input = gets.chomp.upcase
      return true if input == 'Y'
      return false if input == 'N'
      puts "\nInvalid input do you want to play again (Y/N)?"
    end
  end

  def game_loop
    game_start while play_again
  end
end

Hangman.new
