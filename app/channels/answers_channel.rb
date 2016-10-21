class AnswersChannel < ApplicationCable::Channel
  def follow(data) 
    stream_from "answers_for_#{data['question_id']}"
  end
end