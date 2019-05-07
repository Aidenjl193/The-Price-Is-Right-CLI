require_relative './config/environment'
require 'sinatra/activerecord/rake'
require 'tty-prompt'
require 'artii'

def header
  a = Artii::Base.new :font => 'slant'
  puts a.asciify('The Price Is Right')
  puts "The aim of the game is to successfully guess the price of items....or to get as close as you can"
  puts "------------------------------------------------------"
  puts "|| 1. You will select a category for your items.     ||"
  puts "------------------------------------------------------"
  puts "|| 2. You will try and guess the price of your items.||"
  puts "------------------------------------------------------"
  puts "|| 3. You will end up either a winner or loser.      ||"
 puts "------------------------------------------------------"
 puts "What is your name?"
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


def category
  prompt = TTY::Prompt.new
  category = %w(Electronics Home Baby Children Womens Mens Watches Games)
  prompt.select('Choose your category?', category, filter: true)
end


def question_header
  a = Artii::Base.new :font => 'slant'
  puts a.asciify('QUESTIONS')
end

def get_user(name)
  user = User.get_user_by_name(name)
  if !user
    user = User.create(name: name)
  end
  user
end

def diff(a,b)
  (a - b).abs
end

def write_question
  puts "-----------------------------------------------------"
  puts "- Guess the price of #{question.item}                "
end

def run
  name = header
  user = get_user(name)
  game = Game.create(user_id: user.id, score: 0)
  cat = category
  game.initialize_game(cat)
  question_header
  question = game.get_question
  while question 
    puts "- Guess the price of #{question.item}"
    input = gets.chomp
    question.guess = input
    question.save
    if diff(input.to_i, question.price) < 50 
      puts "Correct"
      game.score += 1
      game.save
    else 
      puts "Incorrect"
    end
    question = game.get_question
  end
  puts "You score #{game.score} out of 10"
  goodbye
end
run
