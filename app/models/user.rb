class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :nickname, presence: true, uniqueness: true

  # Associations
  has_many :flats, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :invited_flats, through: :invitations, source: :flat
  has_many :inspirations, dependent: :destroy

  has_one_attached :avatar

  def is_invited_on?(flat)
    invited_flats.include?(flat)
  end

  def is_invited_and_pending_on?(flat)
    invitations.where(flat: flat).first&.pending?
  end

  def invitation_on(flat)
    invitations.where(flat: flat).first
  end
end
