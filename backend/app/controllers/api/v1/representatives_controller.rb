module Api
  module V1
    class RepresentativesController < ApplicationController
      def show
        representative = Representative.includes(company_representatives: :company).find(params[:id])

        render json: {
          id: representative.id,
          rut: representative.rut,
          full_name: representative.full_name,
          companies: representative.company_representatives.map do |cr|
            company = cr.company
            {
              id: company.id,
              rut: company.rut,
              name: company.name,
              role: cr.role
            }
          end
        }
      end
    end
  end
end