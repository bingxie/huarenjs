class AdminHomepage < ActiveRecord::Base
  attr_accessible :community_id, :listing_id

  def self.find_listings(community_id)
    listing_ids = AdminHomepage.where(community_id: community_id).limit(4).order('updated_at desc').pluck(:listing_id)
    Listing.visible_to(nil, nil, listing_ids).order("field(id, #{listing_ids.join(',')})")
  end
end
