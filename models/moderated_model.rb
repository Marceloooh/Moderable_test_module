class ModeratedModel < ApplicationRecord
  include Moderable

  def check_content(content_text, is_accepted)
    is_accepted = content_text.check
  end
end
