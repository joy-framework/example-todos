(use joy)


(defn app [ctx]
  (def {:body body} ctx)

  (text/html
    (doctype :html5)
    [:html {:lang "en"}
     [:head
      [:title "todos"]
      [:meta {:charset "utf-8"}]
      [:meta {:name "viewport" :content "width=device-width, initial-scale=1"}]
      [:link {:href "/app.css" :rel "stylesheet"}]
      [:script {:src "/app.js" :defer ""}]]
     [:body body]]))
