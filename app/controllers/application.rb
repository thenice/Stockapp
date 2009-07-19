require 'beeu'

class ApplicationController < ActionController::Base
  helper :all 
  include BeeU

  before_filter :assign_user
  before_filter :assign_admin_status
  before_filter :register_user
  
  protected

  def register_user
    if @user
      @person = Person.find(:email => @user.email)
      unless @person 
        p = Person.new( :email => @user.email,
          :screen_name => @user.nickname)
        # weird assingments because of bumble...
        p.save!
        portfolio = Portfolio.new(:person_id => p.key, :title => "#{p.screen_name}'s Portfolio")
        portfolio.save!
        @person = p
      end
    end
  end

  
  
  
end
