require 'grape'
require './craigslist'

class API < Grape::API
  rescue_from :all
  default_error_status 500

  resource :craigslist do

    format :json

    params do
      requires :query, type: String, desc: "String of what to search for"
      optional :cities, type: Array, desc: "Array of valid Craigslist cities to search against"
    end
    get :search do
      begin
        MyCraig.search params
      rescue => err
        error! "Received error: #{err}"
      end
    end

    get :cities do
      { cities: MyCraig::CITIES }
    end

  end
end

class MyCraig < Craigslist

  def to_json
    elements = []

    @items.each do |item|
      elements << {
        description: item.summary,
        title: item.title,
        link: item.url,
        posted: item.published,
      }
    end

    {
      items: elements,
      urls: @urls,
    }.to_json
  end

end

run API
