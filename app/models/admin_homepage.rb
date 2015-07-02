class AdminHomepage < ActiveRecord::Base
  attr_accessible :community_id, :order, :listing_id
end
