require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
  
    ruby_book = products(:ruby)

    # a user goes to the index page
    get '/'
    assert_response :success
    assert_template "index"

    # they select a product, adding it to their cart
    xml_http_request :post, '/line_items', :product_id => ruby_book.id
    assert_response :success
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    # they then checkout
    get '/orders/new'
    assert_response :success
    assert_template "new"

    # submit user data
    post_via_redirect '/orders', 
                      :order => { 
                        :name     => "Clint Shryock",
                        :address  => "132 The Street",
                        :email    => "clint@dogmeat.com",
                        :pay_type => "Check" }

    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    # check database
    orders = Order.all
    assert_equal 1, orders.size
    order = orders.first
    assert_equal "Clint Shryock", order.name

    line_item = order.line_items.first
    assert_equal ruby_book, line_item.product
    
    # check mail
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["clint@dogmeat.com"], mail.to
  end

end
