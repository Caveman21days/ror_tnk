class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams #Это ведь нужная штука, чтобы не транслировать все стримы?
    stream_from "answers_#{data['question_id']}"
  end
end