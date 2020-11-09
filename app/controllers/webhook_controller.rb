require 'json'
require 'base64'

class WebhookController < ApplicationController
  def confirm_crc
    crc_token = params[:crc_token]
    return if crc_token.nil?

    consumer_secret = ENV['TWITTER_CONSUMER_SECRET']

    # puts "CRC event with #{crc_token}"
    # puts "headers: #{headers}"
    # puts headers['X-Twitter-Webhooks-Signature']

    response = {}
    response['response_token'] = "sha256=#{generate_crc_response(consumer_secret, crc_token)}"

    render :json => response
  end

  def filter_events
    # filter events for mentions, create user and send reply tweet
    data_hash = JSON.parse(request.body.read)

    if (data_hash["user_has_blocked"] == false)
      p tweet_author = data_hash["tweet_create_events"][0]["user"]["screen_name"]
      p in_reply_to_screen_name = data_hash["tweet_create_events"][0]["in_reply_to_screen_name"]
      p in_reply_to_status_id = data_hash["tweet_create_events"][0]["in_reply_to_status_id"]
      UsersController.create_from_webhook(in_reply_to_screen_name, tweet_author, in_reply_to_status_id)
    end
  end

  private

  def generate_crc_response(consumer_secret, crc_token)
    hash = OpenSSL::HMAC.digest('sha256', consumer_secret, crc_token)
    return Base64.encode64(hash).strip!
  end
end
