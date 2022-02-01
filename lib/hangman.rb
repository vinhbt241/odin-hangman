def select_random_word(dictionary)
  line_count = File.foreach(dictionary).count

  word = ""
  until word.length >= 5 && word.length <= 12
    dictionary.rewind()
    pos_read = rand 1...line_count
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
  until char.length == 1 && char.match?(/[a-z]/)
    print message
    message = "Invalid input, please try again: "
    char = gets.chomp.downcase
  end

  char
end

def guess_word(word, display_arr)
  word_to_guess = word.split("")

  char = get_char()

  index_of_chars = []

  word_to_guess.each_with_index do |c, index|
    index_of_chars.push(index) if c == char
  end

  index_of_chars.each do |index|
    display_arr[index] = char
  end

  display_arr
end

# Run game
dictionary = File.open("google-10000-english-no-swears.txt", "r")

word = select_random_word(dictionary)

display_guess = Array.new(word.length, "_")

while display_guess.any?("_")
  puts display_guess.join(" ")
  display_guess = guess_word(word, display_guess)
end

puts "Word completed: #{display_guess.join("")}"





