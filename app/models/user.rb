class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :trackable, :validatable,:omniauthable
  has_many :identities

  def self.find_for_oauth(auth, signed_in_resource = nil)
  	identity = Identity.find_for_oauth(auth)
  	user = signed_in_resource ? signed_in_resource : identity.user
    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email
      user = User.where(:email => email).first if email
      if user.nil? # Create the user if it's a new registration
        if auth.provider == "twitter"
          email = auth.extra.raw_info.name + "@" + auth.provider + ".com"
        end
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ,
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation! if user.respond_to?(:skip_confirmation)
        user.save
      end
    end
    if identity.user != user # Associate the identity with the user if needed
      identity.user = user
      identity.save
    end
    user
  end
end