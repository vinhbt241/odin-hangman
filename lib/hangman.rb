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

def copy_to_tmp_file(name, word, display_guess, wrong_guesses, chars_guessed)
  out_file = File.open("tmp_saved_files.txt", "a")
  
  in_files = File.open("saved_files.txt", "r")
  until in_files.eof?
    line = in_files.readline
    print line
    hash = JSON.load(line)
    if name == hash["name"]
      hash = JSON.dump({
        name: name,
        word: word,
        display_guess: display_guess,
        wrong_guesses: wrong_guesses,
        chars_guessed: chars_guessed
      })
    else
      hash = JSON.dump({
        name: hash["name"],
        word: hash["word"],
        display_guess: hash["display_guess"],
        wrong_guesses: hash["wrong_guesses"],
        chars_guessed: hash["chars_guessed"]
      })
    end

    out_file.puts hash
  end
  out_file.close()
end

def modify_files(name)
  File.truncate('saved_files.txt', 0)
  saved_files = File.open("saved_files.txt", "a")
  File.open("tmp_saved_files.txt", "r").readlines.each do |line|
    saved_files.puts line
  end
  saved_files.close()
  File.truncate('tmp_saved_files.txt', 0)

  puts "Save file with label [#{name}] was modified"
end

def display_saved_files()
  system 'clear'
  
  puts "SAVE FILES".center(50)

  saved_files = File.open("saved_files.txt", "r").readlines.each_with_index do |file, index|
    hash = JSON.load(file)
    puts "#{index + 1}. #{hash["name"]}"
  end
end

# Run game
print "Press N if you want to start a new game, or L to load a saved game: "
input = gets.chomp
until input == "N" || input == "L"
  print "Invalid input, please try again: "
  input = gets.chomp
end

if input == "N"
  dictionary = File.open("google-10000-english-no-swears.txt", "r")

  word = select_random_word(dictionary)

  display_guess = Array.new(word.length, "_")

  wrong_guesses = 0

  chars_guessed = []
else 
  display_saved_files()

  print ("type name of save files you want to load: ")
  name = gets.chomp
  until file_name_exist?(name)
    print ("File name don't exist, try again: ")
    name = gets.chomp
  end
  
  saved_files = File.open("saved_files.txt", "r")
  hash = JSON.load(saved_files.readline())
  until hash["name"] == name
    file = saved_files.readline()
    hash = JSON.load(file)
  end

  word = hash["word"]

  display_guess = hash["display_guess"]

  wrong_guesses = hash["wrong_guesses"]

  chars_guessed = hash["chars_guessed"]
end

while still_have_guesses?(display_guess, wrong_guesses)
  system 'clear'
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
    display_saved_files()

    print "Name your save file, if you want to modify saved file, type name of saved file: "
    name = gets.chomp

    if file_name_exist?(name)
      copy_to_tmp_file(name, word, display_guess, wrong_guesses, chars_guessed)
      modify_files(name)
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






