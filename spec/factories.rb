module RailsNlp
  FactoryGirl.define do
    factory :analysable, class: Analysable do |a|
      title "Title"
      content "Content"

      after(:create) do
        Configurator.model_name = "analysable"
        Configurator.fields = ["title", "content"]
      end
    end
  end
end
