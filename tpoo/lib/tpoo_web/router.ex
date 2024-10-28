defmodule TpooWeb.Router do
  use TpooWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TpooWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TpooWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", TpooWeb do
    pipe_through :api

    # User routes
    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    post "/users", UserController, :create
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    #ticket router

    get "/tickets", TicketController, :index
    get "/tickets/:id", TicketController, :show
    delete "/tickets/:id", TicketController, :delete
    post "/tickets/:user_id", TicketController, :create


    # Working time routes
    get "/workingtime/:user_id", WorkingtimeController, :index  # Liste toutes les heures de travail d'un utilisateur
    get "/workingtime/:user_id/:id", WorkingtimeController, :show  # Récupère une heure de travail spécifique
    post "/workingtime/:user_id", WorkingtimeController, :create  # Crée une nouvelle heure de travail
    put "/workingtime/:user_id/:id", WorkingtimeController, :update  # Met à jour une heure de travail
    delete "/workingtime/:user_id/:id", WorkingtimeController, :delete  # Supprime une heure de travail

    # Clock routes
    get "/clocks/:user_id", ClockController, :show
    post "/clocks/:user_id", ClockController, :create
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:tpoo, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TpooWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
