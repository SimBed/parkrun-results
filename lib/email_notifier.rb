# frozen_string_literal: true

require 'net/smtp'
require_relative 'message_writer'

class EmailNotifier
  GMAIL_API_KEY = ENV.fetch('GMAIL_API_KEY', nil)
  EMAIL_FROM = ENV.fetch('EMAIL_FROM', nil)
  EMAIL_TO = ENV.fetch('EMAIL_TO', nil)

  def deliver(date, results)

    results_text = MessageWriter.new(results).write_message
    msgstr = <<~MESSAGE
      From: #{EMAIL_FROM}
      To: #{EMAIL_TO} 
      Subject: Park Run Results on #{date}

      #{results_text}
    MESSAGE

    Net::SMTP.start('smtp.gmail.com', 25, 'localhost', EMAIL_FROM, GMAIL_API_KEY,
                    :login) do |smtp|
      smtp.send_message msgstr, EMAIL_FROM, EMAIL_TO
    end
  end
end
