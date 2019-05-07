require 'tty-prompt'
require 'artii'

def header
  a = Artii::Base.new :font => 'slant'
  puts a.asciify('The Price Is Right')
end

def welcome
  puts "Welcome To The Price Is Right!!"
  puts "The aim of the game is to successfully guess the price of items....or to get as close as you can"
  puts "What is your name?"
  name = gets.chomp
  puts "Hello #{name.upcase} selet an option from the menu"
  name
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
  category = %w(Technology Home Baby Toys Womens Mens Watches Games)
  prompt.select('Choose your category?', category, filter: true)
end



def instructions
  puts "------------------------------------------------------"
  puts "|| 1. You will select a category for your items.     ||"
  puts "------------------------------------------------------"
  puts "|| 2. You will try and guess the price of your items.||"
  puts "------------------------------------------------------"
  puts "|| 3. You will end up either a winner or loser.      ||"
  puts "------------------------------------------------------"

  menu = TTY::Prompt.new
  selection = menu.select("") do |a|
    a.choice 'Play'
    a.choice 'Exit game'
  end
  
  case selection
  when 'Play'
    category
  when 'Exit game'
    welcome
  end
end

def question_header
  a = Artii::Base.new :font => 'slant'
  puts a.asciify('QUESTIONS')
end

def get_user(name)
  user = User.get_user_by_name(name)
  if !user
    user.create(name)
  end
end

def diff(a,b)
  (a - b).abs
end

def run
  puts "enter name"
  name = gets.chomp
  user = get_user(name)
  Game.create(user_id: user.id)
  Game.initialize_game(category)

  question = user.get_question
  while quesiton 
    puts "Guess the price of #{question.name}"
    input = gets.chomp
    question.answer = input
    question.save
    if diff(input, question.price) < 50 
      puts "Correct"
      game.score += 1
      game.save
    else 
      puts "Incorrect"
    end
    question = user.get_question
  end
end
