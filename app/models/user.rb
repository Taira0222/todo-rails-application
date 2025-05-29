class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  validates :name, presence: true, length: { maximum: 30 } 
  has_many :todos, dependent: :destroy #userが消えたらtodoも消える
end
