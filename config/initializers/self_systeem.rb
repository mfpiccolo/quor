SelfSysteem.configure do |config|
   # uncomment line below if using rspec
   # config.test_framework = "rspec"

   config.test_dir = "test" # specify directory which you hold your tests
   config.match_body_text = true
   config.match_status = true
   # WARNING! These make tests very brittle
   # config.match_relevant_instance_variables = true
   # config.match_instance_variable_objects = true
   # config.match_templates = true
 end
