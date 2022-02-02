require "json"

def select_random_word(dictionary)
  line_count = File.foreach(dictionary).count

  word = ""
  until word.length >= 5 && word.length <= 12
    dictionary.rewind()
    pos_read = rand 1..line_count
    pos_read.times { word =  dictionary.readline().strip() }
  end

  word
end

def draw_hangman(guess_count)
  case guess_count
  when 0  
    body = %{
      ┏━━┓
      ╿  ┃
         ┃
         ┃
         ┃
         ┃
         ┃
     ━━━━┛
    }
  when 1
    body = %{
      ┏━━┓
      ╿  ┃
      ○  ┃
         ┃
         ┃
         ┃
         ┃
     ━━━━┛
    }
  when 2
    body = %{
      ┏━━┓
      ╿  ┃
      ○  ┃
     ╱   ┃
         ┃
         ┃
         ┃
     ━━━━┛
    }
  when 3
    body = %{
      ┏━━┓
      ╿  ┃
      ○  ┃
     ╱│  ┃
         ┃
         ┃
         ┃
     ━━━━┛
    }
  when 4
    body = %{
      ┏━━┓
      ╿  ┃
      ○  ┃
     ╱│╲ ┃
         ┃
         ┃
         ┃
     ━━━━┛
    }
  when 5
    body = %{
      ┏━━┓
      ╿  ┃
      ○  ┃
     ╱│╲ ┃
      │  ┃
         ┃
         ┃
     ━━━━┛
    }
  when 6
    body = %{
      ┏━━┓
      ╿  ┃
      ○  ┃
     ╱│╲ ┃
      │  ┃
     ╱   ┃
         ┃
     ━━━━┛
    }
  when 7
    body = %{
      ┏━━┓
      ╿  ┃
      ○  ┃
     ╱│╲ ┃
      │  ┃
     ╱ ╲ ┃
         ┃
     ━━━━┛
    }
  else
    "Invalid guess count. Guess count must in range 0-7"
  end
end

def get_char()
  message = "Type in character you want to guess: "
  char = ""
  until char.length == 1 && char.match?(/[a-z]/) || char == "save"
    print message
    message = "Invalid input, please try again: "
    char = gets.chomp.downcase
  end

  char
end

def guess_word(word, display_guess, char)
  display_arr = display_guess.dup()

  word_to_guess = word.split("")

  index_of_chars = []

  word_to_guess.each_with_index do |c, index|
    index_of_chars.push(index) if c == char
  end

  index_of_chars.each do |index|
    display_arr[index] = char
  end

  return display_arr
end

def still_have_guesses?(display_guess, wrong_guesses)
  display_guess.any?("_") && wrong_guesses < 7
end

def center_multiline_string(string)
  centered_string = string.lines.map do |line|
    line.gsub!("\n", "") 
    line.center(44) 
  end
  centered_string.join("\n")
end

def save_file(name, word, display_guess, wrong_guesses, chars_guessed)
  saved_files = File.open("saved_files.txt", "a")

  file = JSON.dump({
    name: name,
    word: word,
    display_guess: display_guess,
    wrong_guesses: wrong_guesses,
    chars_guessed: chars_guessed
  })
  
  saved_files.puts file
  saved_files.close()
end

def file_name_exist?(name)
  saved_files = File.open("saved_files.txt", "r")
  
  until saved_files.eof?
    line = saved_files.readline
    hash = JSON.load(line)
    if name == hash["name"]
      return true
    end
  end

  return false
end

# Run game
dictionary = File.open("google-10000-english-no-swears.txt", "r")

word = select_random_word(dictionary)

display_guess = Array.new(word.length, "_")

wrong_guesses = 0

chars_guessed = []

while still_have_guesses?(display_guess, wrong_guesses)
  # system 'clear'
  puts "HANGMAN".center(50)
  puts center_multiline_string(draw_hangman(wrong_guesses))
  puts display_guess.join(" ").center(50)
  puts "\n"
  puts "Characters guessed: #{chars_guessed.join(" ")}"

  char = get_char()

  while chars_guessed.any?(char)
    puts "Character was already guessed, please try another character"
    char = get_char()
  end

  if char == "save"
    print "Name your save file: "
    name = gets.chomp

    if file_name_exist?(name)
      #modify saved files
      puts "Save files #{name} was modified"
    else
      save_file(name, word, display_guess, wrong_guesses, chars_guessed)
    end
  else
    chars_guessed.push(char)

    player_guess = guess_word(word, display_guess,char)

    wrong_guesses += 1 if player_guess == display_guess
    display_guess = player_guess
  end

end

system 'clear'
puts "HANGMAN".center(50)
puts center_multiline_string(draw_hangman(wrong_guesses))
puts display_guess.join(" ").center(50)
puts "\n"
puts "Characters guessed: #{chars_guessed.join(" ")}"

puts "Correct word is: #{word}"
puts "Word completed: #{display_guess.join("")}"
if word == display_guess.join("")
  puts "CONGRATULATION, YOU WON!"
else
  puts "OOPS, YOU LOST, TRY AGAIN?"
end






