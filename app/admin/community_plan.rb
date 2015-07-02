ActiveAdmin.register CommunityPlan do
  index do
    column :id
    column :community_id
    column :plan_level
    column :expires_at
    column :updated_at

    default_actions
  end

  filter :community_id
  filter :plan_level

  form do |f|
    f.inputs "New Listing" do
      f.input :id
      f.input :community_id
      f.input :plan_level
      f.input :expires_at
    end
    f.actions
  end
end
