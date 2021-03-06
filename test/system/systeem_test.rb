require "test_helper"
require "./" + SelfSysteem.test_dir + "/system/support/systeem_config.rb"

SysteemConfig::Features.each do |f|

  describe "start_db_cleaner" do
    it {
      DatabaseCleaner.start
      DatabaseCleaner.clean
    }
  end

  # Load database if _db exists
  file_hash = YAML.load_file f

  if file_hash[:requirements].last.present?
    db_filename = "./" + SelfSysteem.test_dir + "/system/support/affirmations/" + file_hash[:requirements].last + "_db.yml"
    session_filename = "./" + SelfSysteem.test_dir + "/system/support/affirmations/" + file_hash[:requirements].last + "_session.yml"
  end

  file_hash[:affirmations].each_with_index do |a, i|
    describe a[:controller_class_name].constantize do
      self.use_transactional_fixtures = false
      before do
        # If it is ths first run, set the session and the database
        if file_hash[:requirements].present? && i == 0 && File.exist?(db_filename) && File.exist?(session_filename)
          saved_session = YAML.load_file(session_filename).reject {|k| k.to_s.match(/session_id|_csrf_token/)}
          SysteemConfig::Session.merge!(saved_session)
          YamlDbSynch.load(db_filename)
        end

        Rails.application.load_seed

        # Only needed if devise
        @request.env["devise.mapping"] = Devise.mappings[:user] if defined? Devise

        if a[:request_parameters].keys.include?("file") && a[:request_parameters]["file"].present?
          file_info = a[:request_parameters]["file"]
          filename = file_info["filename"]
          upload = ActionDispatch::Http::UploadedFile.new({
            :filename => filename,
            :content_type => file_info["content_type"],
            :tempfile => File.new("#{Rails.root}/test/system/support/files/#{filename}")
          })

          a[:request_parameters]["file"] = upload
        end

        send(a[:request_method].downcase.to_sym, a[:action], a[:request_parameters], SysteemConfig::Session)
        SysteemConfig::Session.merge! session
      end

      it "#{f.inspect} - #{a[:controller_class_name]} - #{a[:action]}" do
        controller_instance = response.request.env["action_controller.instance"] ||
          self.instance_variable_get(:@controller)
        builder = SelfSysteem::InstanceVariablesBuilder.call(controller_instance)
        relevant_instance_variables = builder.relevant_instance_variables
        instance_variable_objects = builder.instance_variable_objects

        if SelfSysteem.match_body_text && !(a[:body_text] == "*skip")
          if a[:body_text].present?
            assert_match(/#{a[:body_text].join("|")}/, controller_instance.response.body)
          else
            raise "Need to add body text to match against in " + f.inspect
          end
        end
        assert_response a[:status] if SelfSysteem.match_status
        assert_equal(JSON.parse(a[:relevant_instance_variables])
          .to_set, relevant_instance_variables.to_set) if SelfSysteem.match_relevant_instance_variables
        assert_equal(a[:instance_variable_objects], instance_variable_objects) if SelfSysteem.match_instance_variable_objects
        assert_equal(a[:templates].keys, @_templates.keys) if SelfSysteem.match_templates
      end
    end
  end

  describe "db_cleaner_clean" do
    it {
      DatabaseCleaner.start
      DatabaseCleaner.clean
    }
  end
end
