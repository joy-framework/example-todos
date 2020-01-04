(import joy :prefix "")


(defn todo [request]
  (let [db (get request :db)
        id (get-in request [:params :id])]
    (fetch db [:todo id])))


(defn index [request]
  (let [{:db db} request
        todos (fetch-all db [:todo])]
   [:div
    [:a {:href (url-for :todo/new)} "New todo"]
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
      (map
       (fn [{:id id :name name :completed-at completed-at :created-at created-at :updated-at updated-at}]
         [:tr
          [:td id]
          [:td name]
          [:td completed-at]
          [:td created-at]
          [:td updated-at]
          [:td
           [:a {:href (url-for :todo/show {:id id})} "Show"]]
          [:td
           [:a {:href (url-for :todo/edit {:id id})} "Edit"]]
          [:td
           (form-for [request :todo/destroy {:id id}]
            (submit "Delete"))]])
       todos)]]]))


(defn show [request]
  (when-let [todo (todo request)
             {:id id :name name :completed-at completed-at :created-at created-at :updated-at updated-at} todo]
    [:table
     [:tr
      [:th "id"]
      [:th "name"]
      [:th "completed-at"]
      [:th "created-at"]
      [:th "updated-at"]]
     [:tr
      [:td id]
      [:td name]
      [:td completed-at]
      [:td created-at]
      [:td updated-at]]]))


(def params
  (params
    (validates [:name] :required true)
    (permit [:name :completed-at])))


(defn form [request route]
  (let [todo (todo request)]
    (form-for [request route todo]
      (label :name)
      (text-field todo :name)
      (let [name-error (get-in request [:errors :name])]
        [:div (or name-error "")])

      (label :completed-at)
      (text-field todo :completed-at)
      (let [completed-at-error (get-in request [:errors :completed-at])]
        [:div (or completed-at-error "")])

      (submit "Save"))))


(defn new [request]
  (form request :todo/create))


(defn create [request]
  (let [{:db db} request
        result (->> (params request)
                    (insert db :todo)
                    (rescue))
        [errors todo] result]
    (if (nil? errors)
      (redirect-to :todo/index)
      (new (put request :errors errors)))))


(defn edit [request]
  (form request :todo/patch))


(defn patch [request]
  (let [{:db db} request
        todo (todo request)
        result (->> (params request)
                    (update db :todo todo)
                    (rescue))
        [errors todo] result]
    (if (nil? errors)
      (redirect-to :todo/index)
      (edit (put request :errors errors)))))


(defn destroy [request]
  (let [{:db db} request
        todo (todo request)]
    (delete db :todo todo)
    (redirect-to :todo/index)))
