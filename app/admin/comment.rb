ActiveAdmin.register Comment , :as => "ListingComment"  do
  index do
    column :id
    column :community_id
    column :listing_id
    column :content
    column :created_at

    default_actions
  end

  filter :community_id
  filter :listing_id
end
