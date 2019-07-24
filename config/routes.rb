Rails.application.routes.draw do
  get '/' => 'poker#top'
  post 'check' => 'poker#check'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
