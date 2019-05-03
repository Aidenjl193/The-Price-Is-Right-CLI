class Game < ActiveRecord::Base
  belongs_to :user
  has_many :answers

  def answers
    Answer.select{|answer| answer.game_id == id}
  end

  def get_question

  end
end
    
