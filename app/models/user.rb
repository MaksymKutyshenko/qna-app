class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscribtions, dependent: :destroy

  def author_of?(resource)
    self.id == resource.user_id
  end

  def voted_for?(votable)
    votable.votes.find_by(user: self).present?
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info['email']
    return User.new unless email.present?

    if user = User.where(email: email).first
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
  end

  def self.send_daily_digest
    questions_digest = Question.where("created_at >= ?", Time.zone.now.beginning_of_day).to_a

    if questions_digest.present?
      find_each.each do |user|
        DailyMailer.digest(user, questions_digest).deliver_later
      end
    end
  end

  def subscribe(subscribable)
    subscribtions.create(subscribable: subscribable) unless subscribed?(subscribable)
  end

  def unsubscribe(subscribable)
    subscription = subscribtions.find_by(subscribable: subscribable)
    subscription.destroy if subscription.present?
  end

  def subscribed?(subscribable)
    subscribtions.find_by(subscribable: subscribable).present?
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
