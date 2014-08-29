class SqlString

  attr_reader :sql_string

  def self.call(sql_string)
    new(sql_string).call
  end

  def initialize(sql_string)
    @sql_string = sql_string
  end

  def call
    operator = sql_string.scan(matchers)
    if operator.size == 1
      send operator_mapping[operator.first]
    end
  end


  private

  def operator_mapping
    {
      "<=" => :compare_query, ">=" => :compare_query, "<" => :compare_query,
      ">" => :compare_query, "=" => :equal_query, "!=" => :equal_query,
      "||" => :or_join, "&&" => :and_join, ":" => :like_query
    }
  end

  def matchers
    Regexp.union(/<=/, />=/, /</, />/, /=/, /!=/, /\|\|/, /&&/, /:/)
  end

  def like_query
    q = sql_string.split(":")
    jattr = sanitize(q[0].strip)
    arg = sanitize(q[1].strip)

    "(similarity((data->>#{jattr})::text, #{arg}) > .5 OR " +
    "(data->>#{jattr})::text ILIKE '%#{raw(arg)}%')"
  end

  def compare_query
    q = sql_string.gsub(/\s+/m, ' ').strip.split(" ")
    jattr = sanitize(q[0].strip)
    opp = sanitize(q[1].strip)
    arg = sanitize(q[2].strip)

    "(data->>#{jattr})::int #{opp!(opp)} #{arg}"
  end

  def equal_query
    q = sql_string.gsub(/\s+/m, ' ').strip.split(" ")
    jattr = sanitize(q[0].strip)
    opp = sanitize(q[1].strip)
    arg = sanitize(q[2].strip)

    "(data->>#{jattr})::text #{opp!(opp)} #{arg}"
  end

  def or_join
    " OR "
  end

  def and_join
    " AND "
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
