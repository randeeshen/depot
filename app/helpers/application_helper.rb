module ApplicationHelper
  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display:none"
    end
    content_tag("div", attributes, &block)
  end

  def total_cost(line_items)
    price = line_items.to_a.sum {|item| item.total_price }
    number_to_currency(price)
  end
end
