Rails.application.routes.draw do
  get '/' => 'poker#check_form'
  post 'check' => 'poker#check'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
