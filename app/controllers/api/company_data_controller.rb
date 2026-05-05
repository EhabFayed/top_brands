module Api
  class CompanyDataController < ApplicationController
    before_action :require_admin_or_manager!
    before_action :set_company_datum

    # GET /api/company_data
    def show
      render json: @company_datum
    end

    # PUT/PATCH /api/company_data
    def update
      if @company_datum.update(company_data_params)
        render json: {message: "Company data updated successfully"}, status: :ok
      else
        render json: { errors: @company_datum.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_company_datum
      @company_datum = CompanyDatum.first_or_create
    end

    def company_data_params
      params.require(:company_datum).permit(
        :email, :phone_number_1, :phone_number_2, :whatsapp_number,
        :address_ar, :address_en, :google_maps_url,
        :working_hours_ar, :working_hours_en,
        :facebook_url, :instagram_url, :twitter_url, :linkedin_url
      )
    end
  end
end
