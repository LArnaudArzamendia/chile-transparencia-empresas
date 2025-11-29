module Api
  module V1
    class CompaniesController < ApplicationController
      def show
        company = Company.includes(company_representatives: :representative).find(params[:id])

        render json: {
          id: company.id,
          rut: company.rut,
          name: company.name,
          year: company.year,
          month: company.month,
          capital: company.capital,
          comuna_tributaria: company.comuna_tributaria,
          region_tributaria: company.region_tributaria,
          comuna_social: company.comuna_social,
          region_social: company.region_social,
          company_type: company.company_type,
          representatives: company.company_representatives.map do |cr|
            rep = cr.representative
            {
              id: rep.id,
              rut: rep.rut,
              full_name: rep.full_name,
              role: cr.role
            }
          end
        }
      end
    end
  end
end