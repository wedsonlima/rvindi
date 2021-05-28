# frozen_string_literal: true

module CoreExtensions
  # WARNING: monkey patch (https://github.com/remi/her/blob/master/lib/her/model/relation.rb#L34)
  #
  # The `where` clause must be adapted to vindi requirements:
  # https://atendimento.vindi.com.br/hc/pt-br/articles/204163150
  module HerWithQueryFilter
    # Add a query string parameter
    #
    # @example
    #   @users = User.where(contains: { name: 'Gandalf' })
    #   # Fetched via GET "/users?query=name:Gandalf"
    #
    # @example
    #   @users = User.active.where(gt: { created_at: Time.zone.yesterday })
    #   # Fetched via GET "/users?query=status=active created_at>2021-01-01"
    def where(params = {})
      return self if params.blank? && !@_fetch.nil?

      clone.tap do |r|
        default_params = extract_params params, r.params
        query = params_to_query params, parse_query(r.params.fetch(:query, ""))

        r.params = r.params.merge default_params.merge(query: query)
        r.clear_fetch_cache!
      end
    end

    private

    def parse_query(query)
      CGI.parse(query).transform_values(&:first)
    end

    def extract_params(new_ones, old_ones)
      page        = new_ones.delete(:page)        || old_ones.delete(:page)       || 1
      per_page    = new_ones.delete(:per_page)    || old_ones.delete(:per_page)   || 25
      sort_by     = new_ones.delete(:sort_by)     || old_ones.delete(:sort_by)    || :created_at
      sort_order  = new_ones.delete(:sort_order)  || old_ones.delete(:sort_order) || :desc

      {
        page: page,
        per_page: per_page,
        sort_by: sort_by,
        sort_order: sort_order
      }.delete_if { |_, v| v.nil? }
    end

    def params_to_query(params, query)
      params.merge(query).map do |key, value|
        case key
        when :contains  then value.map { |k, v| "#{k}:#{v}" }.last
        when :gt        then value.map { |k, v| "#{k}>#{v}" }.last
        when :gteq      then value.map { |k, v| "#{k}>=#{v}" }.last
        when :lt        then value.map { |k, v| "#{k}<#{v}" }.last
        when :lteq      then value.map { |k, v| "#{k}<=#{v}" }.last
        when :not       then value.map { |k, v| "-#{k}:#{v}" }.last
        else
          value ? "#{key}=#{value}" : key
        end
      end.join(" ")
    end
  end
end

Her::Model::Relation.prepend CoreExtensions::HerWithQueryFilter
