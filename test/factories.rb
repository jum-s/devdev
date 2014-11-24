FactoryGirl.define do
  factory :twtlink do
    url "http://techcrunch.com/2014/10/11/the-internet-of-someone-elses-things/"
  end

  factory :post do
  end

  factory :autopost do
    url "http://techcrunch.com/2014/10/11/the-internet-of-someone-elses-things/"
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


