# == Schema Information
#
# Table name: admin_homepages
#
#  id           :integer          not null, primary key
#  community_id :string(255)      not null
#  listing_id   :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class AdminHomepage < ActiveRecord::Base
  attr_accessible :community_id, :listing_id

  def self.find_listings(community_id)
    listing_ids = AdminHomepage.where(community_id: community_id).limit(4).order('updated_at desc').pluck(:listing_id)
    return [] if listing_ids.size == 0
    Listing.visible_to(nil, nil, listing_ids).order("field(id, #{listing_ids.join(',')})")
  end
end
