module ListingService::API
  CategoryStore = ListingService::Store::Category

  class Categories
    def get(community_id:)
      Result::Success.new(
        CategoryStore.get_all(community_id: community_id)
      )
    end

    def create(community_id:, opts:)
      Result::Success.new(
        CategoryStore.create(community_id: community_id, opts: opts)
      )
    end

    # create_category!(community_id: 10, name: "Cars", listing_shape_ids: [1])
    def create_category!(community_id:, parent_id: nil, name:, listing_shape_ids: [])
      community = Community.find(community_id)
      sort_priority = Admin::SortingService.next_sort_priority(community.categories)

      category_opts = {
        parent_id: parent_id,
        sort_priority: sort_priority,
        basename: name,
        translations: [{name: name, locale: "zh"}]
      }

      res = self.create(community_id: community_id, opts: category_opts)
      cat_id = res.data[:id]

      # Create association
      listing_shape_ids.each { |lsid|
        # FIXME Do not use Models to initialize test data for API tests!
        CategoryListingShape.create!(category_id: cat_id, listing_shape_id: lsid)
      }

      cat_id
    end
  end
end
