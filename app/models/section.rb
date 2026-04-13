class Section < ApplicationRecord
  extend Enumerize

  PAGES = {
    home:              "0",
    about_us:          "1",
    services:        "2",
    brands:    "3",
    products: "4",
    faqs:        "5",
    market_coverage: "6",
    blogs: "7",
    became_partner: "8",
    distribution_services: "9",
    logestics_services: "10",
    merchandising_services: "11",
    marketing_services: "12",
  }.freeze

  SECTION_TYPES = {
    hero_section: "0",
    statistics_section: "1",
    our_market_section: "2",
    why_choose_our_markting_solutions_section: "3",
    our_approach: "4",
    cta_section: "5",
    service_bar: "6",
    merchandising_service: "7",
    expert_sales_team: "8",
    driving_results: "9",
    fleet_and_transportation: "10",
    warehouse_excellence: "11",
    logistics_solutions: "12",
    capabilities_bar: "13",
    how_we_distribute: "14",
    distribution_channels: "15",
    contant_info_section: "16",
    partnership_benefits: "17",
    advanced_logestics_infra: "18",
    distribution_capabilities: "19",
    cavarage_areas_list: "20",
    cavarage_map_section: "21",
    newsletter_section: "22",
    contact_infromation: "23",
    contact_form: "24",
    product_categories: "25",
    need_fmcg_distribution_services: "26",
    service_excellence: "27",
    importaing_and_trading_of_consumer_goods: "28",
    merchandising_and_in_store_visibility: "29",
    nationwide_market_coverage: "30",
    direct_delivery_and_sales_execution: "31",
    brand_representation_and_market_entry: "32",
    comprehensive_retail_and_trade_coverage: "33",
    fmcg_distribution_in_syria: "34",
    growth_direction: "35",
    albarengi_group_section: "36",
    certifications_section: "37",
    competitive_edge_section: "38",
    leadership_team_section: "39",
    core_values_section: "40",
    vision_and_mission_section: "41",
    who_we_are_section: "42",
    our_impact_in_numbers: "43",
    contact_section_home: "44",
    leading_fmcg_distribution_in_syria: "45",
    comprehensive_distribution: "46",
    need_a_custom_distribution: "47",
    our_products_and_brand_portfolio: "48",
    why_choose_growing_together: "49",
    our_customers: "50",
    your_trusted_distribution_partner: "51",
    looking_for_reliable_fmcg_distribution: "52"
  }.freeze

  enumerize :page,         in: PAGES,         predicates: true
  enumerize :section_type, in: SECTION_TYPES, predicates: true

  has_many :contents, -> { order(:position) }, as: :parentable, dependent: :destroy
  accepts_nested_attributes_for :contents, allow_destroy: true

  validates :page,         presence: true
  validates :section_type, presence: true
end
