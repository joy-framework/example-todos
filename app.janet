(use joy)
(use ./html)


########################################
# Route Definitions
########################################


(route :get "/" :todos/index)
(route :get "/todos" :todos/index)
(route :get "/todos/new" :todos/new)
(route :post "/todos" :todos/create)
(route :get "/todos/:id" :todos/show)
(route :get "/todos/:id/edit" :todos/edit)
(route :patch "/todos/:id" :todos/patch)
(route :delete "/todos/:id" :todos/delete)


########################################
# Todos
########################################


(def todo/body
  (body :todo
    (validates [:name] :required true)
    (permit [:name])))


(defn todos/index [request]
  (let [todos (db/from :todo :order "created_at desc")]
   [:div
    (link-to "New todo" :todos/new)
    [:table
     [:thead
      [:tr
       [:th "id"]
       [:th "name"]
       [:th "completed-at"]
       [:th "created-at"]
       [:th "updated-at"]
       [:th]
       [:th]
       [:th]]]
     [:tbody
      (foreach [todo todos]
        [:tr
         [:td (todo :id)]
         [:td (todo :name)]
         [:td (todo :completed-at)]
         [:td (todo :created-at)]
         [:td (todo :updated-at)]
         [:td
          (link-to "Show" :todos/show todo)]
         [:td
          (link-to "Edit" :todos/edit todo)]
         [:td
          (form-to "Delete" request :todos/delete todo)]])]]]))


(defn todos/show [request]
  (def {:params params} request)

  (when-let [todo (db/find :todo (params :id))]
    [:div
     (link-to "Back home" :todos/index)

     [:table
      [:tr
       [:th "id"]
       [:th "name"]
       [:th "completed-at"]
       [:th "created-at"]
       [:th "updated-at"]]
      [:tr
       [:td (todo :id)]
       [:td (todo :name)]
       [:td (todo :completed-at)]
       [:td (todo :created-at)]
       [:td (todo :updated-at)]]]]))


(defn form [request route &opt todo]
  (let [{:errors errors} request]
    (form-for [request route todo]
      [:label {:for "name"} "name"]
      [:input {:type "text" :name "name" :value (get todo :name)}]
      [:div (get errors :name)]

      [:button {:type "submit"} "Save"])))


(defn todos/new [request]
  (form request :todos/create))


(defn todos/create [request]
  (let [todo (-> (todo/body request)
                 (db/save))]

    (if (saved? todo)
      (redirect-to :todos/index)
      (todos/new (put request :errors errors)))))


(defn todos/edit [request]
  (let [{:params params} request]
    (when-let [todo (db/find :todo (params :id))]
      (form request :todos/patch todo))))


(defn todos/patch [request]
  (when-let [{:params params} request
             todo (db/find :todo (params :id))
             todo (->> (todo/body request)
                       (merge todo)
                       (db/save))]

    (if (todo :errors)
      (todos/edit (put request :errors errors))
      (redirect-to :todos/index))))


(defn todos/delete [request]
  (def {:params params} request)

  (when-let [todo (db/find :todo (params :id))]
    (db/delete todo))

  (redirect-to :todos/index))


########################################
# Layout
########################################


(defn layout [{:body body :request request}]
  (text/html
    (doctype :html5)
    [:html {:lang "en"}
     [:head
      [:title "todos"]
      [:meta {:charset "utf-8"}]
      [:meta {:name "viewport" :content "width=device-width, initial-scale=1"}]
      [:meta {:name "csrf-token" :content (authenticity-token request)}]
      [:link {:href "/app.css" :rel "stylesheet"}]
      [:script {:src "/app.js" :defer ""}]]
     [:body body]]))


########################################
# Middleware
########################################


(def app (app {:layout layout}))
