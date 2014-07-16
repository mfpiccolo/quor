Pliable.configure do |config|
  # define extra scrubbing for ply_name here.  This is for the purpose of making scopes.
  # For instance, if your models ply name is something like 'Invoice__c'
  # you will need to gsub '__c' off the end:
  # config.added_scrubber {|name| name.gsub('__c', '') }
end