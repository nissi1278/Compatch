Rails.application.config.session_store :cookie_store, 
key: '_compatch_session', expire_after: 20.years, secure: Rails.env.production? || Rails.env.staging?