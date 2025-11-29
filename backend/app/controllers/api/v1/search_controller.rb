module Api
  module V1
    class SearchController < ApplicationController
      def index
        query = params[:q]

        companies = Company.search(query)
                           .includes(company_representatives: :representative)
                           .limit(20)

        representatives = Representative.search(query)
                                        .includes(company_representatives: :company)
                                        .limit(20)

        render json: {
          query: query,
          companies: companies.map { |c|
            {
              id: c.id,
              rut: c.rut,
              name: c.name,
              year: c.year,
              comuna_social: c.comuna_social,
              region_social: c.region_social,
              representatives: c.company_representatives.map { |cr|
                rep = cr.representative
                {
                  id: rep.id,
                  rut: rep.rut,
                  full_name: rep.full_name,
                  role: cr.role
                }
              }
            }
          },
          representatives: representatives.map { |r|
            {
              id: r.id,
              rut: r.rut,
              full_name: r.full_name,
              companies: r.company_representatives.map { |cr|
                company = cr.company
                {
                  id: company.id,
                  rut: company.rut,
                  name: company.name,
                  role: cr.role
                }
              }
            }
          }
        }
      end
    end
  end
end