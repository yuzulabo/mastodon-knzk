# frozen_string_literal: true

class User < ApplicationRecord
  include Settings::Extend

  devise :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable,
         :two_factor_authenticatable, :two_factor_backupable,
         otp_secret_encryption_key: ENV['OTP_SECRET'],
         otp_number_of_backup_codes: 10
  devise :omniauthable, { omniauth_providers: [:facebook , :github] }

  belongs_to :account, inverse_of: :user, required: true
  accepts_nested_attributes_for :account

  validates :locale, inclusion: I18n.available_locales.map(&:to_s), unless: 'locale.nil?'
  validates :email, email: true

  scope :recent,    -> { order('id desc') }
  scope :admins,    -> { where(admin: true) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def setting_default_privacy
    settings.default_privacy || (account.locked? ? 'private' : 'public')
  end

  def setting_boost_modal
    settings.boost_modal
  end

  def self.from_omniauth(auth)
    uid = auth['uid']
    provider = auth['provider']
    email = auth['info']['email'] || ''
    avator_url = auth['info']['image'] || ''

    username = omniauth_username provider, uid
    display_name = auth['info']['name'] || auth['info']['nickname'] || username

    user = find_or_create_by(provider: provider, uid: uid) do |user|
      password = Devise.friendly_token[0,20]
      user.email = email
      user.password = password
      user.password_confirmation = password
      user.skip_confirmation!
      user.create_account(username: username, display_name: display_name)
      user.account.avatar_remote_url = avator_url if avator_url
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def setting_auto_play_gif
    settings.auto_play_gif
  end

  private_class_method

  def self.omniauth_username(provider, uid)
    name_prefix =
      case provider
        when 'facebook' then 'fb'
        when 'github' then 'gh'
        else nil
      end
    return nil unless name_prefix
    "#{name_prefix}#{uid}"
  end
end
