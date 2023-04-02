require 'open-uri'

module Moderable
  extend ActiveSupport::Concern

  included do
    validates :message, presence: true
    after_save :message # pour que le module s'active lorsque "message" est modifié mais pas sur que ce soit ça
    attr_reader :message
  end

  def check(message, is_accepted = false)
    @url_encoded_string = ERB::Util.url_encode(message)
    @score_prediction = score_prediction(@url_encoded_string)
    @is_accepted = @score_prediction.is_accepted?
  end


  def is_accepted?
    @score_prediction < 0.8
  end

  private

  def score_prediction(text_message)
    response = URI.open("https://moderation.logora.fr/predict?text=#{text_message}")
    json = JSON.parse(response.read)
    json['prediction']['0']
  end

end
