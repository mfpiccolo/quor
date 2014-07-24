class Searcher

  attr_reader :user, :type, :query_string, :query_array, :scope, :sql_string

  def self.call(user, type, query_string)
    new(user, type, query_string).call
  end

  def initialize(user, type, query_string)
    @user = user
    @type = type
    @query_string = query_string
    @sql_string = ""
  end

  def call
    if ["&&", "||", ":"].any? { |join| query_string.include? join }
      build_query_array
      scope = @user.models.where(otype: type)
      build_sql_string(query_array)
      scope.where(sql_string)
    else
      @user.models.where(otype: type).search_data(query_string)
    end
  end

  private

  def build_query_array
    @query_array = query_string.split("||").map do |queries|
      if queries.include?("(") && queries.include?(")")
        a = []
        queries.scan(/\(([^\)]+)\)/).flatten.first.split("&&").each do |q_string|
          pair_array = q_string.split(":")
          a << Hash[pair_array[0].strip, pair_array[1].strip]
        end
        a
      elsif queries.include?("&&")
        a = []
        queries.split("&&").each do |q_string|
          pair_array = q_string.split(":")
          a << Hash[pair_array[0].strip, pair_array[1].strip]
        end
        a
      else
        pair_array = queries.split(":")
        Hash[pair_array[0].strip, pair_array[1].strip]
      end
    end
  end

  def build_sql_string(array, join = " OR ")
    array.each_with_index do |h,i|
      if h.is_a? Array
        build_sql_string(h, " AND ")
      else
        query = "(((to_tsvector('simple', coalesce(data ->> '#{h.keys.first}', ''))) @@ (to_tsquery('simple', ''' ' || '#{h.values.first}' || ' '''))))"

        if i == 0
          sql_string << query
        else
          sql_string << join + query
        end
      end
    end
  end

end
