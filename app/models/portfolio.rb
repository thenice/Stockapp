class Portfolio
  include Bumble
  ds :title, :created_at, :person_id
  has_many :stocks, :Stock, :portfolio_id
  belongs_to :person, :Person
  
  def update
    self.stocks.each { |stock| stock.update }
  end
  
end
