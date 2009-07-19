class Stock
  require 'rubygems'
  require 'json/pure'
  include Bumble
  ds :symbol, :buy_price, :quantity, :created_at, :portfolio_id
  belongs_to :portfolio, Portfolio
  attr_accessor :data, :price, :change
  
  def update
    begin
      json = JSON.parse(fetch(self.symbol))
      @data = json['query'] 
      @change = json['query']['results']['row']['change']
      @price = json['query']['results']['row']['price']
    rescue JSON::ParserError
      @data = 'error'
      @change = 0
      @price = 0
    end
  end
  
  def self.check_price(symbol)
    json = JSON.parse(fetch)
    json['query']['results']['row']['price']
  end
  
  def is_up?
    @change.include? "+"
  end
  
  def is_down?
    not is_up?
  end
  
  private
  
  # return json stock quote 
  def fetch(symbol)
    response = URLFetch.get("http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D'http%3A%2F%2Fdownload.finance.yahoo.com%2Fd%2Fquotes.csv%3Fs%3D#{symbol}%26f%3Dsl1d1t1c1ohgv%26e%3D.csv'%20and%20columns%3D'symbol%2Cprice%2Cdate%2Ctime%2Cchange%2Ccol1%2Chigh%2Clow%2Ccol2'&format=json&callback=cbfunc").content
    response.split('(')[1].split(');')[0] #removes the callback function default from yahoo...ugly...  
  end
  
end
