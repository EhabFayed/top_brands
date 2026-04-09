class CreateCompanyData < ActiveRecord::Migration[8.0]
  def change
    create_table :company_data do |t|
      t.string :email
      t.string :phone_number_1
      t.string :phone_number_2
      t.string :whatsapp_number
      t.string :address_ar
      t.string :address_en
      t.string :google_maps_url
      t.string :working_hours_ar
      t.string :working_hours_en
      t.string :facebook_url
      t.string :instagram_url
      t.string :twitter_url
      t.string :linkedin_url
      t.timestamps
    end
  end
end
