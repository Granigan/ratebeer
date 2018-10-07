FactoryBot.define do
    factory :user do
      username { "Pekka" }
      password { "Foobar1" }
      password_confirmation { "Foobar1" }
    end

    factory :brewery do
      name { "anonymous" }
      year { 1900 }
    end

    factory :style do
      name { "anonymous" }
      description { "it's alright" }
    end

    factory :beer do
      name { "anonymous" }
      style { Style.create(name: "anonymous", description: '')}
      brewery
    end

    factory :rating do
      beer
    end
    
  end  