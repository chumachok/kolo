RSpec.describe Kolo::CLI do
  let(:command) { "new" }
  let(:app_name) { "my_awesome_app" }
  let(:options) {
    {
      config_file: File.join("path", "to", "config_file"),
      template_dir: File.join("path", "to", "template_file"),
    }
  }
  let(:app_generator) { instance_double(Kolo::AppGenerator, call: true) }
  let(:app_generator_class) { class_double(Kolo::AppGenerator, new: app_generator) }

  subject(:subject_call) {
    described_class.new(
      command: command,
      app_name: app_name,
      options: options,
      app_generator_class: app_generator_class
    ).call
  }

  before(:each) do
    allow(app_generator_class).to receive(:new).and_return(app_generator)
    allow(app_generator).to receive(:call).and_return(true)
  end

  context "success" do
    it "calls app generator" do
      subject_call
      expect(app_generator_class).to have_received(:new).with(app_name: app_name, config_file: options[:config_file], template_dir: options[:template_dir])
      expect(app_generator).to have_received(:call)
    end

    context "when config file is not provided" do
      let(:options) {
        {
          config_file: nil,
          template_dir: File.join("path", "to", "template_file")
        }
      }

      it "calls app generator with default config file" do
        subject_call
        expect(app_generator_class).to have_received(:new).with(app_name: app_name, config_file: described_class::DEFAULT_CONFIG_FILE, template_dir: options[:template_dir])
        expect(app_generator).to have_received(:call)
      end
    end # context "when config file is not provided"

    context "when template dir is not provided" do
      let(:options) {
        {
          config_file: File.join("path", "to", "config_file"),
          template_dir: nil,
        }
      }

      it "calls app generator with default template dir" do
        subject_call
        expect(app_generator_class).to have_received(:new).with(app_name: app_name, config_file: options[:config_file], template_dir: described_class::DEFAULT_TEMPLATE_DIR)
        expect(app_generator).to have_received(:call)
      end
    end # context "when template dir is not provided"
  end # context "success"

  context "error" do
    context "when command is invalid" do
      let(:command) { "invalid" }

      it "raises Kolo::InvalidCommandError error" do
        expect { subject_call }.to raise_error(Kolo::InvalidCommandError)
      end
    end # context "when command is invalid"

    context "when app name is invalid" do
      let(:app_name) { "bl0g" }

      it "raises Kolo::InvalidInputError error with a descriptive message" do
        expect { subject_call }.to raise_error(Kolo::InvalidInputError, "app name must contain lowercase letters or underscore character only")
      end
    end # context "when app name is invalid"
  end # context "error"
end
