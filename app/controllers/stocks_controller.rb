class StocksController < ApplicationController
  
  def welcome
    redirect_to :action => 'list', :portfolio_id => @person.portfolios[0].key if @person
  end
  
  def index
    redirect_to :action => 'list'
  end
  
  def new
    @portfolio = Portfolio.get(params[:portfolio_id])
    @stock = Stock.new
  end
  
  def create
    @portfolio = Portfolio.get(params[:portfolio_id])
    stock = params[:stock]
    stock['portfolio'] = @portfolio
    new_stock = Stock.create(stock)
    redirect_to :action => 'list'
  end
  
  def list
    @portfolio = Portfolio.get(params[:portfolio_id])
    #if logged in, and portfolio belongs to user
    if @person and @person.portfolios.collect { |p| p.key }.include? @portfolio.key
      session[:stocks], @stocks = [], []
      @portfolio.stocks.each do |stock|
        stock.update #updates the current price and calculations
        @stocks << stock
        session[:stocks] << { :symbol => stock.symbol, :price => stock.price } #store stock for comparison
      end
    else
      redirect_to :action => 'welcome'
    end
  end
  
  def price
    render :text => Stock.check_price(params[:symbol])
  end
  
  def update
    @portfolio = Portfolio.get(params[:portfolio_id])
    respond_to do |format|
      format.js {
        render :update do |page|
          @portfolio.stocks.each do |stock|
            stock.update
            session_stock = session[:stocks].select { |st| st[:symbol] == stock.symbol }[0]
            if stock.price != session_stock[:price]
              page.replace_html "stock-#{stock.key}-price", stock.price
              page.visual_effect :highlight, "stock-#{stock.key}-price"
              page.replace_html "stock-#{stock.key}-change", stock.change
              page.visual_effect :highlight, "stock-#{stock.key}-change"
              page.replace_html "stock-#{stock.key}-value", number_to_currency(stock.price.to_f * stock.quantity.to_f)
              page.visual_effect :highlight, "stock-#{stock.key}-value"
              session[:stocks].delete_if { |s| s[:symbol] == stock.symbol }
              session_stock[:price] = stock.price
              session[:stocks] << session_stock
            end
          end 
        end
      }
    end
  end
  
end
