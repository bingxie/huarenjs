Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end

if defined?(WillPaginate)
  module WillPaginate
    module ActiveRecord
      module RelationMethods
        alias_method :total_count, :count

        def per(value = nil) per_page(value) end
        def total_count
          self.count
        end
        def first_page?
          self == first
        end
        def last_page?
          self == last
        end
      end
    end
    module CollectionMethods
      alias_method :num_pages, :total_pages

      def total_count
        count
      end
    end
  end
end
