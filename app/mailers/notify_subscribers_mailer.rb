class NotifySubscribersMailer < ApplicationMailer
  def notify(user, answer)
    @greeting = "Hello #{user.email}"
    @answer = answer
    @question = @answer.question

    mail to: user.email, subject: "A new answer was added to the question #{@question.title}"
  end
end
