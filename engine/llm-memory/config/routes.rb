# frozen_string_literal: true

LlmMemory::Engine.routes.draw do
  root "dashboard#show"

  namespace :api do
    namespace :v1 do
      get "facts/bronze", to: "facts#bronze"
      get "facts/bronze/:id", to: "facts#show_bronze"
      get "facts/silver", to: "facts#silver"
      get "facts/silver/:id", to: "facts#show_silver"

      resources :insights, only: %i[index show] do
        member do
          post :publish
        end
      end

      post "pipeline/collect", to: "pipeline#collect"
      post "pipeline/process_silver", to: "pipeline#process_silver"
      post "pipeline/process_gold", to: "pipeline#process_gold"
      post "pipeline/run_all", to: "pipeline#run_all"
    end
  end
end
