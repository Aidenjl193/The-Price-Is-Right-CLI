class Game < ActiveRecord::Base
  belongs_to :user
  has_many :questions

  def questions
    Question.select{|question| question.game_id == id}
  end

  def get_question

  end
end
    
