class Person
  include Bumble
  ds :given_name, :screen_name, :email
  has_many :portfolios, :Portfolio, :person_id
end
