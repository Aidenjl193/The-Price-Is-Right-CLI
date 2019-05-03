class User < ActiveRecord::Base
  has_many :games

  def self.get_user_by_name(name)
    all.find{|user| user.name == name}
  end

  def new_game
    Game.new(user_id: id)
  end

  def games
    Game.all.select{|game| game.user_id == id}
  end

  def accuracy
    (games.map{|game| game.score / game.answers.length}.sum / games.length) * 100
  end

  def best_game
     games.max_by{|game| game.score}
  end
  
  def high_score
    best_game.score
  end
end
    
