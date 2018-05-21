class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment
  # before_action :set_attachable

  authorize_resource
  respond_to :js


  def destroy
    respond_with(@attachment.destroy)
  end



  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
