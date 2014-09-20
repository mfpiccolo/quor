class AttributeValueSuggestion
  attr_reader :value, :message, :result

  def self.call(value)
    new(value).call
  end

  def initialize(value)
    @value = value
  end

  def call
    result = typecast_string
    if mapping = type_mapping[result]
      @message ||= mapping[:message]
      @result = mapping[:result]
    end
    self
  end

  private

  def type_mapping
    {
      "Integer" => {result: "Integer", message: "This field look like an Integer.  We will save it as an Integer for you"},
      "Float" => {result: "Float", message: "This field looks like a float.  We will save it as a Float for you"},
      "DateTime" => {result: "DateTime", message: "We were able to successfully parse this sample data as a DateTime field.  Make sure you name it properly by appending '_at' and stay with this format"},
      "Date" => {result: "Date", message: "We were able to successfully parse this sample data as a Date field.  Make sure you name it properly by appending '_on' and stay with this format"},
      "String" => {result: "String", message: "We cannot find any matching data type for this attribute so we are going to make it a String"},
      "Text" => {result: "Text", message: "This string is pretty long.  We are going to use a Text Field for this attribute."},
      "DateParseError" => {result: "String", message: "We were unable to parse this field as a Date or DateTime. :(  Please use these formats for DateTime and Date respectively: 'YYYY-MM-DD HH:MM:SS', 'YYYY-MM-DD'.  This is Very important stuff because you will not be able to use filters and workflows with this date field unless it is properly formated!"},
    }
  end

  def typecast_string
    begin
      if value.scan(integer_regex).compact.flatten.first.present? && value.length == value.scan(integer_regex).compact.flatten.first.length
        "Integer" if Integer(value)
      elsif value.scan(float_regex).compact.flatten.first.present? && value.length == value.scan(float_regex).compact.flatten.first.length
        "Float" if Float(value)
      elsif value.scan(time_regex).compact.flatten.first.present?
        "DateTime" if DateTime.parse(value)
      elsif value.scan(date_regex).compact.flatten.first.present?
        "Date" if Date.parse(value)
      elsif value.length <= 255
        "String"
      else
        "Text"
      end
    rescue ArgumentError => e
      if e.message == "invalid date"
        "DateParseError"
      end
    end
  end

  def integer_regex
    /\A[-+]?[0-9]+\z/
  end

  def float_regex
    /[-+]?([0-9]*\.[0-9]+|[0-9]+)/
  end

  def time_regex
    /((((19|20)([2468][048]|[13579][26]|0[48])|2000)-02-29|((19|20)[0-9]{2}-(0[4678]|1[02])-(0[1-9]|[12][0-9]|30)|(19|20)[0-9]{2}-(0[1359]|11)-(0[1-9]|[12][0-9]|3[01])|(19|20)[0-9]{2}-02-(0[1-9]|1[0-9]|2[0-8])))\s([01][0-9]|2[0-3]):([012345][0-9]):([012345][0-9]))/
  end

  def date_regex
    /(\d{1,2}[-\/]\d{1,2}[-\/]\d{4})|(\d{4}[-\/]\d{1,2}[-\/]\d{1,2})/
  end

end
