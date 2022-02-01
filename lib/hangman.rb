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

dictionary = File.open("google-10000-english-no-swears.txt", "r") 

puts draw_hangman(7)
