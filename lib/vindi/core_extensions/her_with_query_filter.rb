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
        r.params = r.params.merge(params)

        # Default params, as order and page number, will always be used.
        default_params = extract_default_params r.params

        # Query filters is joined into a single param called :query.
        query = [r.params.delete(:query), params_to_query(r.params)].compact.join " "

        r.params = { query: query }.merge(default_params)

        r.clear_fetch_cache!
      end
    end

    private

    def extract_default_params(params)
      page        = params.delete(:page)        || 1
      per_page    = params.delete(:per_page)    || 25
      sort_by     = params.delete(:sort_by)     || :created_at
      sort_order  = params.delete(:sort_order)  || :desc

      {
        page: page,
        per_page: per_page,
        sort_by: sort_by,
        sort_order: sort_order
      }.delete_if { |_, v| v.nil? }
    end

    def params_to_query(params)
      params.map do |key, value|
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
