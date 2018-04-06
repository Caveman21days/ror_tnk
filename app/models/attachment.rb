# frozen_string_literal: true
class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true

  mount_uploader :file, FileUploader


  def question
    if self.attachable.class.name == 'Question'
      self.attachable
    elsif self.attachable.class.name == 'Answer'
      self.attachable.question
    end
  end

end
