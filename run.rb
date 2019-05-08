require_relative './config/environment'
require 'sinatra/activerecord/rake'
require 'tty-prompt'
require 'artii'
require 'colorize'


def difficulties
  {
  "Hard" => 5,
  "Medium" => 10,
  "Easy" => 30
  }
end

def brk
    puts "
    "
end

def header
  a = Artii::Base.new :font => 'slant'
  puts a.asciify('The Price Is Right!!!')
  puts Rainbow("The aim of the game is to successfully guess the price of items....or to get as close as you can").underline.bright
  puts Rainbow("------------------------------------------------------").bright
  puts Rainbow("|| 1. You will select a category your difficulty     ||").bright
  puts Rainbow("|| Range - Easy: 5    Medium: 10     Hard: 30        ||").bright
  puts Rainbow("------------------------------------------------------").bright
  puts Rainbow("|| 2. You will select a category for your items.     ||").bright
  puts Rainbow("------------------------------------------------------").bright
  puts Rainbow("|| 3. You will try and guess the price of your items.||").bright
  puts Rainbow("------------------------------------------------------").bright
  puts Rainbow("|| 4. You will end up either a winner or loser.      ||").bright
 puts Rainbow("------------------------------------------------------").bright
 puts Rainbow("What is your name?").underline.bright
 name = gets.chomp
 name
end

def goodbye
  a = Artii::Base.new :font => 'slant'
  puts a.asciify('Goodbye')
end



def start_menu
  menu = TTY::Prompt.new
  selection = menu.select("") do |a|
    a.choice 'Play'
    a.choice 'Instructions'
    a.choice 'Exit game'
  end

  case selection
  when 'Play'
        category
  when 'Instructions'
    instructions
  when 'Exit game'
    a = Artii::Base.new :font => 'slant'  
    puts a.asciify('Goodbye!')
  end

end

def difficulty
  prompt = TTY::Prompt.new
  category = %w(Easy Medium Hard)
  prompt.select(Rainbow('Choose your difficulty?').underline.bright, category, filter: true)
end



def category
  prompt = TTY::Prompt.new
  category = %w(Electronics Home Baby Children Womens Mens Watches Games)
  prompt.select(Rainbow('Choose your category?').underline.bright, category, filter: true)
end

def loading
  spinner = TTY::Spinner.new("[:spinner] Loading Questions")
  100.times do
    spinner.spin
    sleep(0.1)
  end
  
  spinner.success('(successful)')
end

def question_header
  a = Artii::Base.new :font => 'slant'
  puts a.asciify('QUESTIONS')
end

def get_user(name)
  user = User.get_user_by_name(name)
  if !user
    user = User.create(name: name)
  else
    puts "Welcome back #{name}"
  end
  user
end

def diff(a,b)
  (a - b).abs
end


def run
  name = header
  user = get_user(name)
  brk
  game = Game.create(user_id: user.id, score: 0)
  brk
  diff_range = difficulties[difficulty]
  cat = category
  loading
  game.initialize_game(cat)
  brk
  question_header
  brk
  question = game.get_question
  while question 
    puts Rainbow("- Guess the price of #{question.item}").bright.underline
    input = gets.chomp
    question.guess = input
    question.save
    if diff(input.to_i, question.price) < diff_range
      puts  "Correct, the price was #{question.price.to_i}".colorize(:green)
      game.score += 1
      game.save
    else 
      puts "Incorrect, the price was #{question.price.to_i}".colorize(:red)
    end
    question = game.get_question
  end
  a = Artii::Base.new :font => 'slant'
  puts a.asciify("You scored #{game.score} out of 10")
  goodbye
end
<<<<<<< HEAD
<<<<<<< HEAD

=======
binding.pry
>>>>>>> f021d47dce8978c31d045b1d52d5ce6f5f163f21
=======
>>>>>>> de651d72f1b5183b6f0c6d3cff1b33aaa95db9f0
run
