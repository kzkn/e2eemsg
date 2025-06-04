class TextMessagesController < ApplicationController
  include InRoomResource

  before_action :set_room

  def create
    form = TextMessageForm.new(text_message_form_params)
    form.message = @room.messages.build(from: current_membership)
    form.save!

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to room_url(@room)
      end
    end
  end

  private

  def text_message_form_params
    params.expect(text_message_form: [ encrypted_messages_attributes: [
                                         %i[membership_id key_pair_id cipher iv encrypted_key]
                                       ] ])
  end
end
