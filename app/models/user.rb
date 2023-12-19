class User < ActiveRecord::Base
  validates :email, uniqueness: { case_sensitive: false },
                    format: {
                      with: URI::MailTo::EMAIL_REGEXP,
                      message: 'must be a valid email'
                    }
  validates :zip_code, format: {
    with: /^\d{5}$/,
    multiline: true,
    message: 'must be 5 digits'
  }

  has_one :vote
end
