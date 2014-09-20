class AttributeNameSuggestion
  attr_reader :header, :message, :result

  def self.call(header)
    new(header).call
  end

  def initialize(header)
    @header = header
  end

  def call
    match = header.scan(matchers).last
    if mapping = header_mappings[match]
      @message = mapping[:message]
      @result = mapping[:result]
    end
    self
  end

  private

  def header_mappings
    {
      "id" => {result: "external_id", message: "This is your models primary key.  Becaue Intrisic assigns each model its own primary key, this imported key will be saved as external_id"},
      "_id" => {result: header, message: "Fields that end with _id will be treated as foreign key fields.  This means they will reffer to the other models are thier parent.  i.e (A request could reffer to its parent order using the foreign key order_id)"},
      "_at" => {result: header, message: "Fields that end with _at will be treated as timestamp fields.  A timestamp field needs to be formated like so: 'YYYY-MM-DD HH:MM:SS' if you want to use the awesome-sause that Intrisic provides"},
      "date" => {result: "change_me_on", message: "Date fields need to end with '_on' and data must be formated using 'YYYY-MM-DD' or the date will just be treated as a string"},
      "time" => {result: "change_me_at", message: "Fields that end with _at will be treated as timestamp fields.  A timestamp field needs to be formated like so: 'YYYY-MM-DD HH:MM:SS' if you want to use the awesome-sause that Intrisic provides"},
      "created_at" =>{result: "external_created_at", message: "Good job! You are using proper conventions for naming your timestamps.  The problem is so are we.  We will be prefixing your date field with 'external_'"},
      "updated_at" =>{result: "external_updated_at", message: "Good job! You are using proper conventions for naming your timestamps.  The problem is so are we.  We will be prefixing your date field with 'external_'"},
    }
  end

  def matchers
    Regexp.union(/created_at/, /updated_at/,/id/, /_id$/, /_at$/, "date$")
  end

end
