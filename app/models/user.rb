class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  validates :name, presence: true, length: { maximum: 30 } 
  has_many :todos, dependent: :destroy #userが消えたらtodoも消える

  # Google認証時のユーザー取得／作成メソッド
  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]   
      # メールでの確認をスキップ
      user.skip_confirmation!
    end
  end
end
