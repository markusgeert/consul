class PagesController < ApplicationController
  include FeatureFlags
  skip_authorization_check

  feature_flag :help_page, if: lambda { params[:id] == "help/index" }

  def show
    @custom_page = SiteCustomization::Page.published.find_by(slug: params[:id])

    @raad_sorted = {
      # PVDA
      67 => 1,
      52 => 2,
      45 => 3,
      62 => 4,
      75 => 5,
      44 => 6,
      51 => 7,
      64 => 8,

      #GL
      80 => 1,
      53 => 2,
      71 => 3,
      77 => 4,
      74 => 5,
      73 => 6,
      70 => 7,

      # FNP
      60 => 1,
      46 => 2,
      43 => 3,
      58 => 4,

      # Gemeentebelangen
      76 => 1,
      49 => 2,
      72 => 3,
      66 => 4,

      # CDA
      79 => 1,
      78 => 2,
      59 => 3,
      54 => 4,

      # VVD
      51 => 1,
      69 => 2,
      56 => 3,

      # Lijst 058
      58 => 1,
      50 => 2,
      47 => 3,

      # D66
      63 => 1,
      55 => 2,
      61 => 3,

      # CU
      48 => 1,
      57 => 2,

      # Forum
      42 => 1,

      # Generieke link
      9 => 1,
    }

    if @custom_page.present?
      if @custom_page.id == 10
        @cards = @custom_page.cards.sort_by { |card| @raad_sorted[card.id] || Float::INFINITY }.group_by { |card| card.label }
      else
        @cards = @custom_page.cards
      end
      render action: :custom_page
    else
      render action: params[:id].split(".").first
    end
  rescue ActionView::MissingTemplate
    head :not_found, content_type: "text/html"
  end
end