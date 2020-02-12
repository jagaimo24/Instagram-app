require 'bcrypt'

class User < ApplicationRecord
  devise :database_authenticatable,         #パスワードの暗号化処理
         :registerable,                     #ユーザー登録・ログイン処理
         :recoverable,                      #パスワードリセット処理
         :rememberable,                     #ログイン情報保持処理（Cookieに保存） 
         :validatable                       #メールアドレス、パスワードのバリデーション
          # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },
              format: { with: VALID_EMAIL_REGEX },
              uniqueness: { case_sensitive: false }
end
