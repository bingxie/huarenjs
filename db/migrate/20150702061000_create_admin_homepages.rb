class CreateAdminHomepages < ActiveRecord::Migration
  def change
    create_table :admin_homepages do |t|
      t.string :community_id, null: false
      t.integer :listing_id, null: false

      t.timestamps
    end
  end
end
