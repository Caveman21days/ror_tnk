class DailyMailer < ApplicationMailer
  def digest(user, questions)
    @greeting = "Hi #{user.email}"
    @questions = questions

    mail to: user.email, subject: "Daily digest for new questions of last day!"
  end
end
