RSpec.describe Kolo::Template do
  let(:output_dir) { File.join(File.dirname(__FILE__), "..", "..", "output") }
  let(:src) { File.join(File.dirname(__FILE__), "..", "..", "fixtures", "template.rb.tt") }
  let(:dest) { File.join(output_dir, "template.rb") }
  let(:params) {
    {
      pokemon: "magikarp",
      lvl: 100
    }
  }

  def setup
    FileUtils.mkdir(output_dir)
  end

  def cleanup
    FileUtils.rm_r(output_dir) if File.exist?(output_dir)
  end

  subject(:subject_call) { described_class.new(params).call(src, dest) }

  before(:each) { setup }
  after(:each) { cleanup }

  context "success" do
    it "renders the output file based on the specified template" do
      subject_call
      expect(File.read(dest)).to eql("#{params[:pokemon]}\n#{params[:lvl]}")
    end

    context "when supplied params are invalid" do
      let(:params) {
        {
          invalid: "params"
        }
      }

      it "does not raise an error" do
        expect { subject_call }.to_not raise_error
      end
    end # context "when supplied params are invalid"
  end # context "success"

  context "error" do
    context "when template file doesn't exist" do
      let(:src) { File.join(File.dirname(__FILE__), "..", "..", "fixtures", "invalid.rb.tt") }

      it "raises an error" do
        expect { subject_call }.to raise_error(StandardError)
      end
    end # context "when template file doesn't exist"
  end # context "error"
end
