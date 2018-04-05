# frozen_string_literal: true
class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true

  mount_uploader :file, FileUploader

  def get_question
    return self.attachable if self.attachable.class.name == 'Question'
  end

  def get_answer
    return self.attachable if self.attachable.class.name == 'Answer'
  end

end
