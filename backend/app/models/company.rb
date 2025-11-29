class Company < ApplicationRecord
  has_many :company_representatives, dependent: :destroy
  has_many :representatives, through: :company_representatives

  validates :rut, presence: true
  validates :name, presence: true

  # Búsqueda simple por RUT o nombre
  scope :search, ->(term) {
    return none if term.blank?

    t = term.strip
    where("rut ILIKE :t OR name ILIKE :t", t: "%#{t}%")
  }
end
