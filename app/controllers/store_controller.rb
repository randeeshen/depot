class StoreController < ApplicationController

  skip_before_filter :authorize

  caches_page :index

  def index
    if params[:set_locale]
      redirect_to store_path(:locale => params[:set_locale])
    else 
      @cart     = current_cart
    end

    # Playtime: filter products by default locale if provided
    if params[:locale] 
      @products = Product.where(:locale => params[:locale], :active => true)
    else
      @products = Product.all_active
    end

    #  Count number of times user hits store#index,
    #  for "Playtime"
    if session[:counter].nil?
      session[:counter] = 0
    end
    session[:counter] = session[:counter] + 1
  end

end
