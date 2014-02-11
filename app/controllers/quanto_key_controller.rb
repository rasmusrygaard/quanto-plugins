class QuantoKeyController < ApplicationController

  # The callback URL will be of the form /auth/quanto_XXX/callback where XXX is the name of a third
  # party provider. For instance, the callback for the Fitbit plugin should be
  # /auth/quanto_fitbit/callback. We can use this string to detect which plugin was authorized.
  def create
    auth = request.env["omniauth.auth"]
    key = OauthKey.create({
      provider: auth.provider,
      uid: auth.uid,
      token: auth.credentials.token,
      plugin: params[:provider],
    })
    key.save!

    mapping = Mapping.create!(quanto_key: key)
    session[:quanto_key_id] = key.id

    case params[:provider].to_sym
    when :fitbit
      redirect_to '/auth/fitbit'
    when :lastfm
      redirect_to '/auth/lastfm'
    when :instagram
      redirect_to '/auth/instagram'
    end
  end

end
