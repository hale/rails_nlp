
FactoryGirl.define do
  factory :wordcount do
    record
    keyword
    count 10
  end

  factory :keyword do
    name "registration"
    metaphone ["RJST", "RKST"]
    stem "regist"
    synonyms ['enrollment', 'enrolment', 'adjustment', 'readjustment', 'body', 'calibration', 'certificate', 'certification', 'credential', 'credentials', 'entering', 'entrance', 'entry', 'incoming', 'ingress', 'sound property', 'standardisation', 'standardization']
  end
end

