Rails.application.config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
  rewrite %r{/api(.*)}, '$1'
end
