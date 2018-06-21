module AdwordsSimpleApi
  module HasFinders

    module ClassMethods
      def get(predicates = [])
        selector = { fields: field_names }
        unless predicates.nil? || predicates.empty?
          selector[:predicates] = AdwordsSimpleApi.wrap(predicates)
        end

        offset = 0
        entries = []

        begin
          selector[:paging] = {
            start_index: offset,
            number_results: PAGE_SIZE
          }
          puts selector.inspect.to_s
          page = service.get(selector)
          if page[:entries]
            entries.concat(page[:entries])
            # Increment values to request the next page.
            offset += PAGE_SIZE
          end
        end while AdwordsSimpleApi.wrap(page[:entries]).count >= PAGE_SIZE

        entries.map{ |a| self.new(a) }
      end

      def all(hash = {})
        includes = AdwordsSimpleApi.wrap(hash.delete(:includes))
        predicates = hash.map{ |k,v|
          {
            field: field_name(k),
            operator: 'IN',
            values: AdwordsSimpleApi.wrap(v).flatten.uniq
          }
        }
        results = get(predicates)
        eager_load_includes(includes, results) unless includes.empty?
        results
      end

      def eager_load_includes(includes, objects)
        AdwordsSimpleApi.wrap(includes).each do |inc|
          if inc.is_a?(Hash)
            inc.each_pair do |k,v|
              eager_load(k, v, objects)
            end
          else
            eager_load(inc, nil, objects)
          end
        end
      end

      def eager_load(name, includes, objects)
        klass = associations[name] or return
        ids = objects.map(&:id)
        associates = Hash.new { |h, k| h[k] = [] }
        ids.each_slice(SLICE_SIZE) do |slice|
          klass.all(id_field_sym => slice, includes: includes).each do |associate|
            parent_id = associate.send(id_field_sym)
            associates[parent_id].concat([associate])
          end
        end
        objects.each do |obj|
          obj.eager_load(name, associates[obj.id])
        end
        objects
      end

      def find(id, options = {})
        options[:id] = id
        find_by(options)
      end

      def find_by(options)
        all(options).first
      end
    end

    def eager_load(name, associates)
      @associations[name] = AdwordsSimpleApi.wrap(associates)
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
