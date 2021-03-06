module HomepageHelper
  def show_subcategory_list(category, current_category_id)
    category.id == current_category_id || category.children.any? do |child_category|
      child_category.id == current_category_id
    end
  end

  def with_first_listing_image(listing, &block)
    if listing.listing_images.size > 0
      first_image = listing.listing_images.first

      url =
        if first_image.respond_to?(:image_ready?)
          if first_image.image_ready?
            first_image.image.url(:small_3x2)
          else
            nil
          end
        else
          first_image[:small_3x2]
        end

      block.call(url) if url
    end
  end

  def without_listing_image(listing, &block)
    if listing.listing_images.size == 0
      block.call
    end
  end
end
