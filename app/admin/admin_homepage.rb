ActiveAdmin.register AdminHomepage do
  index do
    column :id
    column :community_id
    column :listing_id
    column :updated_at

    default_actions
  end

  filter :community_id

  form do |f|
    f.inputs "New Listing" do
      f.input :community_id
      f.input :listing_id
    end
    f.actions
  end
end
