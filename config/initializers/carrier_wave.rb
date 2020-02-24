if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      region: 'ap-northeast-1',
      aws_access_key_id: 'AKIA2EMMD6ROMIV42G7N',
      aws_secret_access_key: 'LqoyS5Yl+QYFvaFtF5fIGyd8JPS+NHBBjKK4nOKI'
    }

    config.fog_directory  = 'rails-insta-sample'
    config.cache_storage = :fog
  end
end