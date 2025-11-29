class Representative < ApplicationRecord
  has_many :company_representatives, dependent: :destroy
  has_many :companies, through: :company_representatives

  validates :rut, presence: true
  validates :full_name, presence: true

  before_validation :set_normalized_rut

  def self.normalize_rut(raw)
    return nil if raw.blank?

    s = raw.to_s.strip
    s = s.delete(".").delete(" ").delete("\u00A0")
    s = s.tr("k", "K")

    unless s.include?("-")
      return nil if s.length < 2

      body = s[0...-1]
      dv   = s[-1]
      s = "#{body}-#{dv}"
    end

    s
  end

  scope :search, ->(term) {
    return none if term.blank?

    text = "%#{term.strip}%"
    nr = normalize_rut(term)

    if nr
      where("full_name ILIKE :text OR rut ILIKE :text OR normalized_rut = :nr",
            text: text, nr: nr)
    else
      where("full_name ILIKE :text OR rut ILIKE :text", text: text)
    end
  }

  private

  def set_normalized_rut
    self.normalized_rut = self.class.normalize_rut(rut)
  end
end