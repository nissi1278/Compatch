if Rails.env.production?
  base_redirect_uri = "https://compatch.net/"
else
  base_redirect_uri = "http://localhost:3000"
end

Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer if Rails.env.development?
  provider :openid_connect, {
    name: :line,
    issuer: "https://access.line.me",
    discovery: true,
    response_type: :code,
    scope: [:openid, :profile],
    client_options: {
      identifier: Rails.application.credentials.fetch(:line).fetch(:channel_id),
      secret: Rails.application.credentials.fetch(:line).fetch(:channel_secret),
      redirect_uri: "#{base_redirect_uri}/auth/line/callback",
    },
  }
end