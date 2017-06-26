class User < ApplicationRecord
  after_initialize :create_login, if: :new_record?
  # after_initialize :login_in_login, if: :new_record?
	has_many :bookings
	validates :login, presence: true, uniqueness: {case_sensitive: false}
	validates_format_of :login, with: /^[a-zA-Z0-9_\.]*$/, multiline: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]


  def create_login
    if self.login.blank?
      email = self.email.split(/@/)
      login_taken = User.where(login: email[0]).first
      unless login_taken
        self.login = email[0]
      else    
        self.login = self.email
      end   
    end     
  end
# def login_in_login
# 	email = self.email
# 	unless self.email.index('@')
# 		email_taken = User.where(login: email).first
# 		self.email = User.find(email_taken.id)
# 	else
# 		self.email = email
# 	end
# end

  # def login=(login)
  # 	@login = login
  # end

  # def login
  # 	@login || self.login || self.email
  # end
    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      conditions[:email].downcase! if conditions[:email]
where(conditions.to_h).first
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(login) = :value OR lower(email) = :value", { value: login.downcase }]).first
      elsif conditions.has_key?(:login) || conditions.has_key?(:email)
        where(conditions.to_h).first
      end
    end
end
