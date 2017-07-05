defmodule Ace.Router do
  use Ace.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

	scope "/wire" do
		pipe_through :api

		get "/", Ace.PageController, :api
		post "/", Ace.PageController, :api
	end

  scope "/", Ace do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
end
