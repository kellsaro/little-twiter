class Session
  include ActiveModel::Model

  attr_accessor :email, :password

  #validates :email, presence: true, length: {maximum: 255},
  #          format: {with: User::VALID_EMAIL_REGEX},
  #          uniqueness: { case_sensitive: false}
  #validates :password, presence: true, length {minimum: 6}

end
