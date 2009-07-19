module StocksHelper

  def portfolio_current_value(stocks)
    value = stocks.inject(0.0) do |result, stock|
      result += (stock.price.to_f * stock.quantity.to_f)
    end
    value
  end
  
  def portfolio_original_value(stocks)
    value = stocks.inject(0.0) do |result, stock|
      result += (stock.buy_price.to_f * stock.quantity.to_f)
    end
    value
  end
  
  def portfolio_gain(stocks)
    gain = portfolio_current_value(stocks) - portfolio_original_value(stocks)
    (gain >= 0) ? (return "<div style = 'color: green'>#{number_to_currency(gain)}</div>") : ("<div style = 'color: red'>#{number_to_currency(gain)}</div>")
  end
  
end
