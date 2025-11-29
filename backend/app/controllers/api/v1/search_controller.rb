module Api
  module V1
    class SearchController < ApplicationController
      def index
        query = params[:q]

        companies = Company.search(query).limit(20).includes(:representatives)
        representatives = Representative.search(query)
                                        .limit(20)
                                        .includes(:companies)

        render json: {
          query: query,
          companies: companies.as_json(
            only: [:id, :rut, :name],
            include: {
              representatives: {
                only: [:id, :rut, :full_name],
                through: :company_representatives
              }
            }
          ),
          representatives: representatives.map { |rep|
            {
              id: rep.id,
              rut: rep.rut,
              full_name: rep.full_name,
              companies: rep.companies.select(:id, :rut, :name)
            }
          }
        }
      end
    end
  end
end
