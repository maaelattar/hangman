require './player'

class Game
  def initialize(player, choice)
    @player = player
    @choice = choice
    play
  end

  def play
    decide_mode
    until game_end?
      next if print_instructions == -1
      compare
      board_data
      puts "\nCongratulations you got all expectations right\n" if announce_winner
      @player.current_turn += 1
    end
  end

  def print_board
    puts "\nWord:\t #{@player.guessed_word.upcase}\n"
    puts "\nGuess:\t #{@letter}\n"
    puts "\nMisses:\t #{@player.misses.join(', ')}\n"
  end

  def print_instructions
    puts "\n\nCurrent turn: #{@player.current_turn} of 12\n\n"
    puts "\nSubmit 1 if you want to save the game\n"
    puts "\nGuess a letter betweeen a and z\n"
    print_board
    @letter = guess_letter
    if @letter == '1'
      save
      @letter = ''
      return -1
    end
  end

  def decide_mode
    if @choice == 1
      puts "\n\tYou started a new game"
      dictionary = File.read('5desk.txt')
      @player.random_word = dictionary.scan(/\w+/).select do |word|
        word.length.between?(5, 12)
      end.sample
      @player.guessed_word = ''.rjust(@player.random_word.length, '-')
    elsif @choice == 2
      load
    end
  end

  def board_data
    @player.misses.push(@letter) unless
      @player.random_word.downcase.include?(@letter.downcase) || @letter == '1'
      print_board
  end

  def save
    Dir.mkdir 'save' unless Dir.exist?('save')
    puts 'Enter the game save name that you want to save to'
    file_name = "save/#{gets.chomp}"
    File.open(file_name, 'w') { |file| file.write(Marshal.dump(@player)) }
    puts 'Game has been saved'
  end

  def load
    unless Dir.exist?('save')
     puts 'There is no game saves right now'
     exit
    end
    game_saves = Dir.entries('save').reject { |f| File.directory?(f) }.join("\n")
    puts 'Enter the game save name that you want to load from',
         "\nHere are all game saves\n"
    puts game_saves
    file_name = "save/#{gets.chomp}"
    puts 'Game save does not exist' unless File.exist?(file_name)
    exit unless File.exist?(file_name)
    @player = Marshal.load(File.binread(file_name))
  end

  def compare
    @player.random_word.each_char.with_index do |char, index|
      @player.guessed_word[index] = @letter if char.casecmp?(@letter)
    end
  end

  def failed?
    @player.current_turn == 13
  end

  def announce_winner
    @player.guessed_word.casecmp?(@player.random_word)
  end

  def game_end?
    announce_winner || failed?
  end

  def guess_letter
    input = gets.chomp
    until valid_input?(input)
      puts "\nInput is not valid!, it must be between a and z\n"
      input = gets.chomp
    end
    input
  end

  def valid_input?(input)
    input.downcase.between?('a', 'z') || input == '1'
  end
end
