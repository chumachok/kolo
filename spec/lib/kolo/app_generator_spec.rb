RSpec.describe Kolo::AppGenerator do
  let(:app_name) { "my_awesome_blog" }
  let(:config_file) { File.join(File.dirname(__FILE__), "..", "..", "fixtures", "config.json") }
  let(:template_dir) { File.join(File.dirname(__FILE__), "..", "..", "fixtures") }
  let(:template) { instance_double(Kolo::Template, call: true) }
  let(:template_class) { class_double(Kolo::Template, new: template) }

  def cleanup
    FileUtils.rm_r(app_name) if File.exist?(app_name)
  end

  subject(:subject_call) {
    described_class.new(
      app_name: app_name,
      config_file: config_file,
      template_dir: template_dir,
      template_class: template_class
    ).call
  }

  before(:each) do
    allow(template_class).to receive(:new).and_return(template)
    allow(template).to receive(:call).and_return(true)
  end

  after(:each) { cleanup }

  context "success" do
    it "creates app structure" do
      subject_call
      expect(File.directory?(File.join(app_name, "test_dir"))).to be(true)
    end

    it "generates files" do
      subject_call
      expect(File.read(File.join(app_name, "file.rb"))).to eql("hello world")
    end

    it "generates .keep files in empty directories" do
      subject_call
      expect(File.exist?(File.join(app_name, "test_dir", ".keep"))).to be(true)
    end

    it "initializes a git repository" do
      subject_call
      expect(File.exist?(File.join(app_name, ".git", "config"))).to be(true)
    end

    it "calls template class to render a template" do
      subject_call
      expect(template_class).to have_received(:new).with({})
      expect(template).to have_received(:call).with(File.join(template_dir,"template.rb.tt"), File.join(app_name, "template.rb"))
    end
  end # context "success"

  context "error" do
    context "when app was previously created" do
      before(:each) { FileUtils.mkdir(app_name) }

      it "raises Kolo::AppExistsError error with a meaninful error message" do
        expect{ subject_call }.to raise_error(Kolo::AppExistsError,/error when generating application: application already exists at/)
      end
    end # context "when app was previously created"

    context "when configuration file is missing" do
      let(:config_file) { File.join(File.dirname(__FILE__), "..", "..", "fixtures", "non_existing_config.json") }

      it "raises Kolo::InvalidConfigurationError error with a meaninful error message" do
        expect{ subject_call }.to raise_error(Kolo::InvalidConfigurationError,
          "error when attempting to parse configuration file: file is missing or invalid")
      end
    end # context "when configuration file is missing"

    context "when app configuration is invalid" do
      let(:config_file) { File.join(File.dirname(__FILE__), "..", "..", "fixtures", "invalid_values_config.json") }

      it "raises Kolo::InvalidConfigurationError error with a meaninful error message" do
        expect{ subject_call }.to raise_error(Kolo::InvalidConfigurationError,
          "configuration file is invalid: configuration for 'template files' is missing or invalid")
      end
    end # context "when app configuration is invalid"

    context "when template is missing" do
      let(:config_file) { File.join(File.dirname(__FILE__), "..", "..", "fixtures", "invalid_keys_config.json") }

      it "raises Kolo::TemplateError error with a meaninful error message" do
        expect{ subject_call }.to raise_error( Kolo::TemplateError,
          "template error: template is missing at #{File.join(template_dir, "not_file.rb.tt")}")
        # expect{ subject_call }.to raise_error(Kolo::TemplateError, "template error: template is missing at #{File.join(template_dir, "not_file.rb.tt")}")
      end
    end # context "when template is missing"
  end # context "error"
end
