Order.transaction do
  (1..100).each do |i|
    order = Order.where(:name => "Customer -#{i}")
    Order.destroy(order)
  end
end
