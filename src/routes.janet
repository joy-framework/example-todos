(import joy :prefix "")
(import ./routes/todo :as todo)


(defroutes app
  [:get "/" todo/index]

  [:get "/todo" todo/index]
  [:get "/todo/new" todo/new]
  [:post "/todo" todo/create]
  [:get "/todo/:id" todo/show]
  [:get "/todo/:id/edit" todo/edit]
  [:patch "/todo/:id" todo/patch]
  [:delete "/todo/:id" todo/destroy])
