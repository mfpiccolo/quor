class Searcher

  # TODO rely on AREL or sequel gem
  # get the tree structure and then parse the tree and constuct the sql to build
  # the sql using the json attrs

  Operators = ["<=", ">=", "<", ">", "=", "!=", "(", ")"]

  attr_reader :user, :type, :query_string, :query_array, :scope, :sql_string, :sql_array, :final_scope

  def self.call(user, type, query_string)
    new(user, type, query_string).call
  end

  def initialize(user, type, query_string)
    @user = user
    @type = type
    @query_string = query_string
    @sql_string = ""
    @sql_array = []
  end

  def call
    build_sql_array(query_string)
    build_sql_string
    scope = @user.models.where(otype: type)
    @final_scope = scope.where(@final_sql_array.join(""))
    self
  end

  private

  def build_sql(array)
    array.each do |string|
      build_sql_array(string)
    end
  end

  def build_sql_array(string, parens: false)
    ordered_ops_array = string.to_enum(:scan, /(\(.+\)|\|{2}|&&|[^|&]*)/)
      .map { Regexp.last_match }.map(&:to_s).delete_if(&:empty?)
    if parens
      @count = ordered_ops_array.size
    end

    if string.size == ordered_ops_array.first.size && string.include?("(") && string.include?(")")
      sql_array << "("
      build_sql_array(string[1..-2], parens: true)
    elsif ordered_ops_array.length == 1
      sql_array << string
      if @count.present?
        @count -= 1
        sql_array << ")" if @count == 0
      end
    else
      build_sql ordered_ops_array
    end
  end

  def build_sql_string
    @final_sql_array = sql_array.map(&:strip).map do |string|
      SqlString.call(string)
    end
  end

  def sanitize(string)
    Model.sanitize(string)
  end

  def raw(string)
    string[1..(string.length - 2)]
  end

  def opp!(opp)
    unless ["'='", "'!='", "'<'", "'>'", "'<='", "'>='", "'IN'"].any? { |o| o == opp }
      raise "YOU ARE TRYING TO SQL INJECT!"
    end
    raw(opp)
  end

end








