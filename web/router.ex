defmodule Hnet.Router do
  use Hnet.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Hnet.Account.AssignUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Hnet do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", AuthController, :signin
    post "/login", AuthController, :login
    post "/logout", AuthController, :logout
    resources "/hospitals", HospitalController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Hnet do
  #   pipe_through :api
  # end
end
