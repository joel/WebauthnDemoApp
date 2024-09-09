class LintFactoryTest < ActiveSupport::TestCase
  FactoryBot.factories.each do |factory|
    describe "The #{factory.name} factory" do
      it "lints #{factory.name}" do
        expect(FactoryBot.lint([factory])).to be_nil
      end
    end
  end
end
