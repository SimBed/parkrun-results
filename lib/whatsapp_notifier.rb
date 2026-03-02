# frozen_string_literal: true

require 'twilio-ruby'

class WhatsAppNotifier
  CONTENT_SID = ENV.fetch('CONTENT_SID')

  def initialize
    twilio_initialise
  end

  def deliver(attributes = {})
    client = Twilio::REST::Client.new(@account_sid, @auth_token)
    client.api.v2010.messages.create(
      content_sid: CONTENT_SID,
      to: "whatsapp:#{@to_number}",
      from: "whatsapp:#{@from_number}",
      content_variables: attributes[:content_variables].to_json
    )
  end

  private

  def twilio_initialise
    @account_sid = ENV.fetch('TWILIO_ACCOUNT_SID')
    @auth_token = ENV.fetch('TWILIO_AUTH_TOKEN')
    @from_number = ENV.fetch('TWILIO_WHATSAPP_NUMBER')
    @to_number = ENV.fetch('ME')
  end
end
