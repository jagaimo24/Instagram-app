require 'bcrypt'

class User < ApplicationRecord
  devise :database_authenticatable,         #パスワードの暗号化処理
         :registerable,                     #ユーザー登録・ログイン処理
         :recoverable,                      #パスワードリセット処理
         :rememberable,                     #ログイン情報保持処理（Cookieに保存） 
         :validatable,                      #メールアドレス、パスワードのバリデーション
         :confirmable,                      #新規登録時にメール認証機能追加
         :omniauthable
         # :lockable
         # :timeoutable, 
         # :trackable and 

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes,    dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_notifications,  class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },
              format: { with: VALID_EMAIL_REGEX },
              uniqueness: { case_sensitive: false }
  validates :profile, presence: true, length: { maximum: 160 }, allow_blank: true
  validates :phone, format: {with: /\A[0-9]{3}-[0-9]{4}-[0-9]{4}\z/}, allow_blank: true

  enum gender: { man: 1, woman: 2 }

  def feed
    following_ids = "SELECT followed_id FROM relationships
                      WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                      OR user_id = :user_id", user_id: id)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      all 
    end
  end

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
 
    unless user
      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        name:     auth.info.name,
        email:    auth.info.email,
        password: Devise.friendly_token[0, 20],
        image:    auth.info.image
      )
    end
 
    user
  end

  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
end
