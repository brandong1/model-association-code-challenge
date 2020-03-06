class Customer

  attr_accessor :first_name, :last_name
  @@all = []

  def initialize(name)
    name = name.split()
    @first_name = name[0]
    @last_name = name[1]
    @@all << self
  end

  def self.all
    @@all
  end

  def full_name
    "#{@first_name} #{@last_name}" 
  end

  #Customer#add_review(restaurant, content, rating)
  def add_review(content, rating, restaurant)
    Review.new(content: content, rating: rating, restaurant: restaurant, customer: self)
  end

   # Returns the total number of reviews that a customer has authored
  def reviews_by_user
    Review.all.select{|review| review.customer == self}
  end

  def num_reviews
    reviews_by_user.count
  end

  def restaurants
    reviews_by_user.map{|res| res.restaurant}.uniq
  end

  #Customer.find_by_name(name)
  #given a string of a full name, returns the first customer whose full name matches
  def self.find_by_name(name)
    customer = self.all.find{|n| n.full_name.include? (name) }
    customer.full_name
  end

  #Customer.find_all_by_first_name(name)
  #given a string of a first name, returns an array containing all customers with that first name

  def self.find_all_by_name(name)
    customer = self.all.find_all{|n| n.full_name.start_with?(name)}
  end

  #Customer.all_names
  #should return an array of all of the customer full names
  def self.all_names
    self.all.map{|c| c.full_name}
  end

 

end


class Restaurant 
  attr_accessor :name
  @@all = []

  def initialize (name)
    @name = name
    @@all << self
  end

  def self.all
    @@all
  end

  #Restaurant#reviews
  #returns an array of all reviews for that restaurant
  def reviews
    Review.all.select{|r| r.restaurant == self}
  end

   # Restaurant#customers
  #Returns a unique list of all customers who have reviewed a particular restaurant.
  def customers
    reviews.map{|review| review.customer}.uniq
  end

  #Restaurant#average_star_rating
  #returns the average star rating for a restaurant based on its reviews

  def average_star_rating
    number = reviews.count
    total = reviews.reduce(0){|sum, r| sum += r.rating }
    average = total / number
  end

  #Restaurant#longest_review
  #returns the longest review content for a given restaurant
  def longest_review
    content = reviews.map{|r| r.content}
    content.max_by(&:length)
  end

  #Restaurant.find_by_name(name)
  #given a string of restaurant name, returns the first restaurant that matches

  def self.find_by_name(name)
    restaurant = self.all.find{|r| r.name == name}
    restaurant.name
  end

end

class Review
  attr_accessor :content, :restaurant, :customer
  attr_reader :rating
  @@all = []

  def initialize (content:, rating:, restaurant:, customer:)
    @rating = rating
    @content = content
    @customer = customer
    @restaurant = restaurant
    @@all << self
  end

  def self.all
    @@all
  end


  #Review#rating
  #returns the star rating for a restaurant. This should be an integer from 1-5
  def rating=(the_rating)
    @rating = the_rating.clamp(1,5)
  end

end

# test Data

cus1 = Customer.new("Peter Ayeni")
cus2 = Customer.new("James Collins")

res1 = Restaurant.new("KFC")
res2 = Restaurant.new("BIG MaC")

rev1 = cus2.add_review("Oh great", 5, res1)
rev2 = cus2.add_review("Oh great get it done", 3, res1)
rev3 = cus1.add_review("Oh My", 4, res1)

cus2.num_reviews
cus2.restaurants

res1.customers
res1.reviews
res1.average_star_rating
res1.longest_review

Customer.find_by_name("Peter Ayeni")
Customer.find_all_by_name("Peter")
Customer.all_names

Restaurant.find_by_name("KFC")
rev1.content
