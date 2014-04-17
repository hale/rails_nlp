module RailsNlp
  FactoryGirl.define do
    factory :analysable, class: Analysable do |a|
      title "Title"
      content "Content"
    end

    factory :keyword, class: Keyword do |kw|
      name "name"
    end
  end
end
