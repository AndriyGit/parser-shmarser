class ParsersController < ApplicationController

  require 'open-uri'
  require 'nokogiri'

  before_filter :categories, only: :index
  before_filter :is_valid_category?, only: :render_category_page

  SOURCE = 'http://siliconrus.com/'

  def index
  end

  def categories
    @categories = all_categories
  end


  def render_category_page
    requsted_category = params[:id]
    @content = grab_content_preview(requsted_category)
    render action: "page"
  end


  private

  def page(uri = '')
    Nokogiri::HTML(open(SOURCE + uri))
  end

  def all_categories
    categories = Array.new
    page.css('a.b-menu__li__a').each do |link|
      categories << {:name => link.content, :href => link['href']}
    end
    categories
  end

  def all_category_names
    category_names = Array.new
    all_categories.each do |category|
      category_names << category[:href][26..-2]
    end
    category_names
  end

  def is_valid_category?
    unless all_category_names.include?(params[:id])
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def grab_content_preview(category)
    elements = Array.new
    page("category/#{category}").css('div.b-articles__b > p').each do |element|
      elements << element.to_html
    end
    elements
  end


end
