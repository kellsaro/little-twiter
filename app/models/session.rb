class Session
  include ActiveModel::Model

  attr_accessor :email, :password, :remember_me

  #validates :email, presence: true, length: {maximum: 255},
  #          format: {with: User::VALID_EMAIL_REGEX},
  #          uniqueness: { case_sensitive: false}
  #validates :password, presence: true, length {minimum: 6}

  def clear
    self.email = nil
    self.password = nil
    self.remember_me = nil
  end
end
