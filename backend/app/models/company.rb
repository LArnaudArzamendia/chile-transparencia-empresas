class Company < ApplicationRecord
  has_many :company_representatives, dependent: :destroy
  has_many :representatives, through: :company_representatives

  validates :rut, presence: true
  validates :name, presence: true

  before_validation :set_normalized_rut

  # Normaliza un RUT a formato "XXXXXXXX-D"
  def self.normalize_rut(raw)
    return nil if raw.blank?

    s = raw.to_s.strip

    # Elimino puntos, espacios y caracteres raros comunes.
    s = s.delete(".").delete(" ").delete("\u00A0")

    # Mayúscula K.
    s = s.tr("k", "K")

    # Si no tiene guion, asumo último carácter como DV.
    unless s.include?("-")
      return nil if s.length < 2

      body = s[0...-1]
      dv   = s[-1]
      s = "#{body}-#{dv}"
    end

    s
  end

  # Scope de búsqueda mejorado: nombre, rut y normalized_rut
  scope :search, ->(term) {
    return none if term.blank?

    text = "%#{term.strip}%"
    nr = normalize_rut(term)

    if nr
      where("name ILIKE :text OR rut ILIKE :text OR normalized_rut = :nr",
            text: text, nr: nr)
    else
      where("name ILIKE :text OR rut ILIKE :text", text: text)
    end
  }

  private

  def set_normalized_rut
    self.normalized_rut = self.class.normalize_rut(rut)
  end
end