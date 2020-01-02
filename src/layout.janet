(import joy :prefix "")

(defn app [response]
  (let [{:body body} response]
    (respond :html
      (html
       (doctype :html5)
       [:html {:lang "en"}
        [:head
         [:meta {:charset "utf-8"}]
         [:meta {:name "viewport" :content "width=device-width, initial-scale=1"}]
         [:link {:href "/app.css" :rel "stylesheet"}]
         [:title "todos"]]
        [:body
         body
         [:script {:src "/app.js"}]]]))))
