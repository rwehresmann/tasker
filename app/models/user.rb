class User < ApplicationRecord
  belongs_to :team

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true

  accepts_nested_attributes_for :team

  def name
    "#{first_name} #{last_name}"
  end
end
