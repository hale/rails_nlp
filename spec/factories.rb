module RailsNlp
  FactoryGirl.define do
    factory :analysable_mock, class: AnalysableMock do |a|
      title "Title"
      content "Content"

      after(:create) do
        Configurator.model_name = "analysable_mock"
        Configurator.fields = ["title", "content"]
      end
    end
  end
end
