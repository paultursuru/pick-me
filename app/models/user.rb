class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :flats, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :invited_flats, through: :invitations, source: :flat
  has_many :inspirations, dependent: :destroy
end
