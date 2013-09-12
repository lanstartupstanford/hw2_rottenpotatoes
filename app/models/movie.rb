class Movie < ActiveRecord::Base
  def self.filter_by_ratings(ratings)
    result = []
    ratings.each do |r|
      result += Movie.find_all_by_rating(r)
    end
    return result
  end
end
