class Game < ActiveRecord::Base
  belongs_to :user
  has_many :questions

  def questions
    Question.all.select{|question| question.game_id == id}
  end

  def get_question
    questions.each do |question|
      if(!question.guess)
        return question
      end
    end
    return nil
  end

  def initialize_game(category)
    items = Scraper.category(category)
    for i in 0..9 do
      Question.create(game_id: self.id, item: items[i][:name], price: items[i][:price])
    end
  end
end


