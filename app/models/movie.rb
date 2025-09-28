class Movie < ActiveRecord::Base
  RATINGS = %w[G PG PG-13 R NC-17].freeze

  def self.all_ratings
    RATINGS
  end

  def self.with_ratings(ratings_list)
    return all if ratings_list.blank?
    where(rating: ratings_list)
  end
end
