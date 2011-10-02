class ProductsSweeper < ActionController::Caching::Sweeper

  observe Product

  def after_create(product)
    expire_store_page
  end

  def after_destroy(product)
    expire_store_page
  end

  private
  def expire_store_page
    expire_page(:controller => "store", :action => 'index')
  end

end
