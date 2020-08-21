(use joy)


(route :get "/" :todos/index)
(route :get "/todos" :todos/index)
(route :get "/todos/new" :todos/new)
(route :post "/todos" :todos/create)
(route :get "/todos/:id" :todos/show)
(route :get "/todos/:id/edit" :todos/edit)
(route :patch "/todos/:id" :todos/patch)
(route :delete "/todos/:id" :todos/delete)


(def todo-params
  (params :todo
    (validates [:name] :required true)
    (permit [:name])))


(defn todos/index [request]
  (let [todos (db/from :todo :order "created_at desc")]
   [:div
    [:a {:href (url-for :todos/new)} "New todo"]
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
          [:a {:href (url-for :todos/show todo)} "Show"]]
         [:td
          [:a {:href (url-for :todos/edit todo)} "Edit"]]
         [:td
          (form-for [request :todos/delete todo]
           (submit "Delete"))]])]]]))


(defn todos/show [request]
  (def {:params params} request)

  (when-let [todo (db/find :todo (params :id))]
    [:div
     [:a {:href (url-for :todos/index)} "Back home"]

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
  (def {:errors errors} request)

  (form-for [request route todo]
    [:label {:for "name"} "name"]
    [:input {:type "text" :name "name" :value (get todo :name)}]
    [:div (get errors :name)]

    [:input {:type "submit" :value "Save"}]))


(defn todos/new [request]
  (form request :todos/create))


(defn todos/create [request]
  (def result (-> (todo-params request)
                  (db/insert)
                  (rescue)))

  (def [errors todo] result)

  (if errors
    (todos/new (put request :errors errors))
    (redirect-to :todos/index)))


(defn todos/edit [request]
  (def {:params params} request)

  (when-let [todo (db/find :todo (params :id))]
    (form request :todos/patch todo)))


(defn todos/patch [request]
  (def {:params params} request)

  (when-let [todo (db/find :todo (params :id))]
    (def result (->> (todo-params request)
                     (merge todo)
                     (db/update)
                     (rescue)))

    (def [errors todo] result)

    (if errors
      (todos/edit (put request :errors errors))
      (redirect-to :todos/index))))


(defn todos/delete [request]
  (def {:params params} request)

  (when-let [todo (db/find :todo (params :id))]
    (db/delete todo))

  (redirect-to :todos/index))
