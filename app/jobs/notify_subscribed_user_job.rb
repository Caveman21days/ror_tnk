class NotifySubscribedUserJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    subscribes = answer.question.subscribes

    if !subscribes.blank?
      subscribes.find_each do |subscribe|
        NotifySubscribersMailer.notify(subscribe.user, answer).deliver_later
      end
    end
  end
end
