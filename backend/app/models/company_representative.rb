class CompanyRepresentative < ApplicationRecord
  belongs_to :company
  belongs_to :representative

  # role: "Representante legal", "Socio", etc.
end
