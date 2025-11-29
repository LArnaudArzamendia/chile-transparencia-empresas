class Representative < ApplicationRecord
  has_many :company_representatives, dependent: :destroy
  has_many :companies, through: :company_representatives

  validates :full_name, presence: true
  validates :rut, presence: true

  scope :search, ->(term) {
    return none if term.blank?

    t = term.strip
    where("rut ILIKE :t OR full_name ILIKE :t", t: "%#{t}%")
  }
end
