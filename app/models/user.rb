require 'bcrypt'

class User < ApplicationRecord
  devise :database_authenticatable,         #パスワードの暗号化処理
         :registerable,                     #ユーザー登録・ログイン処理
         :recoverable,                      #パスワードリセット処理
         :rememberable,                     #ログイン情報保持処理（Cookieに保存） 
         :validatable,                      #メールアドレス、パスワードのバリデーション
         :confirmable                       #新規登録時にメール認証機能追加
         #  :lockable
         # :timeoutable, :trackable and :omniauthable
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes, dependent: :destroy
  has_many :comments

  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },
              format: { with: VALID_EMAIL_REGEX },
              uniqueness: { case_sensitive: false }

  # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                      WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                      OR user_id = :user_id", user_id: id)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"]) #検索とuseanameの部分一致を表示。
    else
      all 
    end
  end
end
