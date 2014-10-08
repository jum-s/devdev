FactoryGirl.define do
  factory :twtlink do
    url "foo"
  end

  factory :post do
  end

  factory :autopost do
    url "foo"
  end

  factory :pensee do
    text "foo, bar, baz"
  end

  factory :admin_user do
    encrypted_password 'foo'
    password 'truc'
    password_confirmation 'truc'
    email "people#{n}@laposte.net"
  end
end


