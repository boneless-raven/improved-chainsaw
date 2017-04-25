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
    get "/patient", PageController, :patient
    get "/admin", PageController, :administrator
    resources "/hospitals", HospitalController
  end

  scope "/", Hnet.Account do
    pipe_through :browser

    get "/login", AuthController, :signin
    post "/login", AuthController, :login
    post "/logout", AuthController, :logout
    resources "/users", UserController, only: [:index, :show, :delete]
  end

  scope "/registration", Hnet.Account do
    pipe_through :browser

    get "/patient", RegistrationController, :new_patient
    post "/patient", RegistrationController, :create_patient
  end

  # Other scopes may use custom stacks.
  # scope "/api", Hnet do
  #   pipe_through :api
  # end
end
