class HangMan 
  def initialize
    pick_random_word
    refactor_code(@expand_code)
    initialize_board
    puts @expand_code
    play_hangman
  end
  
  def intro
    puts "Welcome to the game Hangman!"
    puts "The computer has randomly selected a 5 to 12 letter word."
    puts "Your goal is to guess what the word is with only 6 mistakes."
    puts "A single turn is comprised of you guessing a single letter."
    puts "You can also attempt to guess the entire word instead of a letter"
    puts "Any wrong attempt results in a single mistake!"
    puts "============================================================================================"
  end
  
  def pick_random_word
    dictionary = "5desk.txt"
    file = File.open(dictionary, "r")
    word = file.read
    word_list = word.split(" ")

    random_number = rand(word_list.length)
    @code = word_list[random_number].downcase

    @expand_code = ""
    @code.each_char do |char|
      @expand_code += "#{char} "
    end
    @code_array = @expand_code.split("")

  end

  def refactor_code(code)
    @blank_code = ""
    code.each_char do |char|
      if !(char == " ")
        @blank_code += "_"
      else
        @blank_code += " "
      end
    end
  end

  def initialize_board
    @letter_bank = "a b c d e f g h i j k l m n o p q r s t u v w x y z"
    @number_of_guesses = 6
    puts @blank_code
    puts "============================================================================================"
    puts "Current letter bank:"
    puts @letter_bank
    puts "You have #{@number_of_guesses} guesses left."
  end

  def player_turn
    puts "Please enter your guess for the word or guess a letter from the letter bank."

    player_guess = gets.chomp.downcase

    if is_valid(player_guess)
      return player_guess
    else
      player_turn
    end
  end
  
  def is_valid(player_guess)
    if (player_guess.length == 1 && (@letter_bank.include? player_guess))
      return true
    elsif (player_guess.length == @code.length)
        return true
    elsif !(player_guess.length == 1) || (!(player_guess.length == @code.length) && player_guess.length > 1)
        puts "Not a valid guess. Please choose a letter."
    else
        puts "That has already been guessed. Please choose another letter."
    end
  end
  
  def check_code(player_guess)
    count = 0
    if player_guess == @code
        @blank_code = @expand_code
        return
    end
    @code_array.each_with_index do |char, index|
        if (char == player_guess)
            @blank_code[index] = char
            count += 1
            @letter_bank.sub!(char, "")
        end
    end
    if count == 0
        @number_of_guesses -= 1
        @letter_bank.sub!(player_guess, "")
    end
  end

  def update_board
    puts @blank_code
    puts "Current letter bank:"
    puts @letter_bank
    puts "You have #{@number_of_guesses} guesses left."
  end

  def win_condition
    if (@expand_code == @blank_code)
      puts "You guessed the word! You win!"
      return true
    end
  end

  def play_hangman
    gameOver = false
    while @number_of_guesses != 0 || !gameOver
      guess = player_turn
      check_code(guess)
      if win_condition
        break
      end
      update_board
      if @number_of_guesses == 0
        puts "======================================================"
        puts "Game over. You lose!"
        puts "The word was:"
        puts "#{@expand_code.gsub!(" ", "")}"
      end
    end

  end
end

HangMan::new